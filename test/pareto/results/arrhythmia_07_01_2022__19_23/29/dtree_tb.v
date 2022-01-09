
`timescale 1ns/1ps
module top_tb();
`define EOF 32'hFFFF_FFFF
`define NULL 0
localparam period = 0;
localparam halfperiod = period/2;

reg [7:0] X13_reg;
reg [7:0] X27_reg;
reg [7:0] X235_reg;
reg [7:0] X264_reg;
reg [7:0] X278_reg;
wire [7:0] X13;
wire [7:0] X27;
wire [7:0] X235;
wire [7:0] X264;
wire [7:0] X278;
wire [4:0] out;

integer fin, fout, r;

top DUT (X13, X27, X235, X264, X278, out);

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
        r = $fscanf(fin,"%d\t%d\t%d\t%d\t%d\n", X13_reg, X27_reg, X235_reg, X264_reg, X278_reg);
        #period $fwrite(fout, "%d\n", out);
        if ($feof(fin)) begin
            $display($time, " << Finishing the Simulation >>");
            $fclose(fin);
            $fclose(fout);
            $finish;
        end
    end
end

assign X13 = X13_reg;
assign X27 = X27_reg;
assign X235 = X235_reg;
assign X264 = X264_reg;
assign X278 = X278_reg;

endmodule

