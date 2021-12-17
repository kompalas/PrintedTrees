/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:06:04 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14;

  NAND2X1 U10 ( .A1(n8), .A2(n11), .Y(n14) );
  NOR2X1 U11 ( .A1(n10), .A2(n9), .Y(n8) );
  NAND2X1 U12 ( .A1(inp[7]), .A2(inp[5]), .Y(n9) );
  NAND2X1 U13 ( .A1(inp[6]), .A2(inp[2]), .Y(n10) );
  NOR2X1 U14 ( .A1(n13), .A2(n12), .Y(n11) );
  NAND2X1 U15 ( .A1(inp[3]), .A2(inp[4]), .Y(n12) );
  NOR2X1 U16 ( .A1(inp[1]), .A2(inp[0]), .Y(n13) );
  INVX1 U17 ( .A(n14), .Y(out) );
endmodule

