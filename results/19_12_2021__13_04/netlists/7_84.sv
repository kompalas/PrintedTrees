/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:13:35 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  AND2X1 U12 ( .A1(inp[6]), .A2(inp[5]), .Y(n19) );
  INVX1 U13 ( .A(n19), .Y(n10) );
  AND2X1 U14 ( .A1(inp[2]), .A2(inp[1]), .Y(n13) );
  INVX1 U15 ( .A(n13), .Y(n11) );
  AND2X1 U16 ( .A1(n17), .A2(n16), .Y(n18) );
  INVX1 U17 ( .A(n18), .Y(n12) );
  NAND2X1 U18 ( .A1(inp[2]), .A2(inp[0]), .Y(n14) );
  NAND2X1 U19 ( .A1(n14), .A2(n11), .Y(n15) );
  NAND2X1 U20 ( .A1(inp[4]), .A2(n15), .Y(n17) );
  NAND2X1 U21 ( .A1(inp[4]), .A2(inp[3]), .Y(n16) );
  NAND2X1 U22 ( .A1(inp[6]), .A2(n12), .Y(n20) );
  NAND2X1 U23 ( .A1(n20), .A2(n10), .Y(out) );
endmodule

