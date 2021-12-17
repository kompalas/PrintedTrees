/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:42:09 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [2:0] inp;
  output out;
  wire   n3, n4;

  NOR2X1 U5 ( .A1(inp[1]), .A2(inp[0]), .Y(n4) );
  INVX1 U6 ( .A(inp[2]), .Y(n3) );
  NAND2X1 U7 ( .A1(n4), .A2(n3), .Y(out) );
endmodule

