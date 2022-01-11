import os.path

from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import _tree
from numpy import binary_repr
import re
import argparse
import pickle
import logging
import numpy as np


def logging_cfg(logger_name, logfile):
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    simple_formatter = logging.Formatter('')
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(simple_formatter)
    stream_handler.setLevel(logging.INFO)
    file_handler = logging.FileHandler(logfile, mode='w')
    file_handler.setFormatter(simple_formatter)
    file_handler.setLevel(logging.DEBUG)
    # add handlers to logger
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)
    return logger


def get_tb_text(input_width_dict, sim_period, input_tb_file, output_tb_file, output_width_dict):

    inp_regs_decl = '\n'.join([
        f'reg [{width - 1}:0] {inp}_reg;' for inp, width in input_width_dict.items()
    ])
    inp_wire_decl = '\n'.join([
        f'wire [{width - 1}:0] {inp};' for inp, width in input_width_dict.items()
    ])

    outname = next(iter(output_width_dict.keys()))
    outwidth = output_width_dict[outname]

    dut_inputs_decl = ', '.join(input_width_dict.keys())
    fscanf1 = '\\t'.join(['%d'] * len(input_width_dict))
    fscanf2 = ', '.join([f'{inp}_reg' for inp in input_width_dict])

    assign_regs_to_wires = '\n'.join([
        f'assign {inp} = {inp}_reg;' for inp in input_width_dict
    ])

    tb = f"""
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = {sim_period};
localparam halfperiod = period/2;

{inp_regs_decl}
{inp_wire_decl}
wire [{outwidth - 1}:0] {outname};

integer fin, fout, r;

top DUT ({dut_inputs_decl}, {outname});

//read inp
initial begin
    $display($time, " << Starting the Simulation >>");
    fin = $fopen("{input_tb_file}", "r");
    if (fin == `NULL) begin
        $display($time, " file not found");
        $finish;
    end
    fout = $fopen("{output_tb_file}", "w");
    forever begin
        r = $fscanf(fin,"{fscanf1}\\n", {fscanf2});
        #period $fwrite(fout, "%d\\n", {outname});
        if ($feof(fin)) begin
            $display($time, " << Finishing the Simulation >>");
            $fclose(fin);
            $fclose(fout);
            $finish;
        end
    end
end

{assign_regs_to_wires}

endmodule
"""
    return tb


def create_inputs_file(inputs_file, input_width_dict, num_inputs=100000):
    input_vectors = []
    for inp, bitwidth in input_width_dict.items():
        input_vectors.append(
            np.random.randint(0, 2**bitwidth-1, num_inputs, dtype=np.uint64)
        )
    with open(inputs_file, "w") as fin:
        for i in range(num_inputs):
            line = [str(vector[i]) for vector in input_vectors]
            fin.write('\t'.join(line))
            fin.write("\n")


def natural_sort_key(s):
    _nsre = re.compile('([0-9]+)')
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split(_nsre, s)]


def get_width(a):
    return int(a).bit_length()


def to_fixed(f,e):
    a = f * (2**e)
    b = int(round(a))
    if a < 0:
        # next three lines turns b into it's 2's complement.
        b = abs(b)
        b = ~b
        b = b + 1
    return b


def tree_to_code(tree, inp_widths, comp_bits, inpprefix, outname, tb_inputs_file, overwrite_inputs=False):
    tree_ = tree.tree_
    out_width = get_width(max(tree.classes_))
    feature_name = [
        inpprefix + str(i) if i != _tree.TREE_UNDEFINED else ''
        for i in tree_.feature 
    ]
    # keep unique features as inputs
    inputs = sorted(set(filter(None, feature_name)), key=natural_sort_key)  # filter removes empty strings
    inp_width = dict(zip(inputs, inp_widths))
    logger_v.info("module top({}, {out});".format(", ".join(inputs), out=outname))

    for iname, iwidth in inp_width.items():
        logger_v.info("input [{d}:0] {name};".format(d=iwidth - 1, name=iname))
    logger_v.info("output [{d}:0] {name};".format(d=out_width - 1, name=outname))
    logger_v.info("assign {name} = " .format(name=outname))

    comp_bits = iter(comp_bits)
    def recurse(node, depth):
        indent = "  " * depth
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            node_bits = next(comp_bits)
            threshold = to_fixed(tree_.threshold[node], node_bits)

            if node_bits == inp_width[name]:
                logger_v.info("{} ({} <= {})?".format(indent, name, threshold))
            elif node_bits < inp_width[name]:
                logger_v.info("{} ({}[{}:{}] <= {})?".format(
                    indent, name, inp_width[name] - 1, inp_width[name] - node_bits, threshold
                ))
            else:
                raise ValueError(f"Invalid number of bits {comp_bits}, larger than input width {inp_width[name]}")

            recurse(tree_.children_left[node], depth + 1)
            logger_v.info("{}:".format(indent))
            recurse(tree_.children_right[node], depth + 1)
        else:
            logger_v.info("{}{}".format(indent, int(max(tree_.value[node][0])) ))

    recurse(0, 1)
    logger_v.info(";")
    logger_v.info("endmodule")
    print()

    # build testbench file
    if overwrite_inputs:
        create_inputs_file(inputs_file=tb_inputs_file, input_width_dict=inp_width)

    tb_output_file = tb_inputs_file.replace('inputs', 'output')
    tb_text = get_tb_text(
        input_width_dict=inp_width,
        sim_period=0,
        input_tb_file=tb_inputs_file,
        output_tb_file=tb_output_file,
        output_width_dict={outname: out_width}
    )
    logger_tb.info(tb_text)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--results-dir", "-rd", dest='results_dir',
                        help="Specify the directory contnaining the pickled tree object (and optionally the"
                             " feature bitwidths)")
    parser.add_argument("--verilog-file", "-v", dest='verilog_file',
                        help='Specify the output verilog file')
    parser.add_argument('--tb-inputs-file', '-tbi', dest='inputs_file', default='./sim/inputs.txt',
                        help="Specify the file where testbench inputs will be written. Default is './sim/inputs.txt'")
    parser.add_argument('--new-inputs', action='store_true', dest='new_inputs',
                        help='Set to overwrite the specified inputs file for the testbench.')

    args = parser.parse_args()

    # configure inputs file for the testbench
    assert 'inputs' in args.inputs_file
    assert os.path.exists(args.inputs_file) or args.new_inputs

    # configure results directory
    assert args.results_dir is not None and args.verilog_file is not None
    args.results_dir = args.results_dir[:-1] if args.results_dir[-1] == '/' else args.results_dir
    assert '.v' in args.verilog_file
    args.tb_file = args.verilog_file.replace('.v', '_tb.v')

    # logger are responsible for writing verilog files
    logger_v = logging_cfg('verilog', args.verilog_file)
    logger_tb = logging_cfg('tb', args.tb_file)

    with open(f'{args.results_dir}/dtree.pkl', "rb") as f:
        tr = pickle.load(f)

    try:
        with open(f"{args.results_dir}/inp_bits.pkl", "rb") as f:
           comp_bits = pickle.load(f)
    except FileNotFoundError:
        comp_bits = [8] * len([feature for feature in tr.tree_.feature if feature != _tree.TREE_UNDEFINED])

    inp_widths = [8] * len({feature for feature in tr.tree_.feature if feature != _tree.TREE_UNDEFINED})
    
    tree_to_code(
        tree=tr,
        inp_widths=inp_widths,
        comp_bits=comp_bits,
        inpprefix="X",
        outname="out",
        tb_inputs_file=args.inputs_file,
        overwrite_inputs=args.new_inputs
    )
