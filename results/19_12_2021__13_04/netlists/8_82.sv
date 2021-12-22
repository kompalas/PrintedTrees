/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:18:57 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17;

  INVX1 U12 ( .A(inp[7]), .Y(n17) );
  NOR2X1 U13 ( .A1(inp[2]), .A2(inp[3]), .Y(n11) );
  NAND2X1 U14 ( .A1(inp[1]), .A2(inp[0]), .Y(n10) );
  NAND2X1 U15 ( .A1(n10), .A2(n11), .Y(n12) );
  NAND2X1 U16 ( .A1(n12), .A2(inp[4]), .Y(n14) );
  INVX1 U17 ( .A(inp[5]), .Y(n13) );
  NAND2X1 U18 ( .A1(n14), .A2(n13), .Y(n15) );
  NAND2X1 U19 ( .A1(n15), .A2(inp[6]), .Y(n16) );
  NAND2X1 U20 ( .A1(n16), .A2(n17), .Y(out) );
endmodule

