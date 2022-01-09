module top(X21, out);
input [7:0] X21;
output [1:0] out;
assign out = 
   (X21[7:5] <= 3)?
    1148
  :
     (X21[7:4] <= 15)?
      210
    :
      130
;
endmodule
