module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:6] <= 0)?
     (X11[7:5] <= -4)?
       (X11[7:3] <= -24)?
        8
      :
        35
    :
      482
  :
     (X11[7:6] <= 0)?
      449
    :
       (X11[7:3] <= -8)?
        132
      :
        13
;
endmodule
