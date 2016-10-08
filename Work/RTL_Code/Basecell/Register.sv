//Release 2016.10.08
//File         : Register.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: 
//version : 1.0
//

import System_Pkg::*;

module Register #(parameter WIDTH = 32,reset=16'h3000)(
input Global System,
input En,
input[WIDTH-1:0] In,
output reg[WIDTH-1:0] Out
);

always_ff@(posedge System.Clk) begin
  if(System.Rst)
    Out<=reset;
  else if(En)
    Out<=In;
end

endmodule
