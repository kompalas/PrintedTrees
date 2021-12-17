/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:50:24 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15;

  NAND2X1 U10 ( .A1(inp[1]), .A2(inp[2]), .Y(n9) );
  NAND2X1 U11 ( .A1(inp[5]), .A2(inp[0]), .Y(n8) );
  NOR2X1 U12 ( .A1(n9), .A2(n8), .Y(n13) );
  INVX1 U13 ( .A(inp[4]), .Y(n11) );
  INVX1 U14 ( .A(inp[3]), .Y(n10) );
  NOR2X1 U15 ( .A1(n11), .A2(n10), .Y(n12) );
  NAND2X1 U16 ( .A1(n13), .A2(n12), .Y(n15) );
  INVX1 U17 ( .A(inp[6]), .Y(n14) );
  NAND2X1 U18 ( .A1(n15), .A2(n14), .Y(out) );
endmodule

