/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:17:05 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n5, n6, n7;

  OR2X1 U7 ( .A1(inp[4]), .A2(inp[3]), .Y(n5) );
  NAND2X1 U8 ( .A1(n5), .A2(inp[5]), .Y(n7) );
  NOR2X1 U9 ( .A1(inp[6]), .A2(inp[7]), .Y(n6) );
  NAND2X1 U10 ( .A1(n7), .A2(n6), .Y(out) );
endmodule

