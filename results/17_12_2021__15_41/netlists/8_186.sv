/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:02:48 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;

  OR2X1 U12 ( .A1(n12), .A2(n11), .Y(n10) );
  INVX1 U13 ( .A(inp[7]), .Y(n11) );
  INVX1 U14 ( .A(inp[6]), .Y(n12) );
  NAND2X1 U15 ( .A1(n13), .A2(n14), .Y(n19) );
  NAND2X1 U16 ( .A1(n17), .A2(n16), .Y(n13) );
  NOR2X1 U17 ( .A1(n18), .A2(n15), .Y(n14) );
  NAND2X1 U18 ( .A1(inp[7]), .A2(inp[5]), .Y(n15) );
  NAND2X1 U19 ( .A1(inp[3]), .A2(inp[4]), .Y(n18) );
  NAND2X1 U20 ( .A1(inp[0]), .A2(inp[1]), .Y(n17) );
  INVX1 U21 ( .A(inp[2]), .Y(n16) );
  NAND2X1 U22 ( .A1(n19), .A2(n10), .Y(out) );
endmodule

