/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:04:37 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [1:0] inp;
  output out;


  OR2X1 U3 ( .A1(inp[1]), .A2(inp[0]), .Y(out) );
endmodule

