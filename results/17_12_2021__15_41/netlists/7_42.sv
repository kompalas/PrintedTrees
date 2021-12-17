/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:49:26 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;
  wire   n10, n11, n12, n13, n14, n15, n16, n17;

  NAND2X1 U12 ( .A1(inp[0]), .A2(inp[1]), .Y(n11) );
  INVX1 U13 ( .A(inp[2]), .Y(n10) );
  NAND2X1 U14 ( .A1(n11), .A2(n10), .Y(n12) );
  NAND2X1 U15 ( .A1(n12), .A2(inp[3]), .Y(n14) );
  INVX1 U16 ( .A(inp[4]), .Y(n13) );
  NAND2X1 U17 ( .A1(n14), .A2(n13), .Y(n15) );
  NAND2X1 U18 ( .A1(n15), .A2(inp[5]), .Y(n17) );
  INVX1 U19 ( .A(inp[6]), .Y(n16) );
  NAND2X1 U20 ( .A1(n17), .A2(n16), .Y(out) );
endmodule

