#!/bin/bash
# Evaluate all approximate solutions for decision trees against the accurate

set -eou pipefail
set -x

ga_results_dir="${1?Specify the directory where GA results are stored as the first positional argument}"
keep="${2?Specify the amount of pareto solutions to keep as the second positional argument}"
synclk="${3:-50}"  # Specify the clock period IN MILISECONDS for synthesis

# remove slash if it is the last character of the directory
if [[ ${ga_results_dir: -1} == "/" ]]; then
    len=$((${#ga_results_dir}-1))
    ga_results_dir="${ga_results_dir:0:$len}"
fi

maindir="$HOME/PrintedTrees"
testdir="$maindir/test/pareto"

mkdir -p $testdir/sim
mkdir -p $testdir/hdl
mkdir -p $testdir/results

# directory where all results will be stored
resdir="$testdir/results/${ga_results_dir##*/}"
mkdir -p $resdir
rm -rf $resdir/*
resfile="$resdir/results.txt"

# directory where all reports will be saved
reportsdir="$resdir/reports"
mkdir -p $reportsdir
rm -rf $reportsdir/*

# directory where approximate netlists will be stored
netldir="$resdir/netlists"
mkdir -p $netldir
rm -rf $netldir/*

# configure environment
libpath="$maindir/EGFET_PDK/lib_files"
lib="PPDK_Standard_Library_1.0V_25C_TYP_X1.db"
libverilog="PPDK_Standard_Library_1.0V_25C_TYP_X1.v"
if ! [ -f "$libpath/$lib" ]; then
    source $testdir/scripts/lib2db.sh $libpath ${lib//.db/.lib} $libpath/$lib
fi
sed -i "/ENV_LIBRARY_PATH=/ c\export ENV_LIBRARY_PATH=\"$libpath\"" $testdir/scripts/env.sh
sed -i "/ENV_LIBRARY_DB=/ c\export ENV_LIBRARY_DB=\"$lib\"" $testdir/scripts/env.sh
sed -i "/ENV_CLK_PERIOD=/ c\export ENV_CLK_PERIOD=\"$((synclk*1000000))\"" $testdir/scripts/env.sh
sed -i "/ENV_LIBRARY_VERILOG_PATH=/ c\export ENV_LIBRARY_VERILOG_PATH=\"$libpath\"" $testdir/scripts/env.sh

# report files from synopsys and primetime
area_rpt="$testdir/reports/top_$((synclk*1000000))ns.area.rpt"
delay_rpt_dc="$testdir/reports/top_$((synclk*1000000))ns.timing.rpt"
power_rpt="$testdir/reports/top_$((synclk*1000000))ns.power.ptpx.rpt"

# get the measurements of the accurate decision tree
# first create the pickle with the decision tree of the accurate classifier
python3 $maindir/src/evaluation/test_clf.py --load-from $ga_results_dir --load-mode init --results-dir $resdir/acc
# then create the verilog and tb for the accurate classifier
python3 $maindir/src/evaluation/tree2verilog.py --results-dir $resdir/acc --verilog-file $resdir/acc/dtree.v --tb-inputs-file $testdir/sim/inputs.txt --new-inputs
accuracy="$(awk '{printf("%.3e", $1)}' $resdir/acc/accuracy.txt)"

# keep a copy of the inputs used
cp $testdir/sim/inputs.txt $resdir/acc/

# prepare verilog files for synthesis and simulation
cp $resdir/acc/dtree.v $testdir/hdl/top.v
cp $resdir/acc/dtree_tb.v $testdir/sim/top_tb.v
simclk="$((synclk*1000000))"
sed -i "/localparam period =/ c\localparam period = $simclk;" $testdir/sim/top_tb.v

# synthesis to get area and delay
make dcsyn
area="$(awk '/Total cell area/ {print $NF}' $area_rpt)"
delay="$(grep "data arrival time" $delay_rpt_dc | awk 'NR==1 {print $NF}')"

# gatesim and power evaluation
rm -rf work_gate
make gate_sim
# check for an error in the simulation output file
if grep -iq "x" $testdir/sim/output.txt; then
    echo "ERROR: Found 'x' in simulation"
    exit 1
fi

make power
power="$(awk '/Total Power/ {print $4}' $power_rpt)"

# save results
echo -e "Sol\tAccuracy\tArea\tDelay\tPower" > $resfile
echo -e "acc\t$accuracy\t$area\t$delay\t$power" >> $resfile

# save reports and netlist
mv $area_rpt $reportsdir/area_acc.rpt
mv $delay_rpt_dc $reportsdir/delay_acc.rpt
mv $power_rpt $reportsdir/power_acc.rpt
mv $testdir/gate/top.sv $netldir/acc.sv

# extract approximate netlists from pareto front
python3 $maindir/src/evaluation/test_clf.py --load-from $ga_results_dir --load-mode all --results-dir $resdir --keep-pareto-solutions $keep
pareto_sols="$(
    find $resdir -type d -name "[0-9]*" | 
    sed 's_.*/\([0-9][0-9]*\)_\1_g' |
    awk 'BEGIN {max=0} {if ($1 > max) max=$1} END {print max}'
)"

# iterate over all solutions in pareto front
for netl_id in $(seq 0 $pareto_sols); do

    python3 $maindir/src/evaluation/tree2verilog.py --results-dir $resdir/$netl_id --verilog-file $resdir/$netl_id/dtree.v --tb-inputs-file $testdir/sim/inputs.txt
    accuracy="$(awk '{printf("%.3e", $1)}' $resdir/$netl_id/accuracy.txt)"

    cp $resdir/$netl_id/dtree.v $testdir/hdl/top.v
    cp $resdir/$netl_id/dtree_tb.v $testdir/sim/top_tb.v
    simclk="$((synclk*1000000))"
    sed -i "/localparam period =/ c\localparam period = $simclk;" ./sim/top_tb.v

    make dcsyn
    area="$(awk '/Total cell area/ {print $NF}' $area_rpt)"

    # maybe there are no timing paths in the approximate classifier
    if grep -q 'data arrival time' $delay_rpt_dc; then 

        delay="$(grep "data arrival time" $delay_rpt_dc | awk 'NR==1 {print $NF}')"
        if [ ${delay%.*} -eq 0 ]; then
            power="0"

        else

             # gatesim and power evaluation
            rm -rf work_gate
            make gate_sim
            # check for an error in the simulation output file
            if grep -iq "x" $testdir/sim/output.txt; then
                echo "ERROR: Found 'x' in simulation"
                exit 1
            fi

            make power
            power="$(awk '/Total Power/ {print $4}' $power_rpt)"

            # save reports if they exist
            mv $area_rpt $reportsdir/area_$netl_id.rpt
            mv $delay_rpt_dc $reportsdir/delay_$netl_id.rpt
            mv $power_rpt $reportsdir/power_$netl_id.rpt
        fi

    else
        delay="0"
        power="0"
    fi

    # save netlist
    mv $testdir/gate/top.sv $netldir/$netl_id.sv
    
    # save results
    echo -e "$netl_id\t$accuracy\t$area\t$delay\t$power" >> $resfile

done
