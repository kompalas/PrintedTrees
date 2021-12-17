/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:04:39 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n2, n3;

  INVX1 U5 ( .A(inp[5]), .Y(n3) );
  NAND2X1 U6 ( .A1(inp[7]), .A2(inp[6]), .Y(n2) );
  NOR2X1 U7 ( .A1(n3), .A2(n2), .Y(out) );
endmodule

