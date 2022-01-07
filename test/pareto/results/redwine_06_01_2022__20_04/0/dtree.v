module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:4] <= 8)?
     (X11[7:3] <= 9)?
       (X11[7:4] <= -2)?
        7
      :
        37
    :
      459
  :
     (X11 <= 174)?
      451
    :
       (X11[7:1] <= 116)?
        151
      :
        14
;
endmodule
