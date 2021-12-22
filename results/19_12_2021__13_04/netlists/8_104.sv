/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:19:54 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  AND2X1 U13 ( .A1(n13), .A2(n12), .Y(n14) );
  INVX1 U14 ( .A(n14), .Y(n11) );
  INVX1 U15 ( .A(inp[7]), .Y(n20) );
  NOR2X1 U16 ( .A1(inp[2]), .A2(inp[1]), .Y(n13) );
  INVX1 U17 ( .A(inp[0]), .Y(n12) );
  NAND2X1 U18 ( .A1(n11), .A2(inp[3]), .Y(n16) );
  INVX1 U19 ( .A(inp[4]), .Y(n15) );
  NAND2X1 U20 ( .A1(n16), .A2(n15), .Y(n17) );
  AND2X1 U21 ( .A1(n17), .A2(inp[5]), .Y(n18) );
  NAND2X1 U22 ( .A1(n18), .A2(inp[6]), .Y(n19) );
  NAND2X1 U23 ( .A1(n19), .A2(n20), .Y(out) );
endmodule

