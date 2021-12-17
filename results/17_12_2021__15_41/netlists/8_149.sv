/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:00:56 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;

  NAND2X1 U10 ( .A1(n12), .A2(n8), .Y(out) );
  NAND2X1 U11 ( .A1(n9), .A2(inp[7]), .Y(n8) );
  NAND2X1 U12 ( .A1(n11), .A2(n10), .Y(n9) );
  INVX1 U13 ( .A(inp[6]), .Y(n10) );
  INVX1 U14 ( .A(inp[5]), .Y(n11) );
  NAND2X1 U15 ( .A1(n16), .A2(n13), .Y(n12) );
  NOR2X1 U16 ( .A1(n15), .A2(n14), .Y(n13) );
  INVX1 U17 ( .A(inp[4]), .Y(n14) );
  INVX1 U18 ( .A(inp[7]), .Y(n15) );
  NAND2X1 U19 ( .A1(n18), .A2(n17), .Y(n16) );
  INVX1 U20 ( .A(inp[3]), .Y(n17) );
  NAND2X1 U21 ( .A1(inp[2]), .A2(inp[1]), .Y(n18) );
endmodule

