/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:14:08 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n6, n7, n8, n9;

  NAND2X1 U8 ( .A1(inp[5]), .A2(inp[6]), .Y(n9) );
  NOR2X1 U9 ( .A1(inp[2]), .A2(inp[1]), .Y(n7) );
  NOR2X1 U10 ( .A1(inp[3]), .A2(inp[4]), .Y(n6) );
  AND2X1 U11 ( .A1(n7), .A2(n6), .Y(n8) );
  NOR2X1 U12 ( .A1(n9), .A2(n8), .Y(out) );
endmodule

