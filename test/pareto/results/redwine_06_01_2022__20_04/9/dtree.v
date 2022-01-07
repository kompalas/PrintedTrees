module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:6] <= -1)?
     (X11[7:6] <= -2)?
       (X11[7:6] <= 0)?
        7
      :
        37
    :
      459
  :
     (X11[7:5] <= -2)?
      451
    :
       (X11[7:6] <= 0)?
        151
      :
        14
;
endmodule
