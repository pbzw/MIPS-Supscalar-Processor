import Instruction_Pkg::*;

class random_data;
 rand opcode_t opcode;
 rand logic [4:0]  rs;
 rand logic [4:0]  rd;
 rand logic [4:0]  rt;
 rand logic [15:0]  imme;
 
 rand Rt_funct_t   fun_rt; 
 rand funct_t  FUNCT;
 constraint limit { 
opcode dist{ 
R_Type:/200,
Ori   :/25,
Addi  :/25,
Andi  :/25,
Xori  :/25/*,
Regimm:/1,
Beq   :/1,
Bgtz  :/1,
Blez  :/1,
Bne   :/1,
J     :/1,
Jal   :/1*/
};

FUNCT dist {
Add     :/25,
Addu    :/25,
And     :/25,
//Jr      :/5,
//Jalr    :/5,
Nor     :/25,
Or      :/25,
//Sll     :/25,
//Sllv    :/25,
//Slt     :/25,
//Sltu    :/25,
//Sra     :/25,
//Srav    :/25,
//Srl     :/25,
//Srlv    :/25,
Sub     :/25,
Xor     :/25
};

}
endclass




function Gen_Inst(output integer Inst,output Branch);
 logic[31:0]Inst;
 logic[5:0] opcode;
 logic[5:0] fun;
 logic[4:0] rt,rs,rd;
 logic[15:0]imme;
 //randomize
random_data pattern;

 pattern=new();
 pattern.randomize();
 opcode=pattern.opcode;
 fun=pattern.FUNCT;
 rt =pattern.rt;
 rs =pattern.rs;
 rd =pattern.rd;
 imme=pattern.imme;

 case(opcode)
 R_Type :begin Inst={opcode,rs,rt,rd,5'b0,fun};Branch=0; end
 Regimm :begin Inst={opcode,rs,pattern.fun_rt,rd,5'b0,fun};Branch=0; end
 Beq    :begin Inst={opcode,rs,rt,imme};Branch=1; end
 Bgtz   :begin Inst={opcode,rs,rt,imme};Branch=1; end
 Blez   :begin Inst={opcode,rs,rt,imme};Branch=1; end
 default:begin Inst={opcode,rs,rt,imme};Branch=0; end

 endcase


endfunction
