#!/bin/bash

source ./scripts/env.sh

if [ ! -d work ]; then
	echo "Creating Library work"
	vlib work
	vlogfiles=$(find ${ENV_LIBRARY_VERILOG_PATH}/*.v | awk 'ORS=" "')
	echo "Compiling $vlogfiles"
	vlog -quiet $vlogfiles
	exstatus="$?"
	if [ "$exstatus" -ne  0 ]; then
        	echo "ERROR in lib"
		rm -r work
        	exit 1
	fi
fi

tbfiles=$(find ./sim/*.v | awk 'ORS=" "')
echo "Compiling: $tbfiles"
vlog $tbfiles
exstatus="$?"
if [ "$exstatus" -ne  0 ]; then
	echo "ERROR in testbench"
	exit 1
fi

vlogfiles=$(find ./hdl/*.v | awk 'ORS=" "')
echo "Compiling: $vlogfiles"
vlog $vlogfiles
exstatus="$?"
if [ "$exstatus" -ne 0 ]; then
        echo "ERROR in hdl"
        exit 1
fi


vsim -c -do "run -all; rm -rf simv*; quit" work.top_tb
exstatus="$?"
if [ "$exstatus" -ne 0 ]; then
        echo "ERROR in simulation"
        exit 1
fi

