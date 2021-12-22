/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:12:25 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14;

  AND2X1 U10 ( .A1(n10), .A2(n9), .Y(n11) );
  INVX1 U11 ( .A(n11), .Y(n8) );
  NAND2X1 U12 ( .A1(inp[0]), .A2(inp[1]), .Y(n10) );
  INVX1 U13 ( .A(inp[2]), .Y(n9) );
  NAND2X1 U14 ( .A1(n8), .A2(inp[3]), .Y(n13) );
  NAND2X1 U15 ( .A1(inp[4]), .A2(inp[5]), .Y(n12) );
  NOR2X1 U16 ( .A1(n13), .A2(n12), .Y(n14) );
  OR2X1 U17 ( .A1(inp[6]), .A2(n14), .Y(out) );
endmodule

