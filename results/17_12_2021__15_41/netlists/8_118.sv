/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:59:22 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  NAND2X1 U11 ( .A1(n10), .A2(n9), .Y(out) );
  INVX1 U12 ( .A(inp[7]), .Y(n9) );
  NAND2X1 U13 ( .A1(n18), .A2(n11), .Y(n10) );
  NOR2X1 U14 ( .A1(n19), .A2(n12), .Y(n11) );
  INVX1 U15 ( .A(inp[4]), .Y(n12) );
  INVX1 U16 ( .A(inp[2]), .Y(n14) );
  INVX1 U17 ( .A(inp[0]), .Y(n13) );
  NOR2X1 U18 ( .A1(n14), .A2(n13), .Y(n15) );
  NAND2X1 U19 ( .A1(n15), .A2(inp[1]), .Y(n17) );
  INVX1 U20 ( .A(inp[3]), .Y(n16) );
  NAND2X1 U21 ( .A1(n17), .A2(n16), .Y(n18) );
  NAND2X1 U22 ( .A1(inp[5]), .A2(inp[6]), .Y(n19) );
endmodule

