/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:21:32 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n4, n5, n6, n7;

  AND2X1 U7 ( .A1(inp[7]), .A2(inp[6]), .Y(n6) );
  INVX1 U8 ( .A(n6), .Y(n4) );
  OR2X1 U9 ( .A1(inp[5]), .A2(inp[4]), .Y(n5) );
  NAND2X1 U10 ( .A1(n5), .A2(inp[7]), .Y(n7) );
  NAND2X1 U11 ( .A1(n7), .A2(n4), .Y(out) );
endmodule

