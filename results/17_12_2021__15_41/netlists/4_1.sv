/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:42:30 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [3:0] inp;
  output out;
  wire   n3, n4;

  NOR2X1 U5 ( .A1(inp[2]), .A2(inp[1]), .Y(n4) );
  INVX1 U6 ( .A(inp[3]), .Y(n3) );
  NAND2X1 U7 ( .A1(n4), .A2(n3), .Y(out) );
endmodule

