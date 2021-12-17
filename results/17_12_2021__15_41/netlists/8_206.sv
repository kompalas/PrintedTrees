/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:03:47 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n9, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  INVX1 U11 ( .A(n9), .Y(n12) );
  NOR2X1 U12 ( .A1(inp[5]), .A2(inp[4]), .Y(n9) );
  NAND2X1 U13 ( .A1(n18), .A2(n9), .Y(n17) );
  NOR2X1 U14 ( .A1(n11), .A2(n12), .Y(n19) );
  AND2X1 U15 ( .A1(inp[2]), .A2(inp[3]), .Y(n11) );
  NOR2X1 U16 ( .A1(n19), .A2(n13), .Y(out) );
  NAND2X1 U17 ( .A1(n17), .A2(n14), .Y(n13) );
  NOR2X1 U18 ( .A1(n16), .A2(n15), .Y(n14) );
  INVX1 U19 ( .A(inp[6]), .Y(n15) );
  INVX1 U20 ( .A(inp[7]), .Y(n16) );
  NAND2X1 U21 ( .A1(inp[1]), .A2(inp[0]), .Y(n18) );
endmodule

