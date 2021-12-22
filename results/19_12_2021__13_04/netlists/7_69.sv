/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:12:54 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12;

  AND2X1 U9 ( .A1(inp[6]), .A2(inp[3]), .Y(n11) );
  INVX1 U10 ( .A(n11), .Y(n7) );
  NOR2X1 U11 ( .A1(inp[4]), .A2(inp[5]), .Y(n9) );
  NAND2X1 U12 ( .A1(inp[1]), .A2(inp[2]), .Y(n8) );
  NAND2X1 U13 ( .A1(n8), .A2(n9), .Y(n10) );
  NAND2X1 U14 ( .A1(inp[6]), .A2(n10), .Y(n12) );
  NAND2X1 U15 ( .A1(n12), .A2(n7), .Y(out) );
endmodule

