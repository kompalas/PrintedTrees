module top(X561, out);
input [7:0] X561;
output [2:0] out;
assign out = 
   (X561[7:5] <= 3)?
    543
  :
     (X561[7:6] <= 3)?
       (X561[7:4] <= 7)?
         (X561[7:5] <= 3)?
          446
        :
          487
      :
        573
    :
       (X561[7:5] <= 7)?
        527
      :
        400
;
endmodule
