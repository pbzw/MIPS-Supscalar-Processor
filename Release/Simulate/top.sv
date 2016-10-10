// 2016.09.19
// File         : top.sv
// Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//  Description: 
//  
//

//`timescale 1ns/100ps
import System_Pkg::*;
module top;
  parameter simulation_cycle = 5;

  reg  SystemClock;
  Processor_inf  top_io(SystemClock);
  test test_p(top_io);

  
Processor dut(
.System({SystemClock,top_io.rst}),
.Inst1_Resp(top_io.Inst1_Resp),
.Inst2_Resp(top_io.Inst2_Resp),
.Inst1_Req(top_io.Inst1_Req),
.Inst2_Req(top_io.Inst2_Req)
);
  


//------ Generate Clock ------------
  initial begin
    SystemClock = 0;
    forever begin
      #(simulation_cycle)
        SystemClock = ~SystemClock;
    end
  end
  
//------ Dump VCD File ------------  
  initial begin
		$vcdpluson;
  end

endmodule
