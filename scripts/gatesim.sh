#!/bin/bash

source ./scripts/env.sh

if [ ! -d work_gate ]; then
	echo "Creating Library work_gate"
	vlib work_gate
	vlogfiles=$(find ${ENV_LIBRARY_VERILOG_PATH}/*.v | awk 'ORS=" "')
	echo "Compiling $vlogfiles"
	vlog -work work_gate -quiet $vlogfiles
	exstatus="$?"
	if [ "$exstatus" -ne  0 ]; then
        	echo "ERROR in lib"
		rm -r work_gate
        	exit 1
	fi
fi

tbfiles=$(find ./sim/*.v | awk 'ORS=" "')
vlog -work work_gate $tbfiles
exstatus="$?"
if [ "$exstatus" -ne  0 ]; then
	echo "ERROR in testbench"
	exit 1
fi

vlog -work work_gate ./gate/${ENV_TOP_DESIGN}.sv
exstatus="$?"
if [ "$exstatus" -ne 0 ]; then
        echo "ERROR in hdl"
        exit 1
fi

vsim -c -t 1ps -sdfmax /${ENV_DUT_NAME}/=./gate/${ENV_TOP_DESIGN}.sdf +sdfverbose -do ./scripts/gatesim.tcl work_gate.${ENV_TB_NAME}
exstatus="$?"
if [ "$exstatus" -ne 0 ]; then
        echo "ERROR in simulation"
        exit 1
fi
