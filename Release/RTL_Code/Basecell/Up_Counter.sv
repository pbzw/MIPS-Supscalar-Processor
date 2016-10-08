//Release 2016.10.08
//File         : Up_Counter.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: 
//version : 1.0
//
import System_Pkg::*;

module Up_Counter #(parameter WIDTH = 32)(
input Global System,
input Clr,
input En,
output reg[WIDTH-1:0] Count
);

always@(posedge System.Clk)begin
  if(System.Rst|Clr)
    Count<='b0;
  else if(En)
    Count<=Count+'b1;
end

endmodule
