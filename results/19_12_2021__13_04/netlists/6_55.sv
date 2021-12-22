/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:09:33 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n2;

  AND2X1 U5 ( .A1(inp[3]), .A2(inp[4]), .Y(n2) );
  AND2X1 U6 ( .A1(inp[5]), .A2(n2), .Y(out) );
endmodule

