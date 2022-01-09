module top(X6, out);
input [7:0] X6;
output [1:0] out;
assign out = 
   (X6[7:5] <= 7)?
     (X6[7:4] <= 7)?
      41
    :
      98
  :
    78
;
endmodule
