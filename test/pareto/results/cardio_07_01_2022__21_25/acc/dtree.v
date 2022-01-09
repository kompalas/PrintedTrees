module top(X21, out);
input [7:0] X21;
output [1:0] out;
assign out = 
   (X21 <= 64)?
    1157
  :
     (X21 <= 192)?
      201
    :
      130
;
endmodule
