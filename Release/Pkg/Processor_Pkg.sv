//Release 2016.10.08
//File         : Processor_pkg.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: About Instruction information for test
//version : 1.0
//
package Processor_Pkg;

typedef struct packed{
logic [31:0]Address;
logic Req;
}Mem_Req;

typedef struct packed{
logic [31:0]Data;
logic Ready;
}Mem_Respond;

endpackage
