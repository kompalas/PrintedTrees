/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:53:36 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12, n13, n14;

  INVX1 U8 ( .A(inp[6]), .Y(n8) );
  INVX1 U9 ( .A(inp[7]), .Y(n7) );
  NAND2X1 U10 ( .A1(n8), .A2(n7), .Y(n12) );
  NOR2X1 U11 ( .A1(inp[5]), .A2(inp[1]), .Y(n10) );
  INVX1 U12 ( .A(inp[3]), .Y(n9) );
  NAND2X1 U13 ( .A1(n10), .A2(n9), .Y(n11) );
  NOR2X1 U14 ( .A1(n12), .A2(n11), .Y(n14) );
  NOR2X1 U15 ( .A1(inp[2]), .A2(inp[4]), .Y(n13) );
  NAND2X1 U16 ( .A1(n14), .A2(n13), .Y(out) );
endmodule

