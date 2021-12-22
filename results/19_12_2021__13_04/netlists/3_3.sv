/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Sun Dec 19 13:04:52 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [2:0] inp;
  output out;

  assign out = inp[2];

endmodule

