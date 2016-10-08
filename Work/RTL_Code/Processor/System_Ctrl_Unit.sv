//Release 2016.10.08
//File         : System_Ctrl_Unit.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : About Processor Port information  
//version : 1.0
//

import System_Pkg::*;
import Processor_Pkg::*;

module System_Ctrl_Unit(

input Reorder_Buffer_Full,
input Rename_Fales,
input Inst_Ready,
input Branch_Occur,
input Commit,

output Inst_Req,
output logic[2:0]PCsrcSel,
output Local IF,IF_ID,ID_RN,RN_IS,IS,EX,
output logic Branch_Flush

);

assign Branch_Flush=(Branch_Occur);


assign IF.Stall=(Reorder_Buffer_Full|Rename_Fales)&(!Branch_Flush)|(!Inst_Ready);

assign IF_ID.Stall=Rename_Fales|Reorder_Buffer_Full;
assign IF_ID.Flush=Branch_Flush;

assign ID_RN.Stall=Rename_Fales|Reorder_Buffer_Full;
assign ID_RN.Flush=Branch_Flush;

assign RN_IS.Stall=Reorder_Buffer_Full;
assign RN_IS.Flush=Branch_Flush|(Rename_Fales&(!Reorder_Buffer_Full));

assign IS.Stall=Reorder_Buffer_Full;
assign IS.Flush   =Branch_Flush;


assign EX.Flush   =Branch_Flush;
assign Inst1_req=!(Rename_Fales|Reorder_Buffer_Full);


always_comb begin
  case({Branch_Occur,3'b0})
    4'b0000:PCsrcSel=3'b000;
    4'b1000:PCsrcSel=3'b001;
    default:PCsrcSel=3'b000;
  endcase
end

endmodule
