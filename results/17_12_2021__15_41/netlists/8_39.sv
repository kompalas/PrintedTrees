/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:55:30 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n5, n6, n7, n8, n9;

  INVX1 U7 ( .A(inp[4]), .Y(n6) );
  INVX1 U8 ( .A(inp[3]), .Y(n5) );
  NAND2X1 U9 ( .A1(n6), .A2(n5), .Y(n7) );
  NAND2X1 U10 ( .A1(n7), .A2(inp[5]), .Y(n9) );
  NOR2X1 U11 ( .A1(inp[6]), .A2(inp[7]), .Y(n8) );
  NAND2X1 U12 ( .A1(n9), .A2(n8), .Y(out) );
endmodule

