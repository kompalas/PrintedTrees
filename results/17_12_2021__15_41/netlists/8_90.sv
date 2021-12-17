/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:57:57 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21;

  NAND2X1 U13 ( .A1(inp[0]), .A2(inp[1]), .Y(n12) );
  INVX1 U14 ( .A(inp[2]), .Y(n11) );
  NAND2X1 U15 ( .A1(n12), .A2(n11), .Y(n16) );
  INVX1 U16 ( .A(inp[4]), .Y(n14) );
  INVX1 U17 ( .A(inp[3]), .Y(n13) );
  NOR2X1 U18 ( .A1(n14), .A2(n13), .Y(n15) );
  NAND2X1 U19 ( .A1(n16), .A2(n15), .Y(n18) );
  INVX1 U20 ( .A(inp[5]), .Y(n17) );
  NAND2X1 U21 ( .A1(n18), .A2(n17), .Y(n19) );
  NAND2X1 U22 ( .A1(n19), .A2(inp[6]), .Y(n21) );
  INVX1 U23 ( .A(inp[7]), .Y(n20) );
  NAND2X1 U24 ( .A1(n21), .A2(n20), .Y(out) );
endmodule

