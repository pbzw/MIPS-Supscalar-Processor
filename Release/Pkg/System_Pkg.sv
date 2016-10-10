//Release 2016.10.10
//File         : System_Pkg.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: System Wire Pakege
//version : 1.0
//
import Processor_Pkg::*;

package System_Pkg;

//Global System Signal
typedef struct packed{
logic Clk,Rst;
}Global;
//Local Control Signal
typedef struct packed{
logic Flush,Stall;
}Local;
//Mem_Req
typedef struct packed{
logic [31:0]Address;
logic Req;
}Mem_Req;

//Mem_Respond
typedef struct packed{
logic [31:0]Data;
logic Ready;
}Mem_Respond;

//IF_ID_Port
typedef struct packed{
Mem_Respond Inst1,Inst2;
logic [31:0] PC;
}IF_ID_Port;


//Pre-Rename Instruction Source
typedef struct packed{
logic [4:0]Src1,Src2,Rdst;
}Source;

//Control Decode
typedef struct packed{
logic[8:0] ALUop;
logic RegW;
Source Pre_Rename;
logic [31:0]Extend_imm;
}Control_Decode;


//ID/RN_Port
typedef struct packed{
Control_Decode Inst1;
logic Inst1_en;
Control_Decode Inst2;
logic Inst2_en;
logic [31:0]PC;
}ID_RN_Port;
//Post_Rename
typedef struct packed{
logic [5:0]Src1,Src2,Phydst;
}Post_Rename;

typedef struct packed{
Control_Decode Inst1_Cont;
logic Inst1_en;
Post_Rename Inst1_Post_Rename;
Control_Decode Inst2_Cont;
logic Inst2_en;
Post_Rename Inst2_Post_Rename;
logic [31:0]PC;
}RN_IB_Port;

typedef struct packed{
logic[5:0] Phydst;
logic Wake;
}Wake_Up_port;

//Commit_Target
typedef struct packed{
logic [4:0]Rdst;
logic [5:0]Phydst;
logic Commit;
}Commit_Target;

typedef struct packed{
logic [4:0]Rdst;
logic [3:0] Unit;
logic [4:0]OP;
logic [5:0]Src1;
logic [5:0]Src2;
logic [5:0] Phydst;
logic [31:0]PC;
logic [31:0]Imme;
logic Valid;
}Inst_FIFO_Slot;

typedef struct packed{
logic [4:0 ]Rdst;
logic [5:0 ]Phydst;
logic [31:0]PC;
}Reorder_Buffer_Slot;

typedef struct packed{
logic [2:0]Window;
logic Commit;
}Window_Commit;



endpackage
