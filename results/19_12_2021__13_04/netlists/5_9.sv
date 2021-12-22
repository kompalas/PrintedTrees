/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:06:03 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;
  wire   n4, n5, n6;

  OR2X1 U7 ( .A1(inp[2]), .A2(inp[1]), .Y(n4) );
  NAND2X1 U8 ( .A1(n4), .A2(inp[3]), .Y(n6) );
  INVX1 U9 ( .A(inp[4]), .Y(n5) );
  NAND2X1 U10 ( .A1(n6), .A2(n5), .Y(out) );
endmodule

