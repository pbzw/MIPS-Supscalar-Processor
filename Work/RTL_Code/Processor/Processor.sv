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

input Mem_Respond Inst1_Resp,Inst2_Resp,

output Mem_Req Inst1_Req,Inst2_Req,Data1_req,Data2_req
);

Local IF_Cntl,IF_ID_Cntl,ID_RN_Cntl,RN_IS_Cntl,EX_Cntl,IS_Cntl;


// IF Stage wire 
logic[31:0]PCsrcIn[0:7],PC_Adder_8,PC_Data,Branch_Target;

assign Inst1_Req.Address=PC_Data;

// IF/ID Stage wire 
IF_ID_Port IF_ID_In,IF_ID_Out;

Register #(.WIDTH(32),.reset('h0000))PC(
.System(System),
.En(!IF_Cntl.Stall),
.In(PCsrc),
.Out(PC_Data)
);

Adder PC_Adder(
.A(PC_Data),
.B(32'd8),
.C(PC_Adder_8)
);


assign PCsrcIn[0]=PC_Adder_8;
assign PCsrcIn[1]=Branch_Target;

Muxer #(.In_Port(8),.WIDTH(32))PCsrcMux(
.sel(PCsrcSel),
.in(PCsrcIn),
.out(PCsrc)
);

assign IF_ID_In={Inst1_Resp,Inst2_Resp,PC_Data};

IF_ID IF_ID(
.System(System),
.Cntl(IF_ID_Cntl),
.In(IF_ID_In),
.Out(IF_ID_Out)
);

System_Ctrl_Unit System_Ctrl_Unit(
.Inst_Ready(Inst1_Resp.Ready),
.Reorder_Buffer_Full(Reorder_Buffer_Full),
.Rename_Fales(Rename_Fales),
.Branch_Occur(),
.IF(IF_Cntl),
.IF_ID(IF_ID_Cntl),
.ID_RN(ID_RN_Cntl),
.RN_IS(RN_IS_Cntl),
.EX(EX_cntl),
.Inst_Req(Inst1_Req.Req),
.IS(IS_cntl),
.Commit(1'b0),
.PCsrcSel(PCsrcSel),
.Branch_Flush(Branch_Flush)
);



endmodule
