module top(inp1, inp2, out);
parameter width = 8;
parameter c = 255;

input [width-1:0] inp1, inp2;
output out;

assign out = (inp1 > inp2) ? $unsigned(1) : $unsigned(0);

endmodule
