/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:02:31 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16;

  AND2X1 U10 ( .A1(inp[7]), .A2(inp[6]), .Y(n15) );
  INVX1 U11 ( .A(n15), .Y(n8) );
  NAND2X1 U12 ( .A1(inp[5]), .A2(inp[4]), .Y(n13) );
  INVX1 U13 ( .A(inp[1]), .Y(n10) );
  INVX1 U14 ( .A(inp[2]), .Y(n9) );
  NOR2X1 U15 ( .A1(n10), .A2(n9), .Y(n11) );
  NOR2X1 U16 ( .A1(inp[3]), .A2(n11), .Y(n12) );
  NOR2X1 U17 ( .A1(n13), .A2(n12), .Y(n14) );
  NAND2X1 U18 ( .A1(n14), .A2(inp[7]), .Y(n16) );
  NAND2X1 U19 ( .A1(n16), .A2(n8), .Y(out) );
endmodule

