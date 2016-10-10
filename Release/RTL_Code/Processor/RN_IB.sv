//Release 2016.10.10
//File         : RN_IB.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0
//
import System_Pkg::*;

module RN_IB(
input Global System,
input Local Cntl,
input RN_IB_Port In,
output RN_IB_Port Out
);

always_ff@(posedge System.Clk)begin
 if(System.Rst|Cntl.Flush)
  Out<='b0;
 else if(!Cntl.Stall)
  Out<=In;
end



endmodule
