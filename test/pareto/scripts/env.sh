#set the library path
export ENV_LIBRARY_PATH="/home/balkon00/PrintedTrees/EGFET_PDK/lib_files"

#set the library name
export ENV_LIBRARY_DB="PPDK_Standard_Library_1.0V_25C_TYP_X1.db"

#set library verilog path
export ENV_LIBRARY_VERILOG_PATH="/home/balkon00/PrintedTrees/EGFET_PDK/lib_files"

#set the top design name
export ENV_TOP_DESIGN="top"
#set the desired delay
export ENV_CLK_PERIOD="50000000"

#clock name and reset (if applicable)
export ENV_CLK_PORT="clk"
export ENV_RST_PORT="rst"
#set ENV_VIRTUAL_CLOCK to false if the design contains a clock or to true if not
export ENV_VIRTUAL_CLOCK="true"

#set tb name
export ENV_TB_NAME="top_tb"
#vcd name
export ENV_VCDFILE="$(pwd)/sim/${ENV_TOP_DESIGN}.vcd.gz"
export ENV_DUT_NAME="DUT"

if [ -z "$SNPS_SYN" ]; then
	echo "set SNPS_SYN"
	exit 1
fi
