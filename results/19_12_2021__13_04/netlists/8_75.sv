/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:18:39 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11;

  INVX1 U9 ( .A(inp[7]), .Y(n11) );
  NOR2X1 U10 ( .A1(inp[4]), .A2(inp[5]), .Y(n8) );
  NAND2X1 U11 ( .A1(inp[2]), .A2(inp[3]), .Y(n7) );
  NAND2X1 U12 ( .A1(n7), .A2(n8), .Y(n9) );
  NAND2X1 U13 ( .A1(inp[6]), .A2(n9), .Y(n10) );
  NAND2X1 U14 ( .A1(n10), .A2(n11), .Y(out) );
endmodule

