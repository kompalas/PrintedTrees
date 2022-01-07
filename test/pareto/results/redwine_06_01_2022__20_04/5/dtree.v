module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:1] <= 63)?
     (X11[7:5] <= -4)?
       (X11[7:4] <= -2)?
        7
      :
        37
    :
      459
  :
     (X11[7:6] <= -1)?
      451
    :
       (X11[7:4] <= 0)?
        151
      :
        14
;
endmodule
