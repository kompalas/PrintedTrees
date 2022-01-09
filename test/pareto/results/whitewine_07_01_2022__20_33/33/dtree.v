module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:2] <= 31)?
     (X11[7:6] <= 1)?
       (X11[7:6] <= 1)?
        5
      :
        33
    :
      481
  :
     (X11[7:6] <= 3)?
      458
    :
       (X11[7:5] <= 7)?
        126
      :
        16
;
endmodule
