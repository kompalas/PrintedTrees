/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:22:28 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14;

  AND2X1 U10 ( .A1(n13), .A2(n12), .Y(n14) );
  INVX1 U11 ( .A(n14), .Y(n8) );
  NOR2X1 U12 ( .A1(inp[3]), .A2(inp[4]), .Y(n10) );
  NAND2X1 U13 ( .A1(inp[1]), .A2(inp[2]), .Y(n9) );
  NAND2X1 U14 ( .A1(n9), .A2(n10), .Y(n11) );
  NAND2X1 U15 ( .A1(inp[5]), .A2(n11), .Y(n13) );
  INVX1 U16 ( .A(inp[6]), .Y(n12) );
  AND2X1 U17 ( .A1(n8), .A2(inp[7]), .Y(out) );
endmodule

