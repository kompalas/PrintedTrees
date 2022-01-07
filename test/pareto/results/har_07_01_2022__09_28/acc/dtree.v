module top(X561, out);
input [7:0] X561;
output [2:0] out;
assign out = 
   (X561 <= 24)?
    542
  :
     (X561 <= 168)?
       (X561 <= 120)?
         (X561 <= 72)?
          455
        :
          477
      :
        575
    :
       (X561 <= 224)?
        545
      :
        382
;
endmodule
