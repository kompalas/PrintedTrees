/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:44:31 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n6, n7, n8, n9, n10;

  NOR2X1 U7 ( .A1(inp[5]), .A2(inp[0]), .Y(n7) );
  INVX1 U8 ( .A(inp[2]), .Y(n6) );
  NAND2X1 U9 ( .A1(n7), .A2(n6), .Y(n8) );
  NOR2X1 U10 ( .A1(inp[3]), .A2(n8), .Y(n10) );
  NOR2X1 U11 ( .A1(inp[1]), .A2(inp[4]), .Y(n9) );
  NAND2X1 U12 ( .A1(n10), .A2(n9), .Y(out) );
endmodule

