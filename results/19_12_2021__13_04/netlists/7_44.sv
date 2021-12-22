/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:11:49 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18;

  AND2X1 U12 ( .A1(n12), .A2(n11), .Y(n13) );
  INVX1 U13 ( .A(n13), .Y(n10) );
  INVX1 U14 ( .A(inp[6]), .Y(n18) );
  NAND2X1 U15 ( .A1(inp[3]), .A2(inp[0]), .Y(n12) );
  NAND2X1 U16 ( .A1(inp[3]), .A2(inp[1]), .Y(n11) );
  NAND2X1 U17 ( .A1(n10), .A2(inp[2]), .Y(n15) );
  INVX1 U18 ( .A(inp[4]), .Y(n14) );
  NAND2X1 U19 ( .A1(n15), .A2(n14), .Y(n16) );
  NAND2X1 U20 ( .A1(n16), .A2(inp[5]), .Y(n17) );
  NAND2X1 U21 ( .A1(n17), .A2(n18), .Y(out) );
endmodule

