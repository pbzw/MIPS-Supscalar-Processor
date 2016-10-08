// Release 2016.10.08
// File         : Decoder.sv
// Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
// Description  : Instruction Decode
// version : 1.0
//
import System_Pkg::*;

module Decoder(
input Mem_Respond Inst1,Inst2,

output Control_Decode Inst1_Control,Inst2_Control
);

Control Control1(
.Inst(Inst1),
.out(Inst1_Control)
);

Control Control2(
.Inst(Inst2),
.out(Inst2_Control)
);

endmodule
