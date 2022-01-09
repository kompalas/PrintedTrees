module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11[7:4] <= 7)?
     (X11[7:6] <= 1)?
       (X11[7:6] <= 1)?
        6
      :
        33
    :
      476
  :
     (X11[7:6] <= 3)?
      450
    :
       (X11[7:4] <= 15)?
        143
      :
        11
;
endmodule
