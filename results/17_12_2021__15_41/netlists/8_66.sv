/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:56:46 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  INVX1 U11 ( .A(inp[0]), .Y(n10) );
  INVX1 U12 ( .A(inp[1]), .Y(n9) );
  NOR2X1 U13 ( .A1(n10), .A2(n9), .Y(n14) );
  INVX1 U14 ( .A(inp[3]), .Y(n12) );
  INVX1 U15 ( .A(inp[4]), .Y(n11) );
  NAND2X1 U16 ( .A1(n12), .A2(n11), .Y(n13) );
  NOR2X1 U17 ( .A1(n14), .A2(n13), .Y(n16) );
  NOR2X1 U18 ( .A1(inp[2]), .A2(inp[5]), .Y(n15) );
  NAND2X1 U19 ( .A1(n16), .A2(n15), .Y(n17) );
  NAND2X1 U20 ( .A1(n17), .A2(inp[6]), .Y(n19) );
  INVX1 U21 ( .A(inp[7]), .Y(n18) );
  NAND2X1 U22 ( .A1(n19), .A2(n18), .Y(out) );
endmodule

