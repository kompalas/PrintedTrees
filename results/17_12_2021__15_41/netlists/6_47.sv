/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:46:42 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n2, n3;

  INVX1 U4 ( .A(inp[4]), .Y(n3) );
  INVX1 U5 ( .A(inp[5]), .Y(n2) );
  NOR2X1 U6 ( .A1(n3), .A2(n2), .Y(out) );
endmodule

