#!/bin/bash
source ./scripts/env.sh

mkdir -p ./reports
mkdir -p ./logs

pt_shell  -f ./scripts/sta.tcl | tee ./logs/ptsta.log

rm -rf transcript *.wlf *.mr *.syn *.log *.svf *.pvl *~

