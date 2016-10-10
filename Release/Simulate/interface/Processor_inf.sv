//-------------------------------------------------------
// Description: Interface File
// File Name  : Processor_inf.sv
//-------------------------------------------------------
import System_Pkg::*;

interface Processor_inf(input bit clk);
logic rst;
Global System ;
Mem_Respond Inst1_Resp,Inst2_Resp;
Mem_Req Inst1_Req,Inst2_Req;


modport tester(
output rst,
input  clk,
output Inst1_Resp,Inst2_Resp,
input Inst1_Req,Inst2_Req
);


endinterface

