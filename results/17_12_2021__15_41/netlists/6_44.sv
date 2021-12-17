/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:46:34 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12, n13, n14;

  NAND2X1 U9 ( .A1(n10), .A2(n7), .Y(n14) );
  NOR2X1 U10 ( .A1(n9), .A2(n8), .Y(n7) );
  INVX1 U11 ( .A(inp[3]), .Y(n8) );
  INVX1 U12 ( .A(inp[5]), .Y(n9) );
  NOR2X1 U13 ( .A1(n12), .A2(n11), .Y(n10) );
  INVX1 U14 ( .A(inp[2]), .Y(n11) );
  NOR2X1 U15 ( .A1(inp[1]), .A2(inp[0]), .Y(n12) );
  NAND2X1 U16 ( .A1(inp[5]), .A2(inp[4]), .Y(n13) );
  NAND2X1 U17 ( .A1(n14), .A2(n13), .Y(out) );
endmodule

