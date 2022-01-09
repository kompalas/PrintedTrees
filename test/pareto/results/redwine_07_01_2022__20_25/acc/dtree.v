module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= 128)?
     (X11 <= 77)?
       (X11 <= 26)?
        6
      :
        33
    :
      476
  :
     (X11 <= 179)?
      450
    :
       (X11 <= 230)?
        143
      :
        11
;
endmodule
