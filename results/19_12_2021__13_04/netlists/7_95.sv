/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:14:03 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [6:0] inp;
  output out;


  AND2X1 U4 ( .A1(inp[5]), .A2(inp[6]), .Y(out) );
endmodule

