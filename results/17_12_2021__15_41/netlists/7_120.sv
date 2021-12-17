/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:53:11 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;

  NOR2X1 U10 ( .A1(n9), .A2(n8), .Y(n12) );
  INVX1 U11 ( .A(inp[6]), .Y(n8) );
  INVX1 U12 ( .A(inp[3]), .Y(n9) );
  NOR2X1 U13 ( .A1(n13), .A2(n10), .Y(out) );
  NAND2X1 U14 ( .A1(n11), .A2(n12), .Y(n10) );
  NOR2X1 U15 ( .A1(n15), .A2(n14), .Y(n11) );
  NOR2X1 U16 ( .A1(inp[1]), .A2(n18), .Y(n13) );
  INVX1 U17 ( .A(inp[5]), .Y(n14) );
  INVX1 U18 ( .A(inp[4]), .Y(n15) );
  INVX1 U19 ( .A(inp[0]), .Y(n17) );
  INVX1 U20 ( .A(inp[2]), .Y(n16) );
  NAND2X1 U21 ( .A1(n17), .A2(n16), .Y(n18) );
endmodule

