//Release 2016.10.08
//File         : Adder.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: 加法器
//version : 1.0
//

module Adder #(WIDTH=32)(
input  [WIDTH-1:0]A,B,
output logic [WIDTH-1:0]C
);

assign C = (A + B);

endmodule

