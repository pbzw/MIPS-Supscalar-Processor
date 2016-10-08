//Release 2016.10.08
//File         : PE_Lib.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: Priority Encoder library 
//優先權編碼器原件庫
//version : 1.0
//
//      casex	 sel	mix
//     
//input/F
//    2	1001	1146	
//    4	 818	 816	821
//    8	 532	 628	520
//   16	 352	 338	514
//   32	 175	 292	339



module PE_2_X(
input [1:0]in,
output logic out,
output Valid
);

assign Valid=|in;

always_comb begin
 casex(in)
 2'b1x:out=1'b0;
 2'b01:out=1'd1;
 default:out<=1'b0;
 endcase
end

endmodule

module PE_4_X(
input [3:0]in,
output logic [1:0]out,
output Valid
);

assign Valid=|in;

always_comb begin
 casex(in)
 4'b1xxx:out=2'b0;
 4'b01xx:out=2'd1;
 4'b001x:out=2'd2;
 4'b0001:out=2'd3;
 default:out<=2'b0;
 endcase
end

endmodule

module PE_8_X(
input [7:0]in,
output logic [2:0]out,
output Valid
);

assign Valid=|in;

always_comb begin
 casex(in)
 8'b1xxx_xxxx:out=3'd0;
 8'b01xx_xxxx:out=3'd1;
 8'b001x_xxxx:out=3'd2;
 8'b0001_xxxx:out=3'd3;
 8'bxxxx_1xxx:out=3'd4;
 8'bxxxx_01xx:out=3'd5;
 8'bxxxx_001x:out=3'd6;
 8'bxxxx_0001:out=3'd7;
 default:out<=3'b0;
 endcase
end

endmodule

module PE_16_X(
input [15:0]in,
output logic [3:0]out,
output Valid
);

assign Valid=|in;

always_comb begin
 casex(in)
 16'b1xxx_xxxx_xxxx_xxxx:out=4'd0;
 16'b01xx_xxxx_xxxx_xxxx:out=4'd1;
 16'b001x_xxxx_xxxx_xxxx:out=4'd2;
 16'b0001_xxxx_xxxx_xxxx:out=4'd3;
 16'bxxxx_1xxx_xxxx_xxxx:out=4'd4;
 16'bxxxx_01xx_xxxx_xxxx:out=4'd5;
 16'bxxxx_001x_xxxx_xxxx:out=4'd6;
 16'bxxxx_0001_xxxx_xxxx:out=4'd7;
 16'b0000_1xxx_xxxx_xxxx:out=4'd8;
 16'b0000_01xx_xxxx_xxxx:out=4'd9;
 16'b0000_001x_xxxx_xxxx:out=4'd10;
 16'b0000_0001_xxxx_xxxx:out=4'd11;
 16'b0000_0000_1xxx_xxxx:out=4'd12;
 16'b0000_0000_01xx_xxxx:out=4'd13;
 16'b0000_0000_001x_xxxx:out=4'd14;
 16'b0000_0000_0001_xxxx:out=4'd15;

 default:out<=4'b0;
 endcase
end

endmodule



module PE_32_X (
input [31:0]in,
output reg[4:0]out,
output Valid
);

assign Valid=|in;

always@(*)begin
	casex(in)
	32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd00};
	32'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd01};
	32'b001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd02};
	32'b0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd03};
	32'b0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd04};
	32'b0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd05};
	32'b0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd06};
	32'b0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd07};
	32'b0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd08};
	32'b0000_0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd09};
	32'b0000_0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd10};
	32'b0000_0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx:out={5'd11};
	32'b0000_0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx:out={5'd12};
	32'b0000_0000_0000_01xx_xxxx_xxxx_xxxx_xxxx:out={5'd13};
	32'b0000_0000_0000_001x_xxxx_xxxx_xxxx_xxxx:out={5'd14};
	32'b0000_0000_0000_0001_xxxx_xxxx_xxxx_xxxx:out={5'd15};
	32'b0000_0000_0000_0000_1xxx_xxxx_xxxx_xxxx:out={5'd16};
	32'b0000_0000_0000_0000_01xx_xxxx_xxxx_xxxx:out={5'd17};
	32'b0000_0000_0000_0000_001x_xxxx_xxxx_xxxx:out={5'd18};
	32'b0000_0000_0000_0000_0001_xxxx_xxxx_xxxx:out={5'd19};
	32'b0000_0000_0000_0000_0000_1xxx_xxxx_xxxx:out={5'd20};
	32'b0000_0000_0000_0000_0000_01xx_xxxx_xxxx:out={5'd21};
	32'b0000_0000_0000_0000_0000_001x_xxxx_xxxx:out={5'd22};
	32'b0000_0000_0000_0000_0000_0001_xxxx_xxxx:out={5'd23};
	32'b0000_0000_0000_0000_0000_0000_1xxx_xxxx:out={5'd24};
	32'b0000_0000_0000_0000_0000_0000_01xx_xxxx:out={5'd25};
	32'b0000_0000_0000_0000_0000_0000_001x_xxxx:out={5'd26};
	32'b0000_0000_0000_0000_0000_0000_0001_xxxx:out={5'd27};
	32'b0000_0000_0000_0000_0000_0000_0000_1xxx:out={5'd28};
	32'b0000_0000_0000_0000_0000_0000_0000_01xx:out={5'd29};
	32'b0000_0000_0000_0000_0000_0000_0000_001x:out={5'd30};
	32'b0000_0000_0000_0000_0000_0000_0000_0001:out={5'd31};
	default:out={5'd00};
	endcase
end

endmodule

module PE_2(
input [1:0]in,
output logic out,
output Valid
);

assign Valid=|in;
assign out =!in[1];

endmodule

module PE_4(
input [3:0]in,
output logic [1:0]out,
output Valid
);

logic temp[2];
assign Valid=|in;

PE_2 PE0(
.in(in[3:2]),
.out(temp[0]),
.Valid()
);

PE_2 PE1(
.in(in[1:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[3:2]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule

module PE_4_MIX(
input [3:0]in,
output logic [1:0]out,
output Valid
);

logic temp[2];
assign Valid=|in;

PE_2 PE0(
.in(in[3:2]),
.out(temp[0]),
.Valid()
);

PE_2 PE1(
.in(in[1:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[3:2]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule

module PE_8(
input [7:0]in,
output logic [2:0]out,
output Valid
);

logic [1:0]temp[2];
assign Valid=|in;

PE_4 PE0(
.in(in[7:4]),
.out(temp[0]),
.Valid()
);

PE_4 PE1(
.in(in[3:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[7:4]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule

module PE_8_MIX(
input [7:0]in,
output logic [2:0]out,
output Valid
);

logic [1:0]temp[2];
assign Valid=|in;

PE_4_X PE0(
.in(in[7:4]),
.out(temp[0]),
.Valid()
);

PE_4_X PE1(
.in(in[3:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[7:4]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule

module PE_16(
input [15:0]in,
output logic [3:0]out,
output Valid
);

logic [2:0]temp[2];
assign Valid=|in;

PE_8 PE0(
.in(in[15:8]),
.out(temp[0]),
.Valid()
);

PE_8 PE1(
.in(in[7:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[15:8]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule
module PE_16_MIX(
input [15:0]in,
output logic [3:0]out,
output Valid
);

logic [2:0]temp[2];
assign Valid=|in;

PE_8_X PE0(
.in(in[15:8]),
.out(temp[0]),
.Valid()
);

PE_8_X PE1(
.in(in[7:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[15:8]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule
module PE_32(
input [31:0]in,
output logic [4:0]out,
output Valid
);

logic [3:0]temp[2];
assign Valid=|in;

PE_16 PE0(
.in(in[31:16]),
.out(temp[0]),
.Valid()
);

PE_16 PE1(
.in(in[15:0]),
.out(temp[1]),
.Valid()
);

assign out=|in[31:16]?{1'b0,temp[0]}:{1'b1,temp[1]};

endmodule

module PE_32_MIX(
input [31:0]in,
output logic [4:0]out,
output Valid
);

logic [2:0]temp[4];
logic [1:0]select;
assign Valid=|in;

PE_8_X PE_0(
.in(in[31:24]),
.out(temp[0]),
.Valid()
);

PE_8_X PE1(
.in(in[23:16]),
.out(temp[1]),
.Valid()
);

PE_8_X PE2(
.in(in[15:8]),
.out(temp[2]),
.Valid()
);

PE_8_X PE3(
.in(in[7:0]),
.out(temp[3]),
.Valid()
);

PE_4_MIX PE4(
.in({|in[31:24],|in[23:16],|in[15:8],|in[7:0]}),
.out(select),
.Valid()
);

always_comb begin
 case(select)
 2'b00:out={2'b00,temp[0]};
 2'b01:out={2'b01,temp[1]};
 2'b10:out={2'b10,temp[2]};
 2'b11:out={2'b11,temp[3]};
 endcase
end

endmodule
