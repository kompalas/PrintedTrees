/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:01:37 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n8, n9, n10, n11, n12, n13, n14, n15;

  INVX1 U10 ( .A(inp[3]), .Y(n9) );
  INVX1 U11 ( .A(inp[2]), .Y(n8) );
  NAND2X1 U12 ( .A1(n9), .A2(n8), .Y(n10) );
  NOR2X1 U13 ( .A1(inp[4]), .A2(n10), .Y(n12) );
  INVX1 U14 ( .A(inp[5]), .Y(n11) );
  NOR2X1 U15 ( .A1(n12), .A2(n11), .Y(n13) );
  NOR2X1 U16 ( .A1(n13), .A2(inp[6]), .Y(n15) );
  INVX1 U17 ( .A(inp[7]), .Y(n14) );
  NOR2X1 U18 ( .A1(n15), .A2(n14), .Y(out) );
endmodule

