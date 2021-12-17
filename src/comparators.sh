#!/bin/bash
set -x
set -eou pipefail

maindir="$HOME/PrintedTrees"
testdir="$maindir"

date_time="$(date +"%d_%m_%Y__%H_%M")"
resdir="$testdir/results/$date_time"

mkdir -p $resdir/reports
mkdir -p $resdir/logs
mkdir -p $resdir/netlists

libpath="$maindir/EGFET_PDK/lib_files"
lib="PPDK_Standard_Library_1.0V_25C_TYP_X1.db"

if ! [ -f "$libpath/$lib" ]; then
    source $testdir/scripts/lib2db.sh $libpath ${lib//.db/.lib} $libpath/$lib
fi

sed -i "/ENV_LIBRARY_PATH=/ c\export ENV_LIBRARY_PATH=\"$libpath\"" $testdir/scripts/env.sh
sed -i "/ENV_LIBRARY_DB=/ c\export ENV_LIBRARY_DB=\"$lib\"" $testdir/scripts/env.sh

cp $maindir/verilog/comparator.v $testdir/hdl/top.v

resfile="$resdir/results.txt"
echo -e "InputBits\tConstant\tArea" > $resfile
area_rpt="$testdir/reports/top_0.0ns.area.rpt"
dclog="$testdir/logs/dcsyn.log"
netl="$testdir/gate/top.sv"

for bits in $(seq 2 8); do
    sed -i "/parameter width =/ c\parameter width = $bits;" hdl/top.v

    low="0"
    high="$(((2 ** $bits) - 2))"

    for c in $(seq $low $high); do
        sed -i "/parameter c =/ c\parameter c = $c\;" hdl/top.v
        make dcsyn
        area="$(awk '/Total cell area/ {print $NF}' $area_rpt)"
        echo -e "$bits\t$c\t$area" >> $resfile

        mv $area_rpt $resdir/reports/${bits}_${c}.rpt
        mv $dclog $resdir/logs/${bits}_${c}.log
        mv $netl $resdir/netlists/${bits}_${c}.sv
    done
done
echo "Results are saved in $resdir"