module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= -32)?
     (X11[7:5] <= -4)?
       (X11[7:5] <= -6)?
        8
      :
        35
    :
      482
  :
     (X11[7:6] <= 0)?
      449
    :
       (X11[7:6] <= -1)?
        132
      :
        13
;
endmodule
