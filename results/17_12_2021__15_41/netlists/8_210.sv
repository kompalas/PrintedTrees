/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:03:59 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  NAND2X1 U10 ( .A1(n8), .A2(n16), .Y(n15) );
  NAND2X1 U11 ( .A1(n14), .A2(n13), .Y(n8) );
  NOR2X1 U12 ( .A1(n10), .A2(n9), .Y(n19) );
  INVX1 U13 ( .A(inp[0]), .Y(n9) );
  INVX1 U14 ( .A(inp[1]), .Y(n10) );
  NOR2X1 U15 ( .A1(n12), .A2(n11), .Y(n16) );
  INVX1 U16 ( .A(inp[6]), .Y(n11) );
  INVX1 U17 ( .A(inp[7]), .Y(n12) );
  INVX1 U18 ( .A(inp[4]), .Y(n13) );
  INVX1 U19 ( .A(inp[5]), .Y(n14) );
  NOR2X1 U20 ( .A1(n17), .A2(n15), .Y(out) );
  NOR2X1 U21 ( .A1(n19), .A2(n18), .Y(n17) );
  NAND2X1 U22 ( .A1(n20), .A2(n14), .Y(n18) );
  NOR2X1 U23 ( .A1(inp[2]), .A2(inp[3]), .Y(n20) );
endmodule

