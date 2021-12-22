/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:12:49 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n5, n6, n7, n8;

  AND2X1 U7 ( .A1(n7), .A2(n6), .Y(n8) );
  INVX1 U8 ( .A(n8), .Y(n5) );
  NOR2X1 U9 ( .A1(inp[3]), .A2(inp[2]), .Y(n7) );
  NOR2X1 U10 ( .A1(inp[4]), .A2(inp[5]), .Y(n6) );
  AND2X1 U11 ( .A1(inp[6]), .A2(n5), .Y(out) );
endmodule

