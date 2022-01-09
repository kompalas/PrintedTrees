module top(X1, X7, out);
input [7:0] X1;
input [7:0] X7;
output [1:0] out;
assign out = 
   (X7 <= 64)?
    50
  :
     (X1 <= 100)?
      44
    :
      53
;
endmodule
