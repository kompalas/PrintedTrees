
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = 0;
localparam halfperiod = period/2;

reg [7:0] X0_reg;
reg [7:0] X2_reg;
reg [7:0] X5_reg;
reg [7:0] X9_reg;
reg [7:0] X10_reg;
reg [7:0] X12_reg;
reg [7:0] X13_reg;
reg [7:0] X50_reg;
reg [7:0] X55_reg;
reg [7:0] X74_reg;
reg [7:0] X91_reg;
reg [7:0] X124_reg;
reg [7:0] X139_reg;
reg [7:0] X147_reg;
reg [7:0] X164_reg;
reg [7:0] X170_reg;
reg [7:0] X171_reg;
reg [7:0] X175_reg;
reg [7:0] X180_reg;
reg [7:0] X184_reg;
reg [7:0] X186_reg;
reg [7:0] X190_reg;
reg [7:0] X195_reg;
reg [7:0] X199_reg;
reg [7:0] X205_reg;
reg [7:0] X209_reg;
reg [7:0] X216_reg;
reg [7:0] X221_reg;
reg [7:0] X222_reg;
reg [7:0] X235_reg;
reg [7:0] X236_reg;
reg [7:0] X240_reg;
reg [7:0] X246_reg;
reg [7:0] X251_reg;
reg [7:0] X255_reg;
reg [7:0] X256_reg;
reg [7:0] X257_reg;
reg [7:0] X258_reg;
reg [7:0] X261_reg;
reg [7:0] X264_reg;
reg [7:0] X265_reg;
reg [7:0] X271_reg;
reg [7:0] X274_reg;
reg [7:0] X275_reg;
reg [7:0] X276_reg;
wire [7:0] X0;
wire [7:0] X2;
wire [7:0] X5;
wire [7:0] X9;
wire [7:0] X10;
wire [7:0] X12;
wire [7:0] X13;
wire [7:0] X50;
wire [7:0] X55;
wire [7:0] X74;
wire [7:0] X91;
wire [7:0] X124;
wire [7:0] X139;
wire [7:0] X147;
wire [7:0] X164;
wire [7:0] X170;
wire [7:0] X171;
wire [7:0] X175;
wire [7:0] X180;
wire [7:0] X184;
wire [7:0] X186;
wire [7:0] X190;
wire [7:0] X195;
wire [7:0] X199;
wire [7:0] X205;
wire [7:0] X209;
wire [7:0] X216;
wire [7:0] X221;
wire [7:0] X222;
wire [7:0] X235;
wire [7:0] X236;
wire [7:0] X240;
wire [7:0] X246;
wire [7:0] X251;
wire [7:0] X255;
wire [7:0] X256;
wire [7:0] X257;
wire [7:0] X258;
wire [7:0] X261;
wire [7:0] X264;
wire [7:0] X265;
wire [7:0] X271;
wire [7:0] X274;
wire [7:0] X275;
wire [7:0] X276;
wire [4:0] out;

integer fin, fout, r;

top DUT (X0, X2, X5, X9, X10, X12, X13, X50, X55, X74, X91, X124, X139, X147, X164, X170, X171, X175, X180, X184, X186, X190, X195, X199, X205, X209, X216, X221, X222, X235, X236, X240, X246, X251, X255, X256, X257, X258, X261, X264, X265, X271, X274, X275, X276, out);

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
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", X0_reg, X2_reg, X5_reg, X9_reg, X10_reg, X12_reg, X13_reg, X50_reg, X55_reg, X74_reg, X91_reg, X124_reg, X139_reg, X147_reg, X164_reg, X170_reg, X171_reg, X175_reg, X180_reg, X184_reg, X186_reg, X190_reg, X195_reg, X199_reg, X205_reg, X209_reg, X216_reg, X221_reg, X222_reg, X235_reg, X236_reg, X240_reg, X246_reg, X251_reg, X255_reg, X256_reg, X257_reg, X258_reg, X261_reg, X264_reg, X265_reg, X271_reg, X274_reg, X275_reg, X276_reg);
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
assign X2 = X2_reg;
assign X5 = X5_reg;
assign X9 = X9_reg;
assign X10 = X10_reg;
assign X12 = X12_reg;
assign X13 = X13_reg;
assign X50 = X50_reg;
assign X55 = X55_reg;
assign X74 = X74_reg;
assign X91 = X91_reg;
assign X124 = X124_reg;
assign X139 = X139_reg;
assign X147 = X147_reg;
assign X164 = X164_reg;
assign X170 = X170_reg;
assign X171 = X171_reg;
assign X175 = X175_reg;
assign X180 = X180_reg;
assign X184 = X184_reg;
assign X186 = X186_reg;
assign X190 = X190_reg;
assign X195 = X195_reg;
assign X199 = X199_reg;
assign X205 = X205_reg;
assign X209 = X209_reg;
assign X216 = X216_reg;
assign X221 = X221_reg;
assign X222 = X222_reg;
assign X235 = X235_reg;
assign X236 = X236_reg;
assign X240 = X240_reg;
assign X246 = X246_reg;
assign X251 = X251_reg;
assign X255 = X255_reg;
assign X256 = X256_reg;
assign X257 = X257_reg;
assign X258 = X258_reg;
assign X261 = X261_reg;
assign X264 = X264_reg;
assign X265 = X265_reg;
assign X271 = X271_reg;
assign X274 = X274_reg;
assign X275 = X275_reg;
assign X276 = X276_reg;

endmodule

