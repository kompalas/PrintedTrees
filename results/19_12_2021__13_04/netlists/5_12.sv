/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:06:13 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12;

  AND2X1 U9 ( .A1(n9), .A2(n8), .Y(n10) );
  INVX1 U10 ( .A(n10), .Y(n7) );
  INVX1 U11 ( .A(inp[4]), .Y(n12) );
  NAND2X1 U12 ( .A1(inp[3]), .A2(inp[0]), .Y(n9) );
  NAND2X1 U13 ( .A1(inp[3]), .A2(inp[1]), .Y(n8) );
  NAND2X1 U14 ( .A1(inp[2]), .A2(n7), .Y(n11) );
  NAND2X1 U15 ( .A1(n11), .A2(n12), .Y(out) );
endmodule

