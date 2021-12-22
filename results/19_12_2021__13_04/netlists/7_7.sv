/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:10:13 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n3, n4;

  NOR2X1 U5 ( .A1(inp[4]), .A2(inp[3]), .Y(n4) );
  NOR2X1 U6 ( .A1(inp[6]), .A2(inp[5]), .Y(n3) );
  NAND2X1 U7 ( .A1(n4), .A2(n3), .Y(out) );
endmodule

