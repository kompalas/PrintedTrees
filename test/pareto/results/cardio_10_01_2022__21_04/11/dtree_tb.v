
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = 0;
localparam halfperiod = period/2;

reg [7:0] X0_reg;
reg [7:0] X1_reg;
reg [7:0] X2_reg;
reg [7:0] X3_reg;
reg [7:0] X6_reg;
reg [7:0] X7_reg;
reg [7:0] X8_reg;
reg [7:0] X9_reg;
reg [7:0] X10_reg;
reg [7:0] X11_reg;
reg [7:0] X12_reg;
reg [7:0] X13_reg;
reg [7:0] X14_reg;
reg [7:0] X15_reg;
reg [7:0] X16_reg;
reg [7:0] X17_reg;
reg [7:0] X18_reg;
reg [7:0] X19_reg;
wire [7:0] X0;
wire [7:0] X1;
wire [7:0] X2;
wire [7:0] X3;
wire [7:0] X6;
wire [7:0] X7;
wire [7:0] X8;
wire [7:0] X9;
wire [7:0] X10;
wire [7:0] X11;
wire [7:0] X12;
wire [7:0] X13;
wire [7:0] X14;
wire [7:0] X15;
wire [7:0] X16;
wire [7:0] X17;
wire [7:0] X18;
wire [7:0] X19;
wire [1:0] out;

integer fin, fout, r;

top DUT (X0, X1, X2, X3, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19, out);

//read inp
initial begin
    $display($time, " << Starting the Simulation >>");
    fin = $fopen("/home/balkon00/PrintedTrees/test/pareto/sim/inputs.txt", "r");
    if (fin == `NULL) begin
        $display($time, " file not found");
        $finish;
    end
    fout = $fopen("/home/balkon00/PrintedTrees/test/pareto/sim/output.txt", "w");
    forever begin
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", X0_reg, X1_reg, X2_reg, X3_reg, X6_reg, X7_reg, X8_reg, X9_reg, X10_reg, X11_reg, X12_reg, X13_reg, X14_reg, X15_reg, X16_reg, X17_reg, X18_reg, X19_reg);
        #period $fwrite(fout, "%d\n", out);
        if ($feof(fin)) begin
            $display($time, " << Finishing the Simulation >>");
            $fclose(fin);
            $fclose(fout);
            $finish;
        end
    end
end

assign X0 = X0_reg;
assign X1 = X1_reg;
assign X2 = X2_reg;
assign X3 = X3_reg;
assign X6 = X6_reg;
assign X7 = X7_reg;
assign X8 = X8_reg;
assign X9 = X9_reg;
assign X10 = X10_reg;
assign X11 = X11_reg;
assign X12 = X12_reg;
assign X13 = X13_reg;
assign X14 = X14_reg;
assign X15 = X15_reg;
assign X16 = X16_reg;
assign X17 = X17_reg;
assign X18 = X18_reg;
assign X19 = X19_reg;

endmodule

