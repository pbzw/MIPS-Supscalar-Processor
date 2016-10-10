//Release 2016.10.10
//File         : Inst_FIFO.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0

module Inst_FIFO#(parameter Depth = 8)(
input Global System,
input Local Cntl,

//Data in
input [31:0]Inst_PC,
input Control_Decode Inst_Cont,
input Post_Rename Inst_Post_Rename,
input Inst_En,
//Control
input We,Re,
output Full,Empty,
//Data Out
output Inst_FIFO_Slot FIFO_Top,
output [$clog2(Depth)-1:0]RP

);

logic [$clog2(Depth):0]Data_Count;
logic [$clog2(Depth)-1:0]WP;
Inst_FIFO_Slot Slot[Depth];
assign Empty=!(|Data_Count);
assign Full=Data_Count[$clog2(Depth)];
assign FIFO_Top=Slot[RP];

Up_Counter #(.WIDTH ($clog2(Depth)) ) WP_counter(
.System(System),
.Clr(Cntl.Flush),
.En(We),
.Count(WP)
);

Up_Counter #(.WIDTH ($clog2(Depth)) ) RP_counter(
.System(System),
.Clr(Cntl.Flush),
.En(Re),
.Count(RP)
);

always_ff@(posedge System.Clk) begin
  if(System.Rst|Cntl.Flush)
    Data_Count<='d0;
  else begin
    case({We,Re})
      2'b01:Data_Count<=Data_Count-'d1;
      2'b10:Data_Count<=Data_Count+'d1;
    endcase
  end
  
end

always_ff@(posedge System.Clk)begin
  if(!Full)
    Slot[WP]<={Inst_Cont.Pre_Rename.Rdst,Inst_Cont.ALUop[8:5],Inst_Cont.ALUop[4:0],Inst_Post_Rename,Inst_PC,Inst_Cont.Extend_imm,Inst_En};
end


endmodule
