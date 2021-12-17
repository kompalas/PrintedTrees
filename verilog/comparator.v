module top(inp, out);
parameter width = 8;
parameter c = 255;

input [width-1:0] inp;
output out;

assign out = (inp > c) ? $unsigned(1) : $unsigned(0);

endmodule
