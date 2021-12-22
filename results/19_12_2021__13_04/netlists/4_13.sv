/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:05:35 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [3:0] inp;
  output out;
  wire   n2;

  AND2X1 U5 ( .A1(inp[1]), .A2(inp[2]), .Y(n2) );
  AND2X1 U6 ( .A1(inp[3]), .A2(n2), .Y(out) );
endmodule

