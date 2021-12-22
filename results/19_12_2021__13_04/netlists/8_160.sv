/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:22:15 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  AND2X1 U12 ( .A1(inp[7]), .A2(inp[6]), .Y(n18) );
  INVX1 U13 ( .A(n18), .Y(n10) );
  AND2X1 U14 ( .A1(n16), .A2(n15), .Y(n17) );
  INVX1 U15 ( .A(n17), .Y(n11) );
  NOR2X1 U16 ( .A1(inp[3]), .A2(inp[1]), .Y(n13) );
  NOR2X1 U17 ( .A1(inp[0]), .A2(inp[4]), .Y(n12) );
  NAND2X1 U18 ( .A1(n13), .A2(n12), .Y(n14) );
  NAND2X1 U19 ( .A1(inp[5]), .A2(n14), .Y(n16) );
  NAND2X1 U20 ( .A1(inp[5]), .A2(inp[2]), .Y(n15) );
  NAND2X1 U21 ( .A1(inp[7]), .A2(n11), .Y(n19) );
  NAND2X1 U22 ( .A1(n19), .A2(n10), .Y(out) );
endmodule

