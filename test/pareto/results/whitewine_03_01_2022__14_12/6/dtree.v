module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:1] <= -16)?
     (X11[7:6] <= -2)?
       (X11[7:6] <= 2)?
        8
      :
        35
    :
      482
  :
     (X11[7:4] <= 0)?
      449
    :
       (X11[7:4] <= -4)?
        132
      :
        13
;
endmodule
