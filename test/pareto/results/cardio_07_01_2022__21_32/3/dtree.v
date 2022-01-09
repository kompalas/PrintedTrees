module top(X21, out);
input [7:0] X21;
output [1:0] out;
assign out = 
   (X21[7:4] <= 7)?
    1163
  :
     (X21[7:6] <= 3)?
      207
    :
      118
;
endmodule
