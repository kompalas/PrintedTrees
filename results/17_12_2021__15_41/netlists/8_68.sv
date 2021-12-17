/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:56:52 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n13, n14, n15, n16, n17, n18, n19, n20;

  AND2X1 U12 ( .A1(n11), .A2(n10), .Y(n16) );
  INVX1 U13 ( .A(inp[3]), .Y(n10) );
  NOR2X1 U14 ( .A1(inp[5]), .A2(inp[4]), .Y(n11) );
  NAND2X1 U15 ( .A1(n13), .A2(n20), .Y(out) );
  NAND2X1 U16 ( .A1(n14), .A2(inp[6]), .Y(n13) );
  NAND2X1 U17 ( .A1(n16), .A2(n15), .Y(n14) );
  NAND2X1 U18 ( .A1(n17), .A2(inp[2]), .Y(n15) );
  NAND2X1 U19 ( .A1(n19), .A2(n18), .Y(n17) );
  INVX1 U20 ( .A(inp[0]), .Y(n18) );
  INVX1 U21 ( .A(inp[1]), .Y(n19) );
  INVX1 U22 ( .A(inp[7]), .Y(n20) );
endmodule

