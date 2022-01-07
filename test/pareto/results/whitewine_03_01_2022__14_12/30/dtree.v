module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:5] <= -1)?
     (X11[7:6] <= -2)?
       (X11[7:6] <= -3)?
        8
      :
        35
    :
      482
  :
     (X11[7:6] <= 0)?
      449
    :
       (X11[7:5] <= -2)?
        132
      :
        13
;
endmodule
