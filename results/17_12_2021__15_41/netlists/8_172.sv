/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:02:03 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21;

  AND2X1 U12 ( .A1(inp[7]), .A2(inp[6]), .Y(n20) );
  INVX1 U13 ( .A(n20), .Y(n10) );
  NAND2X1 U14 ( .A1(n14), .A2(n11), .Y(n18) );
  NOR2X1 U15 ( .A1(n13), .A2(n12), .Y(n11) );
  INVX1 U16 ( .A(inp[3]), .Y(n12) );
  INVX1 U17 ( .A(inp[5]), .Y(n13) );
  NOR2X1 U18 ( .A1(n16), .A2(n15), .Y(n14) );
  INVX1 U19 ( .A(inp[2]), .Y(n15) );
  NOR2X1 U20 ( .A1(inp[1]), .A2(inp[0]), .Y(n16) );
  NAND2X1 U21 ( .A1(inp[5]), .A2(inp[4]), .Y(n17) );
  NAND2X1 U22 ( .A1(n18), .A2(n17), .Y(n19) );
  NAND2X1 U23 ( .A1(n19), .A2(inp[7]), .Y(n21) );
  NAND2X1 U24 ( .A1(n21), .A2(n10), .Y(out) );
endmodule

