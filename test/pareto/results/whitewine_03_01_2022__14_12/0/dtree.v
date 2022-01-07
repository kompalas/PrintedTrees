module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:4] <= 7)?
     (X11[7:6] <= -2)?
       (X11[7:3] <= 6)?
        8
      :
        35
    :
      482
  :
     (X11[7:1] <= 86)?
      449
    :
       (X11[7:4] <= 16)?
        132
      :
        13
;
endmodule
