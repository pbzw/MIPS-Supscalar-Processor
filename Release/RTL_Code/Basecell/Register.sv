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

always_ff@(posedge system.clk) begin
  if(system.rst)
    Out<=reset;
  else if(en)
    Out<=in;
end

endmodule
