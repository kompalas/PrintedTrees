/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:45:13 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [5:0] inp;
  output out;
  wire   n2, n3;

  INVX1 U3 ( .A(inp[5]), .Y(n3) );
  INVX1 U4 ( .A(inp[4]), .Y(n2) );
  NAND2X1 U5 ( .A1(n3), .A2(n2), .Y(out) );
endmodule

