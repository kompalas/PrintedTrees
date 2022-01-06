module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= 120)?
     (X11 <= 72)?
       (X11 <= 24)?
        5
      :
        39
    :
      488
  :
     (X11 <= 168)?
      428
    :
       (X11 <= 224)?
        143
      :
        16
;
endmodule
