/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:01:46 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  AND2X1 U11 ( .A1(inp[6]), .A2(inp[7]), .Y(n10) );
  INVX1 U12 ( .A(n10), .Y(n9) );
  NAND2X1 U13 ( .A1(n11), .A2(n9), .Y(out) );
  NAND2X1 U14 ( .A1(n15), .A2(n12), .Y(n11) );
  NOR2X1 U15 ( .A1(n14), .A2(n13), .Y(n12) );
  INVX1 U16 ( .A(inp[5]), .Y(n13) );
  INVX1 U17 ( .A(inp[7]), .Y(n14) );
  NAND2X1 U18 ( .A1(n17), .A2(n16), .Y(n15) );
  NOR2X1 U19 ( .A1(inp[4]), .A2(inp[3]), .Y(n16) );
  NAND2X1 U20 ( .A1(n20), .A2(inp[1]), .Y(n17) );
  INVX1 U21 ( .A(inp[2]), .Y(n19) );
  INVX1 U22 ( .A(inp[0]), .Y(n18) );
  NOR2X1 U23 ( .A1(n19), .A2(n18), .Y(n20) );
endmodule

