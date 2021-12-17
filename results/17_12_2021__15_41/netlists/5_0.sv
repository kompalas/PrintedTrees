/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:43:07 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;
  wire   n5, n6, n8, n9;

  AND2X1 U6 ( .A1(n6), .A2(n5), .Y(n9) );
  INVX1 U7 ( .A(inp[0]), .Y(n5) );
  NOR2X1 U8 ( .A1(inp[2]), .A2(inp[4]), .Y(n6) );
  NOR2X1 U9 ( .A1(inp[3]), .A2(inp[1]), .Y(n8) );
  NAND2X1 U10 ( .A1(n9), .A2(n8), .Y(out) );
endmodule

