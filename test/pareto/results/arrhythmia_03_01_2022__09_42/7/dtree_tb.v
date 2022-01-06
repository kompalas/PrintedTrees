
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = 0;
localparam halfperiod = period/2;

reg [7:0] X6_reg;
reg [7:0] X13_reg;
reg [7:0] X169_reg;
reg [7:0] X236_reg;
reg [7:0] X251_reg;
reg [7:0] X260_reg;
reg [7:0] X278_reg;
wire [7:0] X6;
wire [7:0] X13;
wire [7:0] X169;
wire [7:0] X236;
wire [7:0] X251;
wire [7:0] X260;
wire [7:0] X278;
wire [4:0] out;

integer fin, fout, r;

top DUT (X6, X13, X169, X236, X251, X260, X278, out);

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
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\t%d\t%d\n", X6_reg, X13_reg, X169_reg, X236_reg, X251_reg, X260_reg, X278_reg);
        #period $fwrite(fout, "%d\n", out);
        if ($feof(fin)) begin
            $display($time, " << Finishing the Simulation >>");
            $fclose(fin);
            $fclose(fout);
            $finish;
        end
    end
end

assign X6 = X6_reg;
assign X13 = X13_reg;
assign X169 = X169_reg;
assign X236 = X236_reg;
assign X251 = X251_reg;
assign X260 = X260_reg;
assign X278 = X278_reg;

endmodule

