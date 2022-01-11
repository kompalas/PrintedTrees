
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = 0;
localparam halfperiod = period/2;

reg [7:0] X0_reg;
reg [7:0] X4_reg;
reg [7:0] X12_reg;
reg [7:0] X13_reg;
reg [7:0] X39_reg;
reg [7:0] X55_reg;
reg [7:0] X74_reg;
reg [7:0] X88_reg;
reg [7:0] X91_reg;
reg [7:0] X101_reg;
reg [7:0] X110_reg;
reg [7:0] X112_reg;
reg [7:0] X124_reg;
reg [7:0] X135_reg;
reg [7:0] X161_reg;
reg [7:0] X165_reg;
reg [7:0] X170_reg;
reg [7:0] X180_reg;
reg [7:0] X195_reg;
reg [7:0] X205_reg;
reg [7:0] X206_reg;
reg [7:0] X215_reg;
reg [7:0] X218_reg;
reg [7:0] X220_reg;
reg [7:0] X221_reg;
reg [7:0] X226_reg;
reg [7:0] X229_reg;
reg [7:0] X234_reg;
reg [7:0] X235_reg;
reg [7:0] X240_reg;
reg [7:0] X246_reg;
reg [7:0] X257_reg;
reg [7:0] X264_reg;
reg [7:0] X267_reg;
reg [7:0] X275_reg;
reg [7:0] X276_reg;
wire [7:0] X0;
wire [7:0] X4;
wire [7:0] X12;
wire [7:0] X13;
wire [7:0] X39;
wire [7:0] X55;
wire [7:0] X74;
wire [7:0] X88;
wire [7:0] X91;
wire [7:0] X101;
wire [7:0] X110;
wire [7:0] X112;
wire [7:0] X124;
wire [7:0] X135;
wire [7:0] X161;
wire [7:0] X165;
wire [7:0] X170;
wire [7:0] X180;
wire [7:0] X195;
wire [7:0] X205;
wire [7:0] X206;
wire [7:0] X215;
wire [7:0] X218;
wire [7:0] X220;
wire [7:0] X221;
wire [7:0] X226;
wire [7:0] X229;
wire [7:0] X234;
wire [7:0] X235;
wire [7:0] X240;
wire [7:0] X246;
wire [7:0] X257;
wire [7:0] X264;
wire [7:0] X267;
wire [7:0] X275;
wire [7:0] X276;
wire [4:0] out;

integer fin, fout, r;

top DUT (X0, X4, X12, X13, X39, X55, X74, X88, X91, X101, X110, X112, X124, X135, X161, X165, X170, X180, X195, X205, X206, X215, X218, X220, X221, X226, X229, X234, X235, X240, X246, X257, X264, X267, X275, X276, out);

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
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", X0_reg, X4_reg, X12_reg, X13_reg, X39_reg, X55_reg, X74_reg, X88_reg, X91_reg, X101_reg, X110_reg, X112_reg, X124_reg, X135_reg, X161_reg, X165_reg, X170_reg, X180_reg, X195_reg, X205_reg, X206_reg, X215_reg, X218_reg, X220_reg, X221_reg, X226_reg, X229_reg, X234_reg, X235_reg, X240_reg, X246_reg, X257_reg, X264_reg, X267_reg, X275_reg, X276_reg);
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
assign X4 = X4_reg;
assign X12 = X12_reg;
assign X13 = X13_reg;
assign X39 = X39_reg;
assign X55 = X55_reg;
assign X74 = X74_reg;
assign X88 = X88_reg;
assign X91 = X91_reg;
assign X101 = X101_reg;
assign X110 = X110_reg;
assign X112 = X112_reg;
assign X124 = X124_reg;
assign X135 = X135_reg;
assign X161 = X161_reg;
assign X165 = X165_reg;
assign X170 = X170_reg;
assign X180 = X180_reg;
assign X195 = X195_reg;
assign X205 = X205_reg;
assign X206 = X206_reg;
assign X215 = X215_reg;
assign X218 = X218_reg;
assign X220 = X220_reg;
assign X221 = X221_reg;
assign X226 = X226_reg;
assign X229 = X229_reg;
assign X234 = X234_reg;
assign X235 = X235_reg;
assign X240 = X240_reg;
assign X246 = X246_reg;
assign X257 = X257_reg;
assign X264 = X264_reg;
assign X267 = X267_reg;
assign X275 = X275_reg;
assign X276 = X276_reg;

endmodule

