/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 16:01:25 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [7:0] inp;
  output out;
  wire   n3, n4;

  NOR2X1 U6 ( .A1(n4), .A2(n3), .Y(out) );
  INVX1 U7 ( .A(inp[7]), .Y(n3) );
  NOR2X1 U8 ( .A1(inp[5]), .A2(inp[6]), .Y(n4) );
endmodule

