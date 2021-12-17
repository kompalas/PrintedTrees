/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:00:59 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;

  INVX1 U11 ( .A(inp[0]), .Y(n10) );
  NAND2X1 U12 ( .A1(inp[2]), .A2(inp[1]), .Y(n9) );
  NOR2X1 U13 ( .A1(n10), .A2(n9), .Y(n13) );
  NOR2X1 U14 ( .A1(inp[5]), .A2(inp[6]), .Y(n15) );
  INVX1 U15 ( .A(inp[3]), .Y(n11) );
  NAND2X1 U16 ( .A1(n15), .A2(n11), .Y(n12) );
  NOR2X1 U17 ( .A1(n13), .A2(n12), .Y(n18) );
  INVX1 U18 ( .A(inp[4]), .Y(n14) );
  NAND2X1 U19 ( .A1(n15), .A2(n14), .Y(n16) );
  NAND2X1 U20 ( .A1(n16), .A2(inp[7]), .Y(n17) );
  NOR2X1 U21 ( .A1(n18), .A2(n17), .Y(out) );
endmodule

