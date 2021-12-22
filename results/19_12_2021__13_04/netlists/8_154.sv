/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:21:59 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16;

  AND2X1 U11 ( .A1(n11), .A2(n10), .Y(n12) );
  INVX1 U12 ( .A(n12), .Y(n9) );
  NOR2X1 U13 ( .A1(inp[6]), .A2(inp[5]), .Y(n15) );
  NAND2X1 U14 ( .A1(inp[0]), .A2(inp[1]), .Y(n11) );
  INVX1 U15 ( .A(inp[2]), .Y(n10) );
  AND2X1 U16 ( .A1(n9), .A2(inp[3]), .Y(n13) );
  NAND2X1 U17 ( .A1(n13), .A2(inp[4]), .Y(n14) );
  NAND2X1 U18 ( .A1(n14), .A2(n15), .Y(n16) );
  AND2X1 U19 ( .A1(inp[7]), .A2(n16), .Y(out) );
endmodule

