/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:02:57 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16;

  NAND2X1 U10 ( .A1(inp[1]), .A2(inp[2]), .Y(n9) );
  NAND2X1 U11 ( .A1(inp[5]), .A2(inp[3]), .Y(n8) );
  NOR2X1 U12 ( .A1(n9), .A2(n8), .Y(n12) );
  INVX1 U13 ( .A(inp[4]), .Y(n10) );
  NOR2X1 U14 ( .A1(n10), .A2(n14), .Y(n11) );
  NAND2X1 U15 ( .A1(n12), .A2(n11), .Y(n16) );
  INVX1 U16 ( .A(inp[7]), .Y(n14) );
  INVX1 U17 ( .A(inp[6]), .Y(n13) );
  OR2X1 U18 ( .A1(n14), .A2(n13), .Y(n15) );
  NAND2X1 U19 ( .A1(n16), .A2(n15), .Y(out) );
endmodule

