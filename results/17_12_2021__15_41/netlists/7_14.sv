/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:48:06 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11;

  NAND2X1 U9 ( .A1(inp[0]), .A2(inp[1]), .Y(n8) );
  NAND2X1 U10 ( .A1(inp[2]), .A2(inp[3]), .Y(n7) );
  NOR2X1 U11 ( .A1(n8), .A2(n7), .Y(n9) );
  NOR2X1 U12 ( .A1(n9), .A2(inp[5]), .Y(n11) );
  NOR2X1 U13 ( .A1(inp[6]), .A2(inp[4]), .Y(n10) );
  NAND2X1 U14 ( .A1(n11), .A2(n10), .Y(out) );
endmodule

