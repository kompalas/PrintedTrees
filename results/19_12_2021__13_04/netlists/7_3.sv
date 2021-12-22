/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:10:02 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n5, n6, n7, n8;

  AND2X1 U6 ( .A1(n7), .A2(n6), .Y(n8) );
  INVX1 U7 ( .A(n8), .Y(n5) );
  NOR2X1 U8 ( .A1(inp[5]), .A2(inp[3]), .Y(n7) );
  NOR2X1 U9 ( .A1(inp[2]), .A2(inp[6]), .Y(n6) );
  OR2X1 U10 ( .A1(inp[4]), .A2(n5), .Y(out) );
endmodule

