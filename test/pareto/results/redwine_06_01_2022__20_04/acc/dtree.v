module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= 128)?
     (X11 <= 77)?
       (X11 <= 26)?
        7
      :
        37
    :
      459
  :
     (X11 <= 179)?
      451
    :
       (X11 <= 230)?
        151
      :
        14
;
endmodule
