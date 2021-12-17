/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:50:56 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n6, n7, n8, n9, n10, n11, n12, n13;

  NOR2X1 U8 ( .A1(inp[2]), .A2(inp[1]), .Y(n7) );
  INVX1 U9 ( .A(inp[3]), .Y(n6) );
  NOR2X1 U10 ( .A1(n7), .A2(n6), .Y(n11) );
  INVX1 U11 ( .A(inp[4]), .Y(n9) );
  INVX1 U12 ( .A(inp[5]), .Y(n8) );
  NAND2X1 U13 ( .A1(n9), .A2(n8), .Y(n10) );
  NOR2X1 U14 ( .A1(n11), .A2(n10), .Y(n13) );
  INVX1 U15 ( .A(inp[6]), .Y(n12) );
  NOR2X1 U16 ( .A1(n13), .A2(n12), .Y(out) );
endmodule

