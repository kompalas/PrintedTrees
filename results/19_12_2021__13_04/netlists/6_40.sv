/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:08:51 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13;

  INVX1 U10 ( .A(inp[4]), .Y(n12) );
  NOR2X1 U11 ( .A1(inp[2]), .A2(inp[1]), .Y(n9) );
  INVX1 U12 ( .A(inp[0]), .Y(n8) );
  NAND2X1 U13 ( .A1(n9), .A2(n8), .Y(n10) );
  NAND2X1 U14 ( .A1(n10), .A2(inp[3]), .Y(n11) );
  NAND2X1 U15 ( .A1(n11), .A2(n12), .Y(n13) );
  AND2X1 U16 ( .A1(inp[5]), .A2(n13), .Y(out) );
endmodule

