//-------------------------------------------------------
// SystemVerilog Course Labs
// Lab7 - Random Test and Functional Coverage
// Description: Testbench
// File Name  : test.sv
//-------------------------------------------------------
import Instruction_Pkg::*;

program automatic test(Processor_inf.tester tester);
//Pattern FIFO
reg [31:0] VM_Inst_FIFO[$];
integer VM_Reg[32],RM_Reg[32],EXE_Count=0;
logic [31:0]VM_PC=0;

integer fp_w= $fopen("ERROR_Message.txt", "w");

task reset();
integer i;
 for(i=0;i<64;i++)
    top.dut.Regfile.file[i]='d0;
 
 for(i=0;i<32;i++)begin
  VM_Reg[i]=0;
  RM_Reg[i]=0;end
tester.rst<=1'b0;
tester.Inst1_Resp.Data <= 'b0;
tester.Inst2_Resp.Data <= 'b0;
tester.Inst1_Resp.Ready = 1'b0;	
tester.Inst2_Resp.Ready = 1'b0;
$display("%t:--------------------------",$time);
$display("%t:Start Reset ...",$time);
#10 tester.rst<=1'b1;
$display("%t:Reset Finish...",$time);
#10 tester.rst<=1'b0;
$display("%t:--------------------------",$time);
endtask

task InstMem_Drive(bit Inst1_req);
        logic Branch;
	integer Inst;	

@(posedge tester.clk)begin
	if (Inst1_req)begin
	 tester.Inst1_Resp.Ready = 1'b1;	
	 tester.Inst2_Resp.Ready = 1'b1;
	
	Gen_Inst(Inst,Branch);
	 VM_Inst_FIFO.push_back(Inst);
	 $display("%t Gen %x",$time,Inst);
	tester.Inst1_Resp.Data=Inst;

	if(Branch) begin
	 VM_Inst_FIFO.push_back(32'd0);
         $display("%t Gen %x",$time,32'd0);
	 tester.Inst2_Resp.Data=32'd0;
	 return; end
	Gen_Inst(Inst,Branch);
	while (Branch)Gen_Inst(Inst,Branch);
	VM_Inst_FIFO.push_back(Inst); 
	tester.Inst2_Resp.Data=Inst;
	$display("%t Gen %x",$time,Inst);
	end
end
	
endtask

class Inst_format;
 opcode_t opcode;
 logic [4:0]  rs;
 logic [4:0]  rt; 
 logic [4:0]  rd;
 logic [15:0]  imme;
 funct_t  FUNCT;
 Rt_funct_t rt_fun;
 logic Branch;
endclass


// Define coverage group here
   
covergroup OPCODE_C;
 KIND:coverpoint exe.opcode;
endgroup
   
covergroup FUNCT_C;
 KIND:coverpoint exe.FUNCT;
endgroup

covergroup Regimm_C;
 KIND:coverpoint exe.rt_fun;
endgroup
   
covergroup imme_C;
 KIND:coverpoint exe.imme;
endgroup

covergroup Branch_C;
 KIND:coverpoint exe.Branch;
endgroup

// create and construct objects here
OPCODE_C  exe_OPCODE_C=new();
FUNCT_C   exe_FUNCT_C=new();
Regimm_C exe_Regimm_C=new();
imme_C exe_imme_C=new();
Branch_C exe_Branch_C=new();
Inst_format exe =new();

task Execute_Inst(input logic[31:0] Inst,input integer PC,output logic Branch,output integer New_PC);

logic [31:0]SE,NSE,PC_plus_4;
$display("%t:--------------------------",$time);
$display("%t:Execute Inst %x",$time,Inst);
exe.opcode=Inst[31:26];
exe.FUNCT=Inst[5:0];
exe.rs =Inst[25:21];
exe.rt =Inst[20:16];
exe.rd=Inst[15:11];
exe.imme=Inst[15:0];
exe.rt_fun=exe.rt;
SE ={{16{Inst[15]}},Inst[15:0]};
NSE={16'b0,Inst[15:0]};

$display("%t:Excute OPCODE %s ",$time,exe.opcode);
case(exe.opcode) 
 Xori   :begin
  $display("%t:Excute OPCODE %s Rs=%2d Rt =%2d",$time,exe.opcode,exe.rs,exe.rt);
  $display("%t:VM_Reg[%2d]= %x Imme=%x ",$time,exe.rs,VM_Reg[exe.rs],NSE);
  $display("%t:VM_Reg[%2d]^Imme = %x ",$time,exe.rs,VM_Reg[exe.rs]^NSE);	
  VM_Reg[exe.rt]=VM_Reg[exe.rs]^NSE;
  exe_imme_C.sample();
  end
 Ori   :begin
  $display("%t:Excute OPCODE %s Rs=%2d Rt =%2d",$time,exe.opcode,exe.rs,exe.rt);
  $display("%t:VM_Reg[%2d]= %x Imme=%x ",$time,exe.rs,VM_Reg[exe.rs],NSE);
  $display("%t:VM_Reg[%2d]|Imme = %x ",$time,exe.rs,VM_Reg[exe.rs]|NSE);	
  VM_Reg[exe.rt]=VM_Reg[exe.rs]|NSE;
  exe_imme_C.sample();
  end
 Andi   :begin
  $display("%t:Excute OPCODE %s Rs=%2d Rt =%2d",$time,exe.opcode,exe.rs,exe.rt);
  $display("%t:VM_Reg[%2d]= %x Imme=%x ",$time,exe.rs,VM_Reg[exe.rs],NSE);
  $display("%t:VM_Reg[%2d]&Imme = %x ",$time,exe.rs,VM_Reg[exe.rs]&NSE);	
  VM_Reg[exe.rt]=VM_Reg[exe.rs]&NSE;
  exe_imme_C.sample();
  end
 Addi   :begin
  $display("%t:Excute OPCODE %s Rs=%2d Rt =%2d",$time,exe.opcode,exe.rs,exe.rt);
  $display("%t:VM_Reg[%2d]= %x Imme=%x ",$time,exe.rs,VM_Reg[exe.rs],SE);
  $display("%t:VM_Reg[%2d]+Imme = %x ",$time,exe.rs,VM_Reg[exe.rs]+SE);	
  VM_Reg[exe.rt]=VM_Reg[exe.rs]+SE;
  exe_imme_C.sample();
  end
 R_Type:begin 
  $display("%t:Function %s Rd=%2d Rs=%2d Rt =%2d",$time,exe.FUNCT,exe.rd,exe.rs,exe.rt);
  $display("%t:VM_Reg[%2d]= %x VM_Reg[%2d]= %x ",$time,exe.rs,VM_Reg[exe.rs],exe.rt,VM_Reg[exe.rt]);
  //$display("%t:RM_Reg[%2d]= %x RM_Reg[%2d]= %x ",$time,exe.rs,RM_Reg[exe.rs],exe.rt,RM_Reg[exe.rt]);
  case(exe.FUNCT)
   Add :VM_Reg[exe.rd]=VM_Reg[exe.rs]+VM_Reg[exe.rt];
   Addu:VM_Reg[exe.rd]=VM_Reg[exe.rs]+VM_Reg[exe.rt];
   Sub :VM_Reg[exe.rd]=VM_Reg[exe.rs]-VM_Reg[exe.rt];
   And :VM_Reg[exe.rd]=VM_Reg[exe.rs]&VM_Reg[exe.rt];
   Or  :VM_Reg[exe.rd]=VM_Reg[exe.rs]|VM_Reg[exe.rt];
   Nor :VM_Reg[exe.rd]=~(VM_Reg[exe.rs]|VM_Reg[exe.rt]);
   Xor :VM_Reg[exe.rd]=VM_Reg[exe.rs]^VM_Reg[exe.rt];
   endcase
  exe_FUNCT_C.sample();end
  endcase


PC_plus_4=PC+4;


 exe_OPCODE_C.sample();	
  case(exe.opcode)
   J:begin 
	New_PC={PC_plus_4[31:28],Inst[25:0],2'b0};
	Branch=1;
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   Jal:begin 
	New_PC={PC_plus_4[31:28],Inst[25:0],2'b0};
	Branch=1;
	VM_Reg[31]=PC+8;
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   Beq:begin 
	New_PC=(VM_Reg[exe.rs]==VM_Reg[exe.rt])?((PC+4)+{SE[29:0],2'b0}):PC+4;
	Branch=(VM_Reg[exe.rs]==VM_Reg[exe.rt]);
	$display("%t:VM_Reg[%2d]= %x VM_Reg[%2d]= %x ",$time,exe.rs,VM_Reg[exe.rs],exe.rt,VM_Reg[exe.rt]);
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   Bgtz:begin 
	New_PC=(VM_Reg[exe.rs]>32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
	Branch=(VM_Reg[exe.rs]>32'd0);
	$display("%t:VM_Reg[%2d]= %x  ",$time,exe.rs,VM_Reg[exe.rs]);
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   Blez:begin 
	New_PC=(VM_Reg[exe.rs]<=32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
	Branch=(VM_Reg[exe.rs]<=32'd0);
	$display("%t:VM_Reg[%2d]= %x  ",$time,exe.rs,VM_Reg[exe.rs]);
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   Bne:begin 
	New_PC=(VM_Reg[exe.rs]!=VM_Reg[exe.rt])?((PC+4)+{SE[29:0],2'b0}):PC+4;
	Branch=(VM_Reg[exe.rs]!=VM_Reg[exe.rt]);
	$display("%t:VM_Reg[%2d]= %x VM_Reg[%2d]= %x ",$time,exe.rs,VM_Reg[exe.rs],exe.rt,VM_Reg[exe.rt]);
	exe.Branch=Branch;exe_Branch_C.sample();
	end
   R_Type:begin $display("%t:Function %s ",$time,exe.FUNCT);
  	case(exe.FUNCT)
   	Jr      :begin
		New_PC=VM_Reg[exe.rs];
		Branch=1;
	    	end
   	Jalr    :begin
		New_PC=VM_Reg[exe.rs];
		VM_Reg[exe.rd]=PC+8;
		Branch=1;
	    	end
	default:begin New_PC=PC+4 ;Branch=0;end
   	endcase exe.Branch=Branch;exe_Branch_C.sample();end
   Regimm:begin 
	$display("%t:Excute OPCODE %s Function %s ",$time,exe.opcode,exe.rt_fun);
	$display("%t:VM_Reg[%2d]= %x  ",$time,exe.rs,VM_Reg[exe.rs]);
	case(exe.rt)
	Bltz  :begin 
		New_PC=(VM_Reg[exe.rs]<32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
		Branch=(VM_Reg[exe.rs]<32'd0);
		end
	Bltzal:begin 
		New_PC=(VM_Reg[exe.rs]<32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
		Branch=(VM_Reg[exe.rs]<32'd0);
		if(Branch)VM_Reg[31]=PC+8;
		end
	Bgez  :begin 
		New_PC=(VM_Reg[exe.rs]>=32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
		Branch=(VM_Reg[exe.rs]>=32'd0);
		end
	Bgezal:begin 
		New_PC=(VM_Reg[exe.rs]>=32'd0)?((PC+4)+{SE[29:0],2'b0}):PC+4;
		Branch=(VM_Reg[exe.rs]>=32'd0);
		if(Branch)VM_Reg[31]=PC+8;
		end
	endcase 
	exe.Branch=Branch;
	exe_Branch_C.sample();
	exe_Regimm_C.sample();end
   default:begin 
	New_PC=PC+4 ;Branch=0;
	end
  endcase
 VM_Reg[0]=32'b0;
  $display("%t:Execute Inst PC =%x Branch Occur %d to %x",$time,PC,Branch,New_PC);

endtask



task check_PC();
$display("%t:--------------------------",$time);
$display("%t:Start Check PC ",$time);
 if(VM_PC!==top.dut.Commit_PC)begin
   
   $display("%t:VM PC =%x  Commit RM PC =%x PC Value ERRO",$time,VM_PC,top.dut.Commit_PC);
   $display("%t:Excute Inst %d ,PC= %x",$time,EXE_Count,VM_PC);
   #10 $finish;
   end
 else
   $display("%t:PC_Correct PC =%x",$time,VM_PC);
endtask

task Check();
 integer i,erro=0;
 $display("%t:--------------------------",$time);
 $display("%t Start Check Regfile Value",$time);
 for(i=1; i<32;i++)begin
  if(VM_Reg[i]!==RM_Reg[i])begin
   $display("%t:VM Reg [%2d]=%x  RM Reg[%2d]=%x Value ERRO",$time,i,VM_Reg[i],i,RM_Reg[i]);
   erro++;end
  end
  if(erro)begin
  $display("%t:Value ERRO",$time);
  $display("%t:Excute Inst %d ,PC= %x\n",$time,EXE_Count,VM_PC);
  for(i=1; i<32;i++)begin
   $fwrite(fp_w,"%t:VM Reg [%2d]=%x  RM Reg[%2d]=%x \n",$time,i,VM_Reg[i],i,RM_Reg[i]);end
   $fwrite(fp_w,"\n");
  for(i=0; i<32;i++)begin
   $fwrite(fp_w,"%t:Commit Mapping [%2d]=%2d \n",$time,i,top.dut.Register_Rename.Commit_Mapping[i]);end
   $fwrite(fp_w,"\n");
  for(i=0; i<64;i++)begin
   $fwrite(fp_w,"%t:Phy Reg [%2d]=%x  \n",$time,i,top.dut.Regfile.file[i]);end
   $fwrite(fp_w,"%t:VM PC =%x  Commit RM PC =%x PC Value ERRO",$time,VM_PC,top.dut.Commit_PC);

  #30 $finish;end
 else
  $display("%t:Value Correct",$time);
endtask

//Send Pattern
initial begin
	reset();
	while(1)InstMem_Drive(tester.Inst1_Req.Req);
end

//Set Sim Time

initial begin

	#100000 ;
	
	$display("%t:--------------------------",$time); 
	$display("%t:Excute Inst %d ,PC= %x ^____^ NO ERROR",$time,EXE_Count,VM_PC);
	$display("%t:--------------------------",$time); 
	$finish;
end


initial begin

integer Inst;
integer Inst1_New_PC,Inst2_New_PC;


logic Inst1_Branch,Inst2_Branch;

 while(1)begin
  wait(top.dut.Commit1.Commit)
  $display("%t:Inst Commit ",$time);
  check_PC();
  @(posedge tester.clk) ;
  Inst=VM_Inst_FIFO.pop_front();
  Execute_Inst(Inst,VM_PC,Inst1_Branch,Inst1_New_PC);
  EXE_Count++;

  Inst=VM_Inst_FIFO.pop_front();
  Execute_Inst(Inst,VM_PC+4,Inst2_Branch,Inst2_New_PC);
  EXE_Count++;

  if(Inst1_Branch)
	VM_PC=Inst1_New_PC;
  else if(Inst2_Branch)
	VM_PC=Inst2_New_PC;
  else
	VM_PC=Inst2_New_PC;

  if(Inst1_Branch|Inst2_Branch)begin
	$display("%t:--------------------------",$time);
	$display("%t:Occur Branch Flush %d Inst",$time,VM_Inst_FIFO.size()-2);
	for (integer j=VM_Inst_FIFO.size()-2;j>0;j--)begin
	Inst=VM_Inst_FIFO.pop_front();
	$display("%t:Flush Inst  %x",$time,Inst);end
	end
	
  #1;
  for(integer i=0;i<32;i++)Capture_RM_reg(i,RM_Reg[i]);
   Check();
 end
end

endprogram

