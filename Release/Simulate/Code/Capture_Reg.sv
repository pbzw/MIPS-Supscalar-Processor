task Capture_RM_reg(input integer i,output logic [31:0]Value);

	Value=top.dut.Regfile.file[top.dut.Register_Rename.Commit_Mapping[i]];
	//$display("%t:RM Reg %2d = %x ",$time,i,Value);
endtask	

