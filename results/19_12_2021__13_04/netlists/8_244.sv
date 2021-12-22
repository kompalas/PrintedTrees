/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:25:55 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  OR2X1 U12 ( .A1(n14), .A2(n13), .Y(n11) );
  INVX1 U13 ( .A(n11), .Y(n10) );
  AND2X1 U14 ( .A1(inp[2]), .A2(inp[1]), .Y(n15) );
  INVX1 U15 ( .A(n15), .Y(n12) );
  NAND2X1 U16 ( .A1(inp[5]), .A2(inp[6]), .Y(n14) );
  NAND2X1 U17 ( .A1(inp[7]), .A2(inp[4]), .Y(n13) );
  NAND2X1 U18 ( .A1(inp[2]), .A2(inp[0]), .Y(n16) );
  NAND2X1 U19 ( .A1(n16), .A2(n12), .Y(n17) );
  NAND2X1 U20 ( .A1(n10), .A2(n17), .Y(n19) );
  NAND2X1 U21 ( .A1(n10), .A2(inp[3]), .Y(n18) );
  NAND2X1 U22 ( .A1(n19), .A2(n18), .Y(out) );
endmodule

