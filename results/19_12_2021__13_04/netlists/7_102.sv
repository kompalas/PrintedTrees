/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:14:20 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11;

  AND2X1 U9 ( .A1(inp[0]), .A2(inp[1]), .Y(n7) );
  NAND2X1 U10 ( .A1(n7), .A2(inp[2]), .Y(n9) );
  NOR2X1 U11 ( .A1(inp[3]), .A2(inp[4]), .Y(n8) );
  AND2X1 U12 ( .A1(n8), .A2(n9), .Y(n11) );
  NAND2X1 U13 ( .A1(inp[5]), .A2(inp[6]), .Y(n10) );
  NOR2X1 U14 ( .A1(n11), .A2(n10), .Y(out) );
endmodule

