/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:19:07 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  AND2X1 U13 ( .A1(n14), .A2(n13), .Y(n15) );
  INVX1 U14 ( .A(n15), .Y(n11) );
  INVX1 U15 ( .A(inp[7]), .Y(n20) );
  AND2X1 U16 ( .A1(inp[0]), .A2(inp[2]), .Y(n12) );
  NAND2X1 U17 ( .A1(n12), .A2(inp[1]), .Y(n14) );
  INVX1 U18 ( .A(inp[3]), .Y(n13) );
  NAND2X1 U19 ( .A1(n11), .A2(inp[4]), .Y(n17) );
  INVX1 U20 ( .A(inp[5]), .Y(n16) );
  NAND2X1 U21 ( .A1(n17), .A2(n16), .Y(n18) );
  NAND2X1 U22 ( .A1(n18), .A2(inp[6]), .Y(n19) );
  NAND2X1 U23 ( .A1(n19), .A2(n20), .Y(out) );
endmodule

