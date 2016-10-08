//Release 2016.10.08
//File         : Control.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : Instruction Decode
//version : 1.0
//

`include "../../Define/MIPS_Parameter.sv"

import System_Pkg::*;
module Control(
input Mem_Respond Inst,
output Control_Decode out
);
wire [31:0]Sign_imm;
wire [5:0] OpCode = Inst.Data[31:26];

wire [5:0] Funct = Inst.Data[5:0];
wire [15:0]Immediate = Inst.Data[15:0];
wire [4:0] Rs =Inst.Data[25:21];
wire [4:0] Rt =Inst.Data[20:16];

wire SignExtend = (OpCode[5:2] != 4'b0011);
wire Dstselect,Itype;
wire Link;
wire J_Extend;
wire B_inst;
wire Jalr;
wire [4:0] Rd = Inst.Data[15:11];

reg  [7:0]DataPath;

assign out.Extend_imm=J_Extend? {6'd0,Inst.Data[25:0]}:Sign_imm;
assign Sign_imm=SignExtend?{{16{Immediate[15]}},Immediate}:{16'h0000,Immediate};
assign out.Pre_Rename.Src1=Rs;
assign out.Pre_Rename.Src2=Link?5'd31:Itype?5'd0:Rt;
assign out.Pre_Rename.Rdst=Link?5'd31:B_inst?5'd0:Dstselect?Rd:Rt;

always_comb begin
  case(OpCode)
    `Op_Ori :out.ALUop<={`ALU,`AluOp_Ori };
    `Op_Andi:out.ALUop<={`ALU,`AluOp_Andi};
    `Op_Addi:out.ALUop<={`ALU,`AluOp_Addi};
    `Op_Xori:out.ALUop<={`ALU,`AluOp_Xori};
    `Op_Lui :out.ALUop<={`ALU,`AluOp_Lui };
    `Op_J   :out.ALUop<={`BU ,`BUOp_J    };
    `Op_Jal :out.ALUop<={`BU ,`BUOp_Jal  };
    `Op_Beq :out.ALUop<={`BU ,`BUOp_Beq  };
    `Op_Bgtz:out.ALUop<={`BU ,`BUOp_Bgtz };
    `Op_Blez:out.ALUop<={`BU ,`BUOp_Blez };
    `Op_Bne :out.ALUop<={`BU ,`BUOp_Bne  };
    `Op_Lb  :out.ALUop<={`DUL,`DUOp_Lb   };
    `Op_Lbu :out.ALUop<={`DUL,`DUOp_Lbu  };
    `Op_Lh  :out.ALUop<={`DUL,`DUOp_Lh   };
    `Op_Lhu :out.ALUop<={`DUL,`DUOp_Lhu  };
    `Op_Lw  :out.ALUop<={`DUL,`DUOp_Lw   };
    `Op_Sb  :out.ALUop<={`DUS,`DUOp_Sb   };
    `Op_Sh  :out.ALUop<={`DUS,`DUOp_Sh   };
    `Op_Sw  :out.ALUop<={`DUS,`DUOp_Sw   };
    `Op_Type_Regimm:begin
      case(Rt)
        `OpRt_Bltz  :out.ALUop<={`BU,`BUOp_Bltz  };
        `OpRt_Bltzal:out.ALUop<={`BU,`BUOp_Bltzal};
        `OpRt_Bgez  :out.ALUop<={`BU,`BUOp_Bgez  };
        `OpRt_Bgezal:out.ALUop<={`BU,`BUOp_Bgezal};
        default     :out.ALUop<=9'd0;
      endcase end
    `Op_Type_R:begin
      case (Funct)
        `Funct_Add     : out.ALUop<={`ALU,`AluOp_Add};
        `Funct_Addu    : out.ALUop<={`ALU,`AluOp_Add};
        `Funct_Sub     : out.ALUop<={`ALU,`AluOp_Sub};
        `Funct_Nor     : out.ALUop<={`ALU,`AluOp_Nor};
        `Funct_Or      : out.ALUop<={`ALU,`AluOp_Or };
        `Funct_And     : out.ALUop<={`ALU,`AluOp_And};
        `Funct_Xor     : out.ALUop<={`ALU,`AluOp_Xor};
        `Funct_Jr      : out.ALUop<={`BU ,`BUOp_Jr  };
        `Funct_Jalr    : out.ALUop<={`BU ,`BUOp_Jalr};
        `Funct_Sll     : out.ALUop<={`ALU,`AluOp_Sll};
        `Funct_Srl     : out.ALUop<={`ALU,`AluOp_Srl};
        default        : out.ALUop<=9'd0;
      endcase end
    default:out.ALUop<=9'd0;
  endcase
end

/*Dstselect_RegW*/
assign Jalr     =DataPath[7];
assign B_inst   =DataPath[6];
assign J_Extend =DataPath[5];
assign Link     =DataPath[4];
//assign Instvalid=DataPath[3]&inst_en;
assign Itype    =DataPath[2];
assign Dstselect=DataPath[1];
assign out.RegW =DataPath[0];

always_comb begin
  case(OpCode)
    `Op_Ori :DataPath<=`Dp_Ori;
    `Op_Andi:DataPath<=`Dp_Andi;
    `Op_Addi:DataPath<=`Dp_Addi;
    `Op_Xori:DataPath<=`Dp_Xori;
    `Op_Lui :DataPath<=`Dp_Lui;
    `Op_J   :DataPath<=`Dp_J;
    `Op_Jal :DataPath<=`Dp_Jal;
    `Op_Beq :DataPath<=`Dp_Beq;
    `Op_Bgtz:DataPath<=`Dp_Bgtz;
    `Op_Blez:DataPath<=`Dp_Blez;
    `Op_Bne :DataPath<=`Dp_Bne;
    `Op_Lb  :DataPath<=`Dp_Lb ;
    `Op_Lbu :DataPath<=`Dp_Lbu;
    `Op_Lh  :DataPath<=`Dp_Lh ;
    `Op_Lhu :DataPath<=`Dp_Lhu ;
    `Op_Lw  :DataPath<=`Dp_Lw ;
    `Op_Sb  :DataPath<=`Dp_Sb ;
    `Op_Sh  :DataPath<=`Dp_Sh ;
    `Op_Sw  :DataPath<=`Dp_Sw ;
    `Op_Type_Regimm:begin
      case(Rt)
        `OpRt_Bltz  :DataPath<=`Dp_Bltz;
        `OpRt_Bltzal:DataPath<=`Dp_Bltzal;
        `OpRt_Bgez  :DataPath<=`Dp_Bgez;
        `OpRt_Bgezal:DataPath<=`Dp_Bgezal;
        default     : DataPath<=6'd0;
      endcase end
    `Op_Type_R  :begin
      case (Funct)
        `Funct_Add     : DataPath<=`Dp_Add;
        `Funct_Addu    : DataPath<=`Dp_Add;
        `Funct_Sub     : DataPath<=`Dp_Sub;
        `Funct_Nor     : DataPath<=`Dp_Nor;
        `Funct_Or      : DataPath<=`Dp_Or;
        `Funct_And     : DataPath<=`Dp_And;
        `Funct_Xor     : DataPath<=`Dp_Xor;
        `Funct_Jr      : DataPath<=`Dp_Jr;
        `Funct_Jalr    : DataPath<=`Dp_Jalr;
        `Funct_Sll     : DataPath<=`Dp_Sll ;
        `Funct_Srl     : DataPath<=`Dp_Srl;
        default : DataPath<=6'd0;
      endcase end
    default:DataPath<=6'b000000;
  endcase
end

endmodule
