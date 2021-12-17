/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:57:39 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23;

  NAND2X1 U13 ( .A1(n13), .A2(n11), .Y(out) );
  NOR2X1 U14 ( .A1(inp[7]), .A2(n12), .Y(n11) );
  NOR2X1 U15 ( .A1(n23), .A2(n22), .Y(n12) );
  NAND2X1 U16 ( .A1(n16), .A2(n14), .Y(n13) );
  NOR2X1 U17 ( .A1(n23), .A2(n15), .Y(n14) );
  INVX1 U18 ( .A(inp[4]), .Y(n15) );
  NAND2X1 U19 ( .A1(n17), .A2(n21), .Y(n16) );
  NAND2X1 U20 ( .A1(n20), .A2(inp[2]), .Y(n17) );
  INVX1 U21 ( .A(inp[1]), .Y(n19) );
  INVX1 U22 ( .A(inp[0]), .Y(n18) );
  NAND2X1 U23 ( .A1(n19), .A2(n18), .Y(n20) );
  INVX1 U24 ( .A(inp[3]), .Y(n21) );
  INVX1 U25 ( .A(inp[6]), .Y(n23) );
  INVX1 U26 ( .A(inp[5]), .Y(n22) );
endmodule

