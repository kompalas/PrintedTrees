module top(X4, out);
input [7:0] X4;
output [1:0] out;
assign out = 
   (X4[7:5] <= 3)?
    183
  :
     (X4[7:4] <= 15)?
      217
    :
      37
;
endmodule
