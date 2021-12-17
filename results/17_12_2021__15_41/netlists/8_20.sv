/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:54:35 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  NAND2X1 U12 ( .A1(inp[2]), .A2(inp[1]), .Y(n11) );
  NAND2X1 U13 ( .A1(inp[2]), .A2(inp[0]), .Y(n10) );
  NAND2X1 U14 ( .A1(n11), .A2(n10), .Y(n12) );
  NAND2X1 U15 ( .A1(n12), .A2(inp[4]), .Y(n20) );
  INVX1 U16 ( .A(inp[5]), .Y(n14) );
  INVX1 U17 ( .A(inp[6]), .Y(n13) );
  NAND2X1 U18 ( .A1(n14), .A2(n13), .Y(n18) );
  NAND2X1 U19 ( .A1(inp[4]), .A2(inp[3]), .Y(n16) );
  INVX1 U20 ( .A(inp[7]), .Y(n15) );
  NAND2X1 U21 ( .A1(n16), .A2(n15), .Y(n17) );
  NOR2X1 U22 ( .A1(n18), .A2(n17), .Y(n19) );
  NAND2X1 U23 ( .A1(n20), .A2(n19), .Y(out) );
endmodule

