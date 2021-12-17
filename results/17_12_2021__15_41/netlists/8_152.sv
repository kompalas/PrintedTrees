/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:01:04 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  INVX1 U11 ( .A(n9), .Y(n20) );
  NOR2X1 U12 ( .A1(inp[5]), .A2(inp[6]), .Y(n9) );
  NAND2X1 U13 ( .A1(n11), .A2(n10), .Y(n12) );
  INVX1 U14 ( .A(inp[1]), .Y(n10) );
  INVX1 U15 ( .A(inp[0]), .Y(n11) );
  NOR2X1 U16 ( .A1(n12), .A2(inp[2]), .Y(n13) );
  NAND2X1 U17 ( .A1(n13), .A2(n9), .Y(n15) );
  NOR2X1 U18 ( .A1(n16), .A2(n14), .Y(out) );
  NAND2X1 U19 ( .A1(n15), .A2(inp[7]), .Y(n14) );
  NOR2X1 U20 ( .A1(n20), .A2(n17), .Y(n16) );
  NOR2X1 U21 ( .A1(n19), .A2(n18), .Y(n17) );
  INVX1 U22 ( .A(inp[4]), .Y(n18) );
  INVX1 U23 ( .A(inp[3]), .Y(n19) );
endmodule

