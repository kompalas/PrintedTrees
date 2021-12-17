/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:53:34 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13;

  AND2X1 U9 ( .A1(n13), .A2(n12), .Y(n8) );
  AND2X1 U10 ( .A1(n11), .A2(n10), .Y(n9) );
  NAND2X1 U11 ( .A1(n9), .A2(n8), .Y(out) );
  NOR2X1 U12 ( .A1(inp[2]), .A2(inp[3]), .Y(n10) );
  NOR2X1 U13 ( .A1(inp[1]), .A2(inp[0]), .Y(n11) );
  NOR2X1 U14 ( .A1(inp[6]), .A2(inp[7]), .Y(n12) );
  NOR2X1 U15 ( .A1(inp[4]), .A2(inp[5]), .Y(n13) );
endmodule

