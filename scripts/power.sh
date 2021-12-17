#!/bin/bash
source ./scripts/env.sh

mkdir -p ./reports
mkdir -p ./logs

pt_shell  -f ./scripts/power.tcl | tee ./logs/ptpower.log

rm -rf transcript *.wlf *.mr *.syn *.log *.svf *.pvl *~

echo -e "Remember to delete the vcd file:\nrm $ENV_VCDFILE"
