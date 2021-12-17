/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:45:35 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n3, n4;

  NAND2X1 U6 ( .A1(inp[3]), .A2(inp[4]), .Y(n4) );
  INVX1 U7 ( .A(inp[5]), .Y(n3) );
  NAND2X1 U8 ( .A1(n4), .A2(n3), .Y(out) );
endmodule

