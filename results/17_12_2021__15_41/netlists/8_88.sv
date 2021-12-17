/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:57:51 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22;

  NOR2X1 U13 ( .A1(n12), .A2(n11), .Y(n17) );
  INVX1 U14 ( .A(inp[4]), .Y(n11) );
  NOR2X1 U15 ( .A1(inp[1]), .A2(n13), .Y(n12) );
  NAND2X1 U16 ( .A1(n15), .A2(n14), .Y(n13) );
  INVX1 U17 ( .A(inp[2]), .Y(n14) );
  INVX1 U18 ( .A(inp[0]), .Y(n15) );
  AND2X1 U19 ( .A1(inp[3]), .A2(inp[6]), .Y(n16) );
  NAND2X1 U20 ( .A1(n17), .A2(n16), .Y(n22) );
  INVX1 U21 ( .A(inp[6]), .Y(n19) );
  INVX1 U22 ( .A(inp[5]), .Y(n18) );
  NOR2X1 U23 ( .A1(n19), .A2(n18), .Y(n20) );
  NOR2X1 U24 ( .A1(n20), .A2(inp[7]), .Y(n21) );
  NAND2X1 U25 ( .A1(n22), .A2(n21), .Y(out) );
endmodule

