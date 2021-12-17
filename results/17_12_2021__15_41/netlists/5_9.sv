/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:43:31 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;
  wire   n4, n5, n6, n7, n8;

  INVX1 U7 ( .A(inp[2]), .Y(n5) );
  INVX1 U8 ( .A(inp[1]), .Y(n4) );
  NAND2X1 U9 ( .A1(n5), .A2(n4), .Y(n6) );
  NAND2X1 U10 ( .A1(n6), .A2(inp[3]), .Y(n8) );
  INVX1 U11 ( .A(inp[4]), .Y(n7) );
  NAND2X1 U12 ( .A1(n8), .A2(n7), .Y(out) );
endmodule

