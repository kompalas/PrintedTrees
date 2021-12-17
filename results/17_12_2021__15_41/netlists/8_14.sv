/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:54:17 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15;

  NOR2X1 U11 ( .A1(inp[6]), .A2(inp[5]), .Y(n9) );
  NAND2X1 U12 ( .A1(inp[2]), .A2(inp[3]), .Y(n10) );
  NAND2X1 U13 ( .A1(n9), .A2(n10), .Y(n13) );
  NAND2X1 U14 ( .A1(inp[0]), .A2(inp[1]), .Y(n11) );
  NAND2X1 U15 ( .A1(n11), .A2(n9), .Y(n12) );
  NAND2X1 U16 ( .A1(n13), .A2(n12), .Y(n15) );
  NOR2X1 U17 ( .A1(inp[7]), .A2(inp[4]), .Y(n14) );
  NAND2X1 U18 ( .A1(n15), .A2(n14), .Y(out) );
endmodule

