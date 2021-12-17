/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:53:22 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17;

  NOR2X1 U9 ( .A1(n8), .A2(n7), .Y(n12) );
  INVX1 U10 ( .A(inp[4]), .Y(n7) );
  INVX1 U11 ( .A(inp[5]), .Y(n8) );
  NOR2X1 U12 ( .A1(n10), .A2(n9), .Y(n11) );
  INVX1 U13 ( .A(inp[6]), .Y(n9) );
  INVX1 U14 ( .A(inp[2]), .Y(n10) );
  NOR2X1 U15 ( .A1(n14), .A2(n13), .Y(out) );
  NAND2X1 U16 ( .A1(n11), .A2(n12), .Y(n13) );
  NAND2X1 U17 ( .A1(n15), .A2(inp[3]), .Y(n14) );
  NAND2X1 U18 ( .A1(n17), .A2(n16), .Y(n15) );
  INVX1 U19 ( .A(inp[1]), .Y(n16) );
  INVX1 U20 ( .A(inp[0]), .Y(n17) );
endmodule

