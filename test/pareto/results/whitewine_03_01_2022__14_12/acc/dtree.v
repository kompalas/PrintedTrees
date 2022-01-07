module top(X11, out);
input [7:0] X11;
output [3:0] out;
assign out = 
   (X11 <= 128)?
     (X11 <= 77)?
       (X11 <= 26)?
        8
      :
        35
    :
      482
  :
     (X11 <= 179)?
      449
    :
       (X11 <= 230)?
        132
      :
        13
;
endmodule
