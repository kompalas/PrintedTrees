/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:46:04 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n5, n6, n7, n8, n9, n10, n11, n12;

  INVX1 U7 ( .A(inp[2]), .Y(n5) );
  INVX1 U8 ( .A(inp[1]), .Y(n6) );
  NAND2X1 U9 ( .A1(n8), .A2(n7), .Y(n9) );
  INVX1 U10 ( .A(inp[4]), .Y(n7) );
  INVX1 U11 ( .A(inp[3]), .Y(n8) );
  NOR2X1 U12 ( .A1(n10), .A2(n9), .Y(n11) );
  NAND2X1 U13 ( .A1(n6), .A2(n5), .Y(n10) );
  INVX1 U14 ( .A(inp[5]), .Y(n12) );
  NOR2X1 U15 ( .A1(n12), .A2(n11), .Y(out) );
endmodule

