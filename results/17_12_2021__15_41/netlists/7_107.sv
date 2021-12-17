/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:52:32 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n5, n6, n7, n8, n9;

  NAND2X1 U7 ( .A1(inp[6]), .A2(inp[5]), .Y(n9) );
  INVX1 U8 ( .A(inp[2]), .Y(n6) );
  INVX1 U9 ( .A(inp[3]), .Y(n5) );
  NOR2X1 U10 ( .A1(n6), .A2(n5), .Y(n7) );
  NOR2X1 U11 ( .A1(inp[4]), .A2(n7), .Y(n8) );
  NOR2X1 U12 ( .A1(n9), .A2(n8), .Y(out) );
endmodule

