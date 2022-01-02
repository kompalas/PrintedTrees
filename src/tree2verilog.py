from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import _tree
from numpy import binary_repr
import re
import argparse
import pickle
import logging


logger = logging.getLogger(__name__)


def logging_cfg(logfile):
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
    return


def natural_sort_key(s):
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split(_nsre, s)]


def get_width (a):
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


def tree_to_code(tree, inp_width, inpprefix, outname):
    tree_ = tree.tree_
    out_width = get_width(max(tree.classes_))
    feature_name = [
        inpprefix + str(i) if i != _tree.TREE_UNDEFINED else ''
        for i in tree_.feature
    ]
    inputs = sorted(set(filter(None, feature_name)), key=natural_sort_key)
    logger.info("module dt({}, {out});".format(", ".join(inputs), out=outname))

    for iname in inputs:
        logger.info("input [{d}:0] {name};".format(d=inp_width-1, name=iname))
    logger.info("output [{d}:0] {name};".format(d=out_width-1, name=outname))
    logger.info("assign {name} = " .format(name=outname))

    def recurse(node, depth):
        indent = "  " * depth
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            logger.info("{} ({} <= {})?".format(indent, name, to_fixed(threshold, inp_width) ))
            recurse(tree_.children_left[node], depth + 1)
            logger.info("{}:".format(indent, name, threshold))
            recurse(tree_.children_right[node], depth + 1)
        else:
            logger.info("{}{}".format(indent, int(max(tree_.value[node][0])) ))

    recurse(0, 1)
    logger.info(";")
    logger.info("endmodule")


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--input-file", "-i", dest='input_file',
                        help="Specify the input pickle file containing the decision tree object")
    parser.add_argument("--verilog-file", "-v", dest='verilog_file',
                        help='Specify the output verilog file')

    args = parser.parse_args()
    assert args.input_file is not None and args.verilog_file is not None
    logging_cfg(args.verilog_file)

    with open(args.input_file, "rb") as file:
        tr = pickle.load(file)

    _nsre = re.compile('([0-9]+)')

    tree_to_code(tr, 8, "X", "out")
