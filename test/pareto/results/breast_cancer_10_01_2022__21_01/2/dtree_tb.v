
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
reg [7:0] X4_reg;
reg [7:0] X5_reg;
reg [7:0] X6_reg;
reg [7:0] X7_reg;
reg [7:0] X8_reg;
wire [7:0] X0;
wire [7:0] X1;
wire [7:0] X2;
wire [7:0] X3;
wire [7:0] X4;
wire [7:0] X5;
wire [7:0] X6;
wire [7:0] X7;
wire [7:0] X8;
wire [1:0] out;

integer fin, fout, r;

top DUT (X0, X1, X2, X3, X4, X5, X6, X7, X8, out);

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
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", X0_reg, X1_reg, X2_reg, X3_reg, X4_reg, X5_reg, X6_reg, X7_reg, X8_reg);
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
assign X4 = X4_reg;
assign X5 = X5_reg;
assign X6 = X6_reg;
assign X7 = X7_reg;
assign X8 = X8_reg;

endmodule

