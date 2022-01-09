module top(X5, out);
input [7:0] X5;
output [0:0] out;
assign out = 
   (X5[7:1] <= 63)?
    299
  :
    282
;
endmodule
