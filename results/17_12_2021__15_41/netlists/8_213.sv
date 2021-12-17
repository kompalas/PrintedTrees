/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:04:07 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  NOR2X1 U10 ( .A1(n9), .A2(n8), .Y(n18) );
  INVX1 U11 ( .A(inp[1]), .Y(n8) );
  INVX1 U12 ( .A(inp[2]), .Y(n9) );
  NOR2X1 U13 ( .A1(n11), .A2(n10), .Y(n14) );
  INVX1 U14 ( .A(inp[6]), .Y(n10) );
  INVX1 U15 ( .A(inp[7]), .Y(n11) );
  NOR2X1 U16 ( .A1(n15), .A2(n12), .Y(out) );
  NAND2X1 U17 ( .A1(n13), .A2(n14), .Y(n12) );
  NAND2X1 U18 ( .A1(n17), .A2(n19), .Y(n13) );
  NOR2X1 U19 ( .A1(n18), .A2(n16), .Y(n15) );
  NAND2X1 U20 ( .A1(n17), .A2(n20), .Y(n16) );
  INVX1 U21 ( .A(inp[5]), .Y(n17) );
  INVX1 U22 ( .A(inp[4]), .Y(n19) );
  INVX1 U23 ( .A(inp[3]), .Y(n20) );
endmodule

