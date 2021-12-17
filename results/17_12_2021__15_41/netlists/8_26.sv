/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:54:53 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  NOR2X1 U12 ( .A1(n11), .A2(n10), .Y(n14) );
  INVX1 U13 ( .A(inp[3]), .Y(n10) );
  INVX1 U14 ( .A(inp[4]), .Y(n11) );
  NOR2X1 U15 ( .A1(n15), .A2(n12), .Y(out) );
  NOR2X1 U16 ( .A1(n14), .A2(n13), .Y(n12) );
  NAND2X1 U17 ( .A1(n20), .A2(n18), .Y(n13) );
  NOR2X1 U18 ( .A1(n17), .A2(n16), .Y(n15) );
  NAND2X1 U19 ( .A1(n20), .A2(n19), .Y(n16) );
  INVX1 U20 ( .A(inp[5]), .Y(n18) );
  NOR2X1 U21 ( .A1(inp[5]), .A2(inp[2]), .Y(n19) );
  AND2X1 U22 ( .A1(inp[1]), .A2(inp[0]), .Y(n17) );
  NOR2X1 U23 ( .A1(inp[6]), .A2(inp[7]), .Y(n20) );
endmodule

