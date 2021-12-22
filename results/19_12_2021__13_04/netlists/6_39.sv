/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:08:49 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n3, n4, n5;

  AND2X1 U6 ( .A1(inp[5]), .A2(inp[4]), .Y(n4) );
  INVX1 U7 ( .A(n4), .Y(n3) );
  NAND2X1 U8 ( .A1(inp[5]), .A2(inp[3]), .Y(n5) );
  NAND2X1 U9 ( .A1(n5), .A2(n3), .Y(out) );
endmodule

