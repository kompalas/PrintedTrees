module top(X0, X1, X4, X5, X6, out);
input [7:0] X0;
input [7:0] X1;
input [7:0] X4;
input [7:0] X5;
input [7:0] X6;
output [1:0] out;
assign out = 
   (X6 <= 133)?
     (X0 <= 57)?
       (X6 <= 56)?
         (X5 <= 61)?
          3
        :
           (X1 <= 60)?
            6
          :
            1
      :
        43
    :
       (X5 <= 170)?
         (X4 <= 152)?
          37
        :
           (X5 <= 79)?
            5
          :
            2
      :
        2
  :
     (X5 <= 43)?
       (X1 <= 181)?
        1
      :
        3
    :
      44
;
endmodule
