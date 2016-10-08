//Release 2016.10.08
//File         : Processor.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : Processor Top
//version : 1.0
//
import System_Pkg::*;
import Processor_Pkg::*;

module Processor(
input Global System,

input Mem_Respond Inst1,Inst2,

output Mem_Req Inst1_req,Inst2_req,Data1_req,Data2_req
);

endmodule
