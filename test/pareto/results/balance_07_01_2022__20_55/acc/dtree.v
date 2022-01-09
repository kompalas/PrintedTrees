module top(X4, out);
input [7:0] X4;
output [1:0] out;
assign out = 
   (X4 <= 64)?
    183
  :
     (X4 <= 192)?
      217
    :
      37
;
endmodule
