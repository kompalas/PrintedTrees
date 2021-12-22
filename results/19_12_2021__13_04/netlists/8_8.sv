/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:15:45 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16;

  AND2X1 U11 ( .A1(n14), .A2(inp[3]), .Y(n15) );
  INVX1 U12 ( .A(n15), .Y(n9) );
  NOR2X1 U13 ( .A1(inp[4]), .A2(inp[5]), .Y(n11) );
  NOR2X1 U14 ( .A1(inp[6]), .A2(inp[7]), .Y(n10) );
  AND2X1 U15 ( .A1(n11), .A2(n10), .Y(n16) );
  NOR2X1 U16 ( .A1(inp[2]), .A2(inp[1]), .Y(n13) );
  INVX1 U17 ( .A(inp[0]), .Y(n12) );
  NAND2X1 U18 ( .A1(n13), .A2(n12), .Y(n14) );
  NAND2X1 U19 ( .A1(n16), .A2(n9), .Y(out) );
endmodule

