module top(X10, out);
input [7:0] X10;
output [1:0] out;
assign out = 
   (X10[7:5] <= 3)?
    318
  :
    160
;
endmodule
