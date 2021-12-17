/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:04:36 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15;

  NOR2X1 U10 ( .A1(inp[5]), .A2(n8), .Y(n14) );
  NOR2X1 U11 ( .A1(n13), .A2(n9), .Y(n8) );
  NAND2X1 U12 ( .A1(n10), .A2(inp[4]), .Y(n9) );
  NOR2X1 U13 ( .A1(n12), .A2(n11), .Y(n10) );
  INVX1 U14 ( .A(inp[1]), .Y(n11) );
  INVX1 U15 ( .A(inp[3]), .Y(n12) );
  NAND2X1 U16 ( .A1(inp[0]), .A2(inp[2]), .Y(n13) );
  NAND2X1 U17 ( .A1(inp[6]), .A2(inp[7]), .Y(n15) );
  NOR2X1 U18 ( .A1(n15), .A2(n14), .Y(out) );
endmodule

