/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:13:55 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14;

  AND2X1 U10 ( .A1(inp[6]), .A2(inp[5]), .Y(n13) );
  INVX1 U11 ( .A(n13), .Y(n8) );
  OR2X1 U12 ( .A1(inp[1]), .A2(inp[0]), .Y(n9) );
  NAND2X1 U13 ( .A1(n9), .A2(inp[3]), .Y(n11) );
  NAND2X1 U14 ( .A1(inp[4]), .A2(inp[2]), .Y(n10) );
  NOR2X1 U15 ( .A1(n11), .A2(n10), .Y(n12) );
  NAND2X1 U16 ( .A1(n12), .A2(inp[6]), .Y(n14) );
  NAND2X1 U17 ( .A1(n14), .A2(n8), .Y(out) );
endmodule

