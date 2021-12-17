/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:42:25 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [2:0] inp;
  output out;
  wire   n2, n3;

  INVX1 U5 ( .A(inp[0]), .Y(n3) );
  NAND2X1 U6 ( .A1(inp[2]), .A2(inp[1]), .Y(n2) );
  NOR2X1 U7 ( .A1(n3), .A2(n2), .Y(out) );
endmodule

