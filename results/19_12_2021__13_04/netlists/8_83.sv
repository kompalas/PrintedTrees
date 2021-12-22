/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:18:59 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14;

  AND2X1 U10 ( .A1(n11), .A2(n10), .Y(n12) );
  INVX1 U11 ( .A(n12), .Y(n8) );
  INVX1 U12 ( .A(inp[7]), .Y(n14) );
  OR2X1 U13 ( .A1(inp[3]), .A2(inp[2]), .Y(n9) );
  NAND2X1 U14 ( .A1(n9), .A2(inp[4]), .Y(n11) );
  INVX1 U15 ( .A(inp[5]), .Y(n10) );
  NAND2X1 U16 ( .A1(n8), .A2(inp[6]), .Y(n13) );
  NAND2X1 U17 ( .A1(n13), .A2(n14), .Y(out) );
endmodule

