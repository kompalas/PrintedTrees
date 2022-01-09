module top(X561, out);
input [7:0] X561;
output [2:0] out;
assign out = 
   (X561 <= 26)?
    543
  :
     (X561 <= 179)?
       (X561 <= 128)?
         (X561 <= 77)?
          446
        :
          487
      :
        573
    :
       (X561 <= 230)?
        527
      :
        400
;
endmodule
