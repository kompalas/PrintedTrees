/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:19:49 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16;

  AND2X1 U11 ( .A1(n13), .A2(n14), .Y(n16) );
  INVX1 U12 ( .A(n16), .Y(n9) );
  AND2X1 U13 ( .A1(inp[6]), .A2(inp[5]), .Y(n14) );
  AND2X1 U14 ( .A1(inp[2]), .A2(inp[0]), .Y(n10) );
  NAND2X1 U15 ( .A1(n10), .A2(inp[1]), .Y(n12) );
  NOR2X1 U16 ( .A1(inp[4]), .A2(inp[3]), .Y(n11) );
  NAND2X1 U17 ( .A1(n12), .A2(n11), .Y(n13) );
  INVX1 U18 ( .A(inp[7]), .Y(n15) );
  NAND2X1 U19 ( .A1(n9), .A2(n15), .Y(out) );
endmodule

