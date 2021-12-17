/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:03:33 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n7, n8, n9, n10, n11, n12, n13, n14;

  NOR2X1 U9 ( .A1(n7), .A2(n14), .Y(out) );
  NOR2X1 U10 ( .A1(n11), .A2(n8), .Y(n7) );
  NAND2X1 U11 ( .A1(n10), .A2(n9), .Y(n8) );
  INVX1 U12 ( .A(inp[5]), .Y(n9) );
  INVX1 U13 ( .A(inp[4]), .Y(n10) );
  NOR2X1 U14 ( .A1(n13), .A2(n12), .Y(n11) );
  INVX1 U15 ( .A(inp[3]), .Y(n12) );
  NOR2X1 U16 ( .A1(inp[2]), .A2(inp[1]), .Y(n13) );
  NAND2X1 U17 ( .A1(inp[6]), .A2(inp[7]), .Y(n14) );
endmodule

