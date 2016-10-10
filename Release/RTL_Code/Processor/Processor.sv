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
input  Global System,

input  Mem_Respond Inst1_Resp,Inst2_Resp,

output Mem_Req Inst1_Req,Inst2_Req,Data1_Req,Data2_Req
);

Local IF_Cntl,IF_ID_Cntl,ID_RN_Cntl,RN_IB_Cntl,IB_Cntl,EX_Cntl;


// IF Stage wire 
logic[31:0]PCsrcIn[0:7],PCsrc,PC_Adder_8,PC_Data,Branch_Target;
logic[2:0]PCsrcSel;
assign Inst1_Req.Address=PC_Data;

// IF/ID Stage wire 
IF_ID_Port IF_ID_In,IF_ID_Out;

// ID Stage wire 
Control_Decode Inst_Control[2];

// ID/RN Stage wire 
ID_RN_Port ID_RN_In,ID_RN_Out;

// RN/IB Stage wire
RN_IB_Port RN_IB_In,RN_IB_Out;
logic Branch_Flush,Rename_Fales;
//EX_Stage
logic [0:63]Wake_List;
logic Slot0_Full,Slot1_Full;
//Regfile
logic [5:0]RA[4],WA[4];
logic [31:0]RD[4],WD[4];
logic We[0:3];
//Commit Stage
Commit_Target Slot0_Commit_Target,Slot1_Commit_Target,Commit1,Commit2;
logic[31:0]Slot_Commit_PC[2],Slot_Branch_PC[2],Commit_PC;
logic Slot_Commit_Branch[2],Branch_Occur,Check_Commit;


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

Decoder Decoder(
.Inst1(IF_ID_Out.Inst1),
.Inst2(IF_ID_Out.Inst2),
.Inst1_Control(Inst_Control[0]),
.Inst2_Control(Inst_Control[1])
);

assign ID_RN_In={Inst_Control[0],IF_ID_Out.Inst1.Ready,Inst_Control[1],IF_ID_Out.Inst2.Ready,IF_ID_Out.PC};

ID_RN ID_RN(
.System(System),
.Cntl(ID_RN_Cntl),
.In(ID_RN_In),
.Out(ID_RN_Out)
);

Register_Rename Register_Rename(
.System(System),
.Cntl(ID_RN_Cntl),
.Branch_Flush(Branch_Flush),
//Commit Unit
.Commit1(Commit1),
.Commit2(Commit2),
//Pre_Rename
.Inst1(ID_RN_Out.Inst1.Pre_Rename),
.Inst2(ID_RN_Out.Inst2.Pre_Rename),
.RegW1(ID_RN_Out.Inst1.RegW),
.RegW2(ID_RN_Out.Inst2.RegW),
.Inst1_en(ID_RN_Out.Inst1_en),
.Inst2_en(ID_RN_Out.Inst2_en),
//Post Rename
.RInst1(RN_IB_In.Inst1_Post_Rename),
.RInst2(RN_IB_In.Inst2_Post_Rename),
//Rename_fales
.RU_Stall(Rename_Fales)
);


assign RN_IB_In.Inst1_en=ID_RN_Out.Inst1_en;
assign RN_IB_In.Inst1_Cont=ID_RN_Out.Inst1;
assign RN_IB_In.Inst2_en=ID_RN_Out.Inst2_en;
assign RN_IB_In.Inst2_Cont=ID_RN_Out.Inst2;
assign RN_IB_In.PC=ID_RN_Out.PC;

RN_IB RN_IB(
.System(System),
.Cntl(RN_IB_Cntl),
.In(RN_IB_In),
.Out(RN_IB_Out)
);

Wake_Unit Wake_Unit(
.System(System),
.Cntl(IB_Cntl),
.Inst1_Phydst(RN_IB_Out.Inst1_Post_Rename.Phydst),
.Inst2_Phydst(RN_IB_Out.Inst2_Post_Rename.Phydst),

.Port1({WA[0],We[0]}),
.Port2({WA[2],We[2]}),
.Port3(),
.Port4(),

.List(Wake_List)
);

EX_Slot EX_Slot_0(
.System(System),
.Cntl(IB_Cntl),
.Full(Slot0_Full),
//Inst Information
.Inst_Cont(RN_IB_Out.Inst1_Cont),
.Inst_Post_Rename(RN_IB_Out.Inst1_Post_Rename),
.Inst_En(RN_IB_Out.Inst1_en),
.Inst_PC(RN_IB_Out.PC),
//Wake List
.Wake_List(Wake_List),

//Read Regfile
.Src1(RA[0]),
.Src2(RA[1]),
//Data From Regfile
.Data1(RD[0]),
.Data2(RD[1]),

.Port1_Data(WD[0]),
.Port2_Data(WD[1]),
.Port1_Dst(WA[0]),
.Port2_Dst(WA[1]),
.Port1_We(We[0]),
.Port2_We(We[1]),

.Branch_To_PC(Slot_Branch_PC[0]),
.Commit_PC(Slot_Commit_PC[0]),
.Commit_Branch(Slot_Commit_Branch[0]),
.Commit(Slot0_Commit_Target),
.Check_Commit(Check_Commit)
);

EX_Slot EX_Slot_1(
.System(System),
.Cntl(IB_Cntl),
.Full(Slot1_Full),
//Inst Information
.Inst_Cont(RN_IB_Out.Inst2_Cont),
.Inst_Post_Rename(RN_IB_Out.Inst2_Post_Rename),
.Inst_En(RN_IB_Out.Inst2_en),
.Inst_PC((RN_IB_Out.PC+32'd4)),
//Wake List
.Wake_List(Wake_List),

//Read Regfile
.Src1(RA[2]),
.Src2(RA[3]),
//Data From Regfile
.Data1(RD[2]),
.Data2(RD[3]),

.Port1_Data(WD[2]),
.Port2_Data(WD[3]),
.Port1_Dst(WA[2]),
.Port2_Dst(WA[3]),
.Port1_We(We[2]),
.Port2_We(We[3]),

.Branch_To_PC(Slot_Branch_PC[1]),
.Commit_PC(Slot_Commit_PC[1]),
.Commit_Branch(Slot_Commit_Branch[1]),
.Commit(Slot1_Commit_Target),
.Check_Commit(Check_Commit)
);

assign Check_Commit=Slot0_Commit_Target.Commit&Slot1_Commit_Target.Commit;

always_ff@(posedge System.Clk)begin
  if(System.Rst|EX_Cntl.Flush|(!Check_Commit))
    {Commit1,Commit2,Branch_Occur,Branch_Target,Commit_PC}<='b0;
  else if(Check_Commit)begin
    Commit1<={Slot0_Commit_Target.Rdst,Slot0_Commit_Target.Phydst,Check_Commit};
    Commit2<={Slot1_Commit_Target.Rdst,Slot1_Commit_Target.Phydst,Check_Commit};
    Branch_Occur<=(Slot_Commit_Branch[0]|Slot_Commit_Branch[1])&Check_Commit;
    Branch_Target<=Slot_Commit_Branch[0]?Slot_Branch_PC[0]:Slot_Branch_PC[1];
    Commit_PC<=Slot_Commit_PC[0];
    end
 /* else
    {Commit1,Commit2,Branch_Occur,Branch_Target,Commit_PC}<='b0;*/
end

Regfile #(.Read_Port(4),.Write_Port(4),.Width(32),.Depth(64))Regfile(
.Clk(System.Clk),
.WD(WD),
.WA(WA),
.RA(RA),
.We(We),
.RD(RD)
);

System_Ctrl_Unit System_Ctrl_Unit(
.Inst_Ready(Inst1_Resp.Ready),
.Reorder_Buffer_Full(Slot0_Full|Slot1_Full),
.Rename_Fales(Rename_Fales),
.Branch_Occur(Branch_Occur),
.IF(IF_Cntl),
.IF_ID(IF_ID_Cntl),
.ID_RN(ID_RN_Cntl),
.RN_IB(RN_IB_Cntl),
.EX(EX_Cntl),
.Inst_Req(Inst1_Req.Req),
.IB(IB_Cntl),
.Commit(Check_Commit),
.PCsrcSel(PCsrcSel),
.Branch_Flush(Branch_Flush)
);



endmodule
