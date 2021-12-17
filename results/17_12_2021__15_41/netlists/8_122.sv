/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:59:34 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17;

  NOR2X1 U12 ( .A1(n11), .A2(n10), .Y(n14) );
  NAND2X1 U13 ( .A1(inp[6]), .A2(inp[3]), .Y(n10) );
  NAND2X1 U14 ( .A1(inp[5]), .A2(inp[4]), .Y(n11) );
  NAND2X1 U15 ( .A1(n12), .A2(n17), .Y(out) );
  NAND2X1 U16 ( .A1(n13), .A2(n14), .Y(n12) );
  NAND2X1 U17 ( .A1(n16), .A2(n15), .Y(n13) );
  NAND2X1 U18 ( .A1(inp[0]), .A2(inp[1]), .Y(n16) );
  INVX1 U19 ( .A(inp[2]), .Y(n15) );
  INVX1 U20 ( .A(inp[7]), .Y(n17) );
endmodule

