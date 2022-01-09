module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= 128)?
     (X11 <= 77)?
       (X11 <= 26)?
        5
      :
        33
    :
      481
  :
     (X11 <= 179)?
      458
    :
       (X11 <= 230)?
        126
      :
        16
;
endmodule
