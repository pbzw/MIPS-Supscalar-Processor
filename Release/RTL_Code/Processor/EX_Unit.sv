//Release 2016.10.10
//File         : EX_Unit.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0



`ifdef vcs
`include "../Define/MIPS_Parameter.sv"
`else
`include "../../Define/MIPS_Parameter.sv"
`endif

module EX_Unit(
input signed[31:0] Src1,Src2,
input [31:0]Imme,PC,
input[3:0] Unit,
input[4:0]  Operation,
output logic [31:0] Result,Branch_To,Address,
output logic Branch,
output logic [1:0]WB_Stage
);

logic [31:0]PC_plus_4;
assign PC_plus_4=PC+32'd4;

always_comb begin
	case(Unit)
	`ALU:begin
		case (Operation)
			`AluOp_Ori  : Result <= Src1|Imme;
			`AluOp_Or   : Result <= Src1|Src2;
			`AluOp_Nor  : Result <= ~(Src1|Src2);
			`AluOp_Andi : Result <= Src1&Imme;
			`AluOp_And  : Result <= Src1&Src2;
			`AluOp_Addi : Result <= Src1+Imme;
			`AluOp_Xori : Result <= Src1^Imme;
			`AluOp_Xor  : Result <= Src1^Src2;
			`AluOp_Add  : Result <= Src1+Src2;
			`AluOp_Sub  : Result <= Src1-Src2;
			`AluOp_Lui  : Result <= {Imme[15:0],16'b0};
			`AluOp_Sll  : Result <= Src1<<Imme[10:6];
			`AluOp_Srl  : Result <= Src1>>Imme[10:6];
			default     : Result <= 32'd0;
		endcase end
	`BU :begin
		case (Operation)
		   `BUOp_Jal   : Result <= PC+32'd8;
			`BUOp_Jalr  : Result <= PC+32'd8;
			`BUOp_Bgezal: Result <= (Src1>=32'd0)?PC+32'd8:Src2;
			`BUOp_Bltzal: Result <= (Src1 <32'd0)?PC+32'd8:Src2;
			default     : Result <= 32'd0;
		endcase end
	default     : Result <= 32'd0;
	endcase
	
end

//WB_Stage
//{Store_Buffer,ALU_Port,BU_Port,LU_Port}
//
always_comb begin
	case(Unit)
	`ALU        : WB_Stage <= 2'b01;
	`BU         : WB_Stage <= 2'b01;
	default     : WB_Stage <= 2'b00;
	endcase
	
end

always_comb begin
	case(Unit)
	`BU :case(Operation)
		  `BUOp_J     :Branch_To <= {PC_plus_4[31:28],Imme[25:0],2'b0};
		  `BUOp_Jal   :Branch_To <= {PC_plus_4[31:28],Imme[25:0],2'b0};
		  `BUOp_Jalr  :Branch_To <=  Src1;
		  `BUOp_Jr    :Branch_To <=  Src1;
		  `BUOp_Beq   :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bgtz  :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bgez  :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bgezal:Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0}; 
		  `BUOp_Blez  :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bne   :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bltz  :Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  `BUOp_Bltzal:Branch_To <= (PC_plus_4)+{Imme[29:0],2'b0};
		  default     :Branch_To <= 'b0000;
		  endcase 
	default     : Branch_To <= 'b0000;
	endcase
end

always_comb begin
	case(Unit)
	`BU :case(Operation)
		  `BUOp_J     :Branch <= 1'b1;
		  `BUOp_Jal   :Branch <= 1'b1;
		  `BUOp_Jalr  :Branch <= 1'b1;
		  `BUOp_Jr    :Branch <= 1'b1;
		  `BUOp_Beq   :Branch <= (Src1 == Src2);
		  `BUOp_Bgtz  :Branch <= (Src1  >32'd0);
		  `BUOp_Bgez  :Branch <= (Src1 >=32'd0);
		  `BUOp_Bgezal:Branch <= (Src1 >=32'd0);
		  `BUOp_Blez  :Branch <= (Src1 <=32'd0);
		  `BUOp_Bne   :Branch <= (Src1 != Src2);
		  `BUOp_Bltz  :Branch <= (Src1  <32'd0);
		  `BUOp_Bltzal:Branch <= (Src1  <32'd0);
		  default     :Branch <= 'b0;
		  endcase 
	default     : Branch <= 'b0;
	endcase
end
endmodule
