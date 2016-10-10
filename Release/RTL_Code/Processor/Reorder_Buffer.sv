//Release 2016.10.10
//File         : Reorder_Buffer.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0

import System_Pkg::*;
module Reorder_Buffer #(parameter Depth=8)(
input Global System,
input Local Cntl,
input Reorder_Buffer_Slot In,
input We,
//Complete Window
input Window_Commit Port1,Port2,
input [31:0]May_Blanch_PC,
input May_Blanch,

//Commit
input Check_Commit,
output Commit_Target Commit_Port,
output logic[31:0]Commit_PC,Commit_Branch_To_PC,
output logic Commit_Branch,
output Full 
);

Reorder_Buffer_Slot Slot[Depth];
logic [$clog2(Depth):0]Data_Count;
logic [$clog2(Depth)-1:0]WP,RP;


logic [0:Depth-1]Can_Commit,Slot_Branch,Can_Commit_Temp[3];
logic [31:0]Branch_PC[Depth];

assign Full=Data_Count[$clog2(Depth)];
assign Commit_PC=Slot[RP].PC;
assign Commit_Branch_To_PC=Branch_PC[RP];
assign Commit_Branch=Slot_Branch[RP];
assign Commit_Port={Slot[RP].Rdst,Slot[RP].Phydst,(|Data_Count)&Can_Commit[RP]};

Up_Counter #(.WIDTH ($clog2(Depth)) ) WP_counter(
.System(System),
.Clr(Cntl.Flush),
.En(We),
.Count(WP)
);

Up_Counter #(.WIDTH ($clog2(Depth)) ) RP_counter(
.System(System),
.Clr(Cntl.Flush),
.En(Check_Commit),
.Count(RP)
);

always_ff@(posedge System.Clk) begin
  if(System.Rst|Cntl.Flush)
    Data_Count<=5'b0;
  else begin
    case({We,Check_Commit})
      2'b01:Data_Count<=Data_Count-'d1;
      2'b10:Data_Count<=Data_Count+'d1;
    endcase
    end
end

always_ff@(posedge System.Clk) begin
  if(!Full)
    Slot[WP]<=In;
end

assign Can_Commit_Temp[0]=Port1.Commit?{1'b1,{Depth-1{1'b0}}}>>Port1.Window:'b0;
assign Can_Commit_Temp[1]=Port2.Commit?{1'b1,{Depth-1{1'b0}}}>>Port2.Window:'b0;
assign Can_Commit_Temp[2]=Check_Commit?{1'b1,{Depth-1{1'b0}}}>>{RP}:'b0;

always_ff@(posedge System.Clk)begin
	if(System.Rst|Cntl.Flush)
		Can_Commit<='b0;
	else 
     Can_Commit<=(Can_Commit|Can_Commit_Temp[0])&(~Can_Commit_Temp[2]);
end

always_ff@(posedge System.Clk)begin
		if(Port1.Commit)Branch_PC[Port1.Window]<=May_Blanch_PC;
end

always_ff@(posedge System.Clk)begin
		if(System.Rst|Cntl.Flush)
		  Slot_Branch<='b0;
		else begin
		  if(Port1.Commit)Slot_Branch[Port1.Window]<=May_Blanch;
		end
end

endmodule
