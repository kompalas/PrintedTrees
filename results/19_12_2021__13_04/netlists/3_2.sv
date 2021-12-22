/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:04:49 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [2:0] inp;
  output out;
  wire   n3, n4;

  INVX1 U6 ( .A(inp[2]), .Y(n4) );
  NAND2X1 U7 ( .A1(inp[0]), .A2(inp[1]), .Y(n3) );
  NAND2X1 U8 ( .A1(n3), .A2(n4), .Y(out) );
endmodule

