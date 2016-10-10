//Release 2016.10.08
//File         : IF_ID.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : IF/ID Stage Pipeline  
//version : 1.0
//



import System_Pkg::*;

module IF_ID(
input Global System,
input Local Cntl,
input IF_ID_Port In,
output IF_ID_Port Out
);

always_ff@(posedge System.Clk)begin
 if(System.Rst|Cntl.Flush)
  Out<='b0;
 else if(!Cntl.Stall)
  Out<=In;
end

endmodule
