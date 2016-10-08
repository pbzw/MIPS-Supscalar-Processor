//Release 2016.10.08
//File         : System_Pkg.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: System Wire Pakege
//version : 1.0
//

package System_Pkg;

//Global System Signal
typedef struct packed{
logic Clk,Rst;
}Global;
//Local Control Signal
typedef struct packed{
logic Flush,Stall;
}Local;
//Pre-Rename Instruction Source
typedef struct packed{
logic [4:0]Src1,Src2,Rdst;
}Source;


endpackage
