/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:51:07 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n6, n7, n8, n9, n10, n11;

  NAND2X1 U8 ( .A1(inp[3]), .A2(inp[2]), .Y(n7) );
  INVX1 U9 ( .A(inp[1]), .Y(n6) );
  NOR2X1 U10 ( .A1(n7), .A2(n6), .Y(n9) );
  OR2X1 U11 ( .A1(inp[4]), .A2(inp[5]), .Y(n8) );
  NOR2X1 U12 ( .A1(n9), .A2(n8), .Y(n11) );
  INVX1 U13 ( .A(inp[6]), .Y(n10) );
  NOR2X1 U14 ( .A1(n11), .A2(n10), .Y(out) );
endmodule

