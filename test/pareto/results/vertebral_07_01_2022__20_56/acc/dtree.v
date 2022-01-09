module top(X6, out);
input [7:0] X6;
output [1:0] out;
assign out = 
   (X6 <= 192)?
     (X6 <= 64)?
      41
    :
      98
  :
    78
;
endmodule
