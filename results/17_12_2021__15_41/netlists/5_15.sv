/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:43:47 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [4:0] inp;
  output out;

  assign out = inp[4];

endmodule

