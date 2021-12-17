/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:42:57 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [3:0] inp;
  output out;
  wire   n2, n3;

  INVX1 U4 ( .A(inp[2]), .Y(n3) );
  INVX1 U5 ( .A(inp[3]), .Y(n2) );
  NOR2X1 U6 ( .A1(n3), .A2(n2), .Y(out) );
endmodule

