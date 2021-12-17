/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:50:36 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12, n13, n14;

  NOR2X1 U9 ( .A1(n8), .A2(n7), .Y(out) );
  INVX1 U10 ( .A(inp[6]), .Y(n7) );
  NOR2X1 U11 ( .A1(n14), .A2(n9), .Y(n8) );
  NOR2X1 U12 ( .A1(n11), .A2(n10), .Y(n9) );
  INVX1 U13 ( .A(inp[0]), .Y(n10) );
  INVX1 U14 ( .A(inp[1]), .Y(n11) );
  NOR2X1 U15 ( .A1(inp[3]), .A2(inp[4]), .Y(n13) );
  NOR2X1 U16 ( .A1(inp[2]), .A2(inp[5]), .Y(n12) );
  NAND2X1 U17 ( .A1(n13), .A2(n12), .Y(n14) );
endmodule

