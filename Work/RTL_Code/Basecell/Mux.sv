//Release 2016.10.08
//File         : Muxer.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: 多工器
//version : 1.0
//

module Muxer #(In_Port=8,WIDTH=32)(
input [$clog2(In_Port)-1:0]sel,
input[(WIDTH-1):0]in[In_Port],
output[(WIDTH-1):0]out
);

assign out = in[sel];

endmodule

