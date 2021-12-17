/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:01:01 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n5, n6, n7;

  NAND2X1 U7 ( .A1(inp[4]), .A2(inp[3]), .Y(n6) );
  NOR2X1 U8 ( .A1(inp[5]), .A2(inp[6]), .Y(n5) );
  NAND2X1 U9 ( .A1(n6), .A2(n5), .Y(n7) );
  AND2X1 U10 ( .A1(n7), .A2(inp[7]), .Y(out) );
endmodule

