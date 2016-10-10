//Release 2016.10.10
//File         : EX_Slot.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0

import System_Pkg::*;

module EX_Slot #(parameter Depth = 8)(
input Global System,
input Local Cntl,
output Full,
//Inst Information
input Control_Decode Inst_Cont,
input Post_Rename Inst_Post_Rename,
input Inst_En,
input [31:0]Inst_PC,
//Wake List
input [0:63]Wake_List,

//Read Regfile
output [5:0]Src1,Src2,
//Data From Regfile
input [31:0]Data1,Data2,
//WritData_Port
output[31:0]Port1_Data,Port2_Data,
output[5:0] Port1_Dst,Port2_Dst,
output Port1_We,Port2_We,
//

output [31:0]Branch_To_PC,Commit_PC,
output Commit_Target Commit,
output Commit_Branch,
input Check_Commit,
//Store_OnPipe
output Local_Store_OnPipe,
input Global_Store_OnPipe
);

logic Reorder_Buffer_Full;
//Pipe0
Inst_FIFO_Slot Inst_FIFO_Top,Inst_Inf_Pipe0;
logic Read_FIFO,Stall_Pipe0;
logic [$clog2(Depth)-1:0]Commit_Window_Pipe0,RP;
logic Empty;

//Pipe 1
logic [1:0] WB_Stage;
logic [3:0] Unit_Pipe1;
logic [4:0] OP_Pipe1;
logic [5:0] Phydst_Pipe1;
logic [31:0]PC_Pipe1,Imme_Pipe1,Data1_Pipe1,Data2_Pipe1,ALU_Result,Branch_To;
logic [$clog2(Depth)-1:0]Commit_Window_Pipe1;
logic Valid_Pipe1,Flush_Pipe1,Branch;

//Pipe 2 (Port1 Commit)

logic [1:0] WB_Stage_Pipe2;
logic [$clog2(Depth)-1:0]Commit_Window_Pipe2;
logic [31:0]Branch_To_Pipe2,Branch_To_Pipe,EX_Result,EX_Result_Pipe2;
logic [5:0]Phydst_Pipe2;
logic Valid_Pipe2,Branch_Pipe2;

Inst_FIFO#(.Depth(Depth))Inst_FIFO(
.System(System),
.Cntl(Cntl),

//Data in
.Inst_PC(Inst_PC),
.Inst_Cont(Inst_Cont),
.Inst_Post_Rename(Inst_Post_Rename),
.Inst_En(Inst_En),
//Control
.We(Inst_En&(!Cntl.Stall)),
.Re(Read_FIFO),
.Full(Full),
.Empty(Empty),
//Data Out
.FIFO_Top(Inst_FIFO_Top),
.RP(RP)
);

always_ff@(posedge System.Clk)begin
  if(System.Rst|Cntl.Flush|(Empty&!Stall_Pipe0))begin
    Inst_Inf_Pipe0<='b0;
    Commit_Window_Pipe0<='b0;
    end
  else if(!Stall_Pipe0)begin
    Inst_Inf_Pipe0<=Inst_FIFO_Top;
    Commit_Window_Pipe0<=RP;
    end
end

assign Src1=Inst_Inf_Pipe0.Src1;
assign Src2=Inst_Inf_Pipe0.Src2;

always_ff@(posedge System.Clk)begin
  if(System.Rst|Cntl.Flush|Flush_Pipe1)
    {Unit_Pipe1,OP_Pipe1,Phydst_Pipe1,PC_Pipe1,Imme_Pipe1,Data1_Pipe1,Data2_Pipe1,Commit_Window_Pipe1,Valid_Pipe1}<='b0;
  else begin
    Unit_Pipe1<=Inst_Inf_Pipe0.Unit;
    OP_Pipe1<=Inst_Inf_Pipe0.OP;
    Phydst_Pipe1<=Inst_Inf_Pipe0.Phydst;
    PC_Pipe1<=Inst_Inf_Pipe0.PC;
    Imme_Pipe1<=Inst_Inf_Pipe0.Imme;
    Data1_Pipe1<=Data1;
    Data2_Pipe1<=Data2;
    Commit_Window_Pipe1<=Commit_Window_Pipe0;
    Valid_Pipe1<=Inst_Inf_Pipe0.Valid;
    end

end

EX_Unit EX_Unit(
.Src1(Data1_Pipe1),
.Src2(Data2_Pipe1),
.Imme(Imme_Pipe1),
.PC(PC_Pipe1),
.Unit(Unit_Pipe1),
.Operation(OP_Pipe1),
.Result(EX_Result),
.Branch_To(Branch_To),
.Address(),
.Branch(Branch),
.WB_Stage(WB_Stage)
);

always_ff@(posedge System.Clk)begin
  if(System.Rst|Cntl.Flush)
    {Commit_Window_Pipe2,EX_Result_Pipe2,Phydst_Pipe2,WB_Stage_Pipe2,Branch_To_Pipe2,Branch_Pipe2}<='b0;
  else begin
    WB_Stage_Pipe2<=WB_Stage;
    EX_Result_Pipe2<=EX_Result;
	 Phydst_Pipe2<=Phydst_Pipe1;
	 Valid_Pipe2<=Valid_Pipe1;
	 Commit_Window_Pipe2<=Commit_Window_Pipe1;
	 Branch_To_Pipe2<=Branch_To;
	 Branch_Pipe2<=Branch;
	 end
end

assign Port1_Data= EX_Result_Pipe2;
assign Port1_Dst=Phydst_Pipe2;
assign Port1_We=WB_Stage_Pipe2[0];
Reorder_Buffer #(.Depth(Depth))Reorder_Buffer(
.System(System),
.Cntl(Cntl),
.In({Inst_FIFO_Top.Rdst,Inst_FIFO_Top.Phydst,Inst_FIFO_Top.PC}),
.We(Read_FIFO),

//Complete Window
.Port1({Commit_Window_Pipe2,WB_Stage_Pipe2[0]}),
.Port2(),
.May_Blanch_PC(Branch_To_Pipe2),
.May_Blanch(Branch_Pipe2),

//Commit
.Check_Commit(Check_Commit),
.Commit_Port(Commit),
.Commit_PC(Commit_PC),
.Commit_Branch_To_PC(Branch_To_PC),
.Commit_Branch(Commit_Branch),
.Full(Reorder_Buffer_Full) 
);

EX_Slot_Sysctrl EX_Slot_Sysctrl(
.Src1(Src1),
.Src2(Src2),
.FIFO_Empty(Empty),
.Wake_List(Wake_List),
.Reorder_Buffer_Full(Reorder_Buffer_Full),

.Stall_Pipe0(Stall_Pipe0),
.Flush_Pipe1(Flush_Pipe1),
.Read_FIFO(Read_FIFO)
);

endmodule



module EX_Slot_Sysctrl(
input [5:0]Src1,Src2,
input [0:63]Wake_List,
input FIFO_Empty,
input Reorder_Buffer_Full,

output Stall_Pipe0,
output Flush_Pipe1,
output Read_FIFO
);
logic Src1_Ready,Src2_Ready;

assign Src1_Ready=Wake_List[Src1];
assign Src2_Ready=Wake_List[Src2];

assign Stall_Pipe0=Flush_Pipe1;
assign Read_FIFO=(Src1_Ready&Src2_Ready)&(!FIFO_Empty)&(!Stall_Pipe0);
assign Flush_Pipe1=!(Src1_Ready&Src2_Ready)|Reorder_Buffer_Full;

endmodule
