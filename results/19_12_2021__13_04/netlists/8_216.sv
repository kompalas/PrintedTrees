/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:24:40 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13;

  NAND2X1 U10 ( .A1(inp[3]), .A2(inp[4]), .Y(n10) );
  OR2X1 U11 ( .A1(inp[2]), .A2(inp[1]), .Y(n8) );
  NOR2X1 U12 ( .A1(inp[0]), .A2(n8), .Y(n9) );
  NOR2X1 U13 ( .A1(n10), .A2(n9), .Y(n11) );
  NOR2X1 U14 ( .A1(inp[5]), .A2(n11), .Y(n13) );
  NAND2X1 U15 ( .A1(inp[7]), .A2(inp[6]), .Y(n12) );
  NOR2X1 U16 ( .A1(n13), .A2(n12), .Y(out) );
endmodule

