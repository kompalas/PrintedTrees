/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:55:04 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17;

  NAND2X1 U10 ( .A1(n8), .A2(n10), .Y(out) );
  AND2X1 U11 ( .A1(n17), .A2(n9), .Y(n8) );
  NOR2X1 U12 ( .A1(inp[6]), .A2(inp[7]), .Y(n9) );
  NAND2X1 U13 ( .A1(n14), .A2(n11), .Y(n10) );
  NOR2X1 U14 ( .A1(n13), .A2(n12), .Y(n11) );
  INVX1 U15 ( .A(inp[3]), .Y(n12) );
  INVX1 U16 ( .A(inp[1]), .Y(n13) );
  NOR2X1 U17 ( .A1(n16), .A2(n15), .Y(n14) );
  NAND2X1 U18 ( .A1(inp[2]), .A2(inp[0]), .Y(n15) );
  INVX1 U19 ( .A(inp[4]), .Y(n16) );
  INVX1 U20 ( .A(inp[5]), .Y(n17) );
endmodule

