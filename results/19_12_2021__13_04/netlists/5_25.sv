/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:06:46 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;
  wire   n3, n4, n5;

  AND2X1 U6 ( .A1(inp[4]), .A2(inp[3]), .Y(n4) );
  INVX1 U7 ( .A(n4), .Y(n3) );
  NOR2X1 U8 ( .A1(inp[2]), .A2(inp[1]), .Y(n5) );
  NOR2X1 U9 ( .A1(n5), .A2(n3), .Y(out) );
endmodule

