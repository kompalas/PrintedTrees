/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:04:42 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [1:0] inp;
  output out;


  AND2X1 U4 ( .A1(inp[0]), .A2(inp[1]), .Y(out) );
endmodule

