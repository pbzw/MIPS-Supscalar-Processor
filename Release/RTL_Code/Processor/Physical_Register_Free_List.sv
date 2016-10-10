//Release 2016.10.08
//File         : Physical_Register_Free_List.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 2 Free List
//version : 1.0
//

module Physical_Register_Free_List (
input [0:63]in,//can_Use_Phy
input Take1,Take2,
output [5:0]Take_Phy1,Take_Phy2,
output Stall
);
logic [4:0]LPE_out[2];
logic [0:31]List[2];

wire List1OK=|List[0];
wire List2OK=|List[1];


assign Stall=!(List1OK&List2OK);

assign List[0]={1'b0,in[02],in[04],in[06],in[08],
            in[10],in[12],in[14],in[16],in[18],
				in[20],in[22],in[24],in[26],in[28],
				in[30],in[32],in[34],in[36],in[38],
				in[40],in[42],in[44],in[46],in[48],
				in[50],in[52],in[54],in[56],in[58],
				in[60],in[62]};
assign List[1]={
				in[01],in[03],in[05],in[07],in[09],
            in[11],in[13],in[15],in[17],in[19],
				in[21],in[23],in[25],in[27],in[29],
				in[31],in[33],in[35],in[37],in[39],
				in[41],in[43],in[45],in[47],in[49],
				in[51],in[53],in[55],in[57],in[59],
				in[61],in[63]};
				
assign Take_Phy1=Take1?{LPE_out[0],1'b0}:6'd0;
assign Take_Phy2=Take2?{LPE_out[1],1'b1}:6'd0;

PE_32_MIX List1_LPE(
.in(List[0]),
.out(LPE_out[0])
);

PE_32_MIX List2_LPE(
.in(List[1]),
.out(LPE_out[1])
);

endmodule


