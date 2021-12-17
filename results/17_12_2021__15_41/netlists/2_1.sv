/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12-SP4
// Date      : Fri Dec 17 15:42:04 2021
/////////////////////////////////////////////////////////////


module top ( inp, out );
  input [1:0] inp;
  output out;

  assign out = inp[1];

endmodule

