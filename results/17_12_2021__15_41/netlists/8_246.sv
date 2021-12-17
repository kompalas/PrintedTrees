/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:05:48 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21;

  NAND2X1 U11 ( .A1(n10), .A2(n9), .Y(n11) );
  INVX1 U12 ( .A(inp[3]), .Y(n9) );
  NAND2X1 U13 ( .A1(inp[1]), .A2(inp[2]), .Y(n10) );
  NOR2X1 U14 ( .A1(n14), .A2(n12), .Y(out) );
  NAND2X1 U15 ( .A1(n11), .A2(n13), .Y(n12) );
  NOR2X1 U16 ( .A1(n19), .A2(n21), .Y(n13) );
  NAND2X1 U17 ( .A1(n18), .A2(n15), .Y(n14) );
  NOR2X1 U18 ( .A1(n17), .A2(n16), .Y(n15) );
  INVX1 U19 ( .A(inp[5]), .Y(n16) );
  INVX1 U20 ( .A(inp[7]), .Y(n17) );
  NAND2X1 U21 ( .A1(n9), .A2(n20), .Y(n18) );
  INVX1 U22 ( .A(inp[6]), .Y(n19) );
  INVX1 U23 ( .A(inp[0]), .Y(n20) );
  INVX1 U24 ( .A(inp[4]), .Y(n21) );
endmodule

