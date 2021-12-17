/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:58:51 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  NAND2X1 U12 ( .A1(n13), .A2(n10), .Y(n17) );
  NOR2X1 U13 ( .A1(n12), .A2(n11), .Y(n10) );
  INVX1 U14 ( .A(inp[3]), .Y(n11) );
  INVX1 U15 ( .A(inp[5]), .Y(n12) );
  NOR2X1 U16 ( .A1(n15), .A2(n14), .Y(n13) );
  INVX1 U17 ( .A(inp[2]), .Y(n14) );
  NOR2X1 U18 ( .A1(inp[1]), .A2(inp[0]), .Y(n15) );
  NAND2X1 U19 ( .A1(inp[5]), .A2(inp[4]), .Y(n16) );
  NAND2X1 U20 ( .A1(n17), .A2(n16), .Y(n18) );
  NAND2X1 U21 ( .A1(n18), .A2(inp[6]), .Y(n20) );
  INVX1 U22 ( .A(inp[7]), .Y(n19) );
  NAND2X1 U23 ( .A1(n20), .A2(n19), .Y(out) );
endmodule

