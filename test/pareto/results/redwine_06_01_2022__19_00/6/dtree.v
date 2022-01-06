module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:4] <= 7)?
     (X11[7:4] <= 7)?
       (X11[7:4] <= 7)?
        5
      :
        39
    :
      488
  :
     (X11[7:4] <= 11)?
      428
    :
       (X11[7:4] <= 13)?
        143
      :
        16
;
endmodule
