module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:4] <= 8)?
     (X11[7:2] <= 17)?
       (X11[7:5] <= -1)?
        7
      :
        37
    :
      459
  :
     (X11 <= 32)?
      451
    :
       (X11[7:4] <= 11)?
        151
      :
        14
;
endmodule
