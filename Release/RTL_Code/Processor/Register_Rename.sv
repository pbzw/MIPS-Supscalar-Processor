//Release 2016.10.08
//File         : Register_Rename.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 2-Instruction Register Rename
//version : 1.0
//

import System_Pkg::*;

module Register_Rename(

input Global System,
input Local Cntl,
input Branch_Flush,
//Commit Unit
input Commit_Target Commit1,Commit2,

input Source Inst1,Inst2,
input RegW1,RegW2,Inst1_en,Inst2_en,

output Post_Rename RInst1,RInst2,
output RU_Stall
);

logic Branch_Flag;
/*Temp_Mappling_Log*/
logic [5:0]Temp_Mappling_Phy[0:31];
/*Phy_Using_Log*/
logic [0:63]Phy_Using_Used,Phy_Using_Committed;
/*Commit_Mapping_Log*/
logic [5:0]Commit_Mapping[0:31];

logic [0:63]Phy_can_Used;
assign Phy_can_Used=(~Phy_Using_Used);
integer i,j,k;

always_ff@(posedge System.Clk)begin
  if(System.Rst)
    Branch_Flag<='b0;
  else
    Branch_Flag<=Branch_Flush;
end

//Update Commit Map 
always_ff@(posedge System.Clk)begin
  if(System.Rst)
    for(j=0;j<32;j=j+1)Commit_Mapping[j]<=6'b0;
  else begin
    if(Commit1.Commit)begin
      Commit_Mapping[Commit1.Rdst]<=Commit1.Phydst;
      Commit_Mapping[Commit2.Rdst]<=Commit2.Phydst;
      end
    end
end

wire [0:63] temp [6];

assign temp[0]=(!Cntl.Stall)?64'h8000_0000_0000_0000>>RInst1.Phydst:64'h0;
assign temp[1]=(!Cntl.Stall)?64'h8000_0000_0000_0000>>RInst2.Phydst:64'h0;
//Get Free Phydst and set it busy
assign temp[2]=(Commit1.Commit)?64'h8000_0000_0000_0000>>(Commit_Mapping[Commit1.Rdst]):64'h0;
assign temp[3]=(Commit2.Commit)?64'h8000_0000_0000_0000>>(Commit_Mapping[Commit2.Rdst]):64'h0;
//Release Phydst From CommitMapping
assign temp[4]=(Commit1.Commit)&(Commit1.Rdst==Commit2.Rdst)?64'h8000_0000_0000_0000>>Commit1.Phydst:64'h0;
//If Commit Rdst Same Release Commit1's Phydst

always@(posedge System.Clk)begin
  if(System.Rst) begin
    Phy_Using_Used<='b0;
    Phy_Using_Committed<='b0;
    end
  else begin
    Phy_Using_Committed<=(Phy_Using_Committed&(~(temp[0]|temp[1])))&(~(temp[2]|temp[3]|temp[4]));
    if(Commit1.Commit)begin
      Phy_Using_Committed[Commit1.Phydst]<=1'b1;
		Phy_Using_Committed[Commit2.Phydst]<=1'b1;
    end
  if(Branch_Flag) 
    Phy_Using_Used<=Phy_Using_Committed&Phy_Using_Used;
  else 
    Phy_Using_Used<=(Phy_Using_Used|temp[0]|temp[1])&(~(temp[2]|temp[3]|temp[4]));
  end
end

always_ff @(posedge System.Clk)begin
  if(System.Rst)
    for(k=0;k<32;k=k+1)Temp_Mappling_Phy[k]<=5'b0;
  else if(Branch_Flag)
    for(k=1;k<32;k=k+1)Temp_Mappling_Phy[k]<=Commit_Mapping[k];
  else begin
    if((Inst1_en&RegW1)&(!Cntl.Stall)&(|Inst1.Rdst))
      Temp_Mappling_Phy[Inst1.Rdst]<={RInst1.Phydst};
    if((Inst2_en&RegW2)&(!Cntl.Stall)&(|Inst2.Rdst))
      Temp_Mappling_Phy[Inst2.Rdst]<={RInst2.Phydst};
    end
end

/*Pre_Rename_Stage*/
Post_Rename Pre_Rename_Inst2;

assign Pre_Rename_Inst2.Src1=Temp_Mappling_Phy[Inst2.Src1];
assign Pre_Rename_Inst2.Src2=Temp_Mappling_Phy[Inst2.Src2];

assign RInst1.Src1=Temp_Mappling_Phy[Inst1.Src1];
assign RInst1.Src2=Temp_Mappling_Phy[Inst1.Src2];

wire Inst2_Src1_Match=(Inst1.Rdst==Inst2.Src1)&(|Inst1.Rdst);
wire Inst2_Src2_Match=(Inst1.Rdst==Inst2.Src2)&(|Inst1.Rdst);

logic[5:0]Mux1[2],Mux2[2];

assign Mux1[0]=Pre_Rename_Inst2.Src1;
assign Mux1[1]=RInst1.Phydst;
assign Mux2[0]=Pre_Rename_Inst2.Src2;
assign Mux2[1]=RInst1.Phydst;

Muxer #(.In_Port(2),.WIDTH(6))Inst2_Src1_Mux(
.sel(Inst2_Src1_Match),
.in(Mux1),
.out(RInst2.Src1)
);

Muxer #(.In_Port(2),.WIDTH(6))Inst2_Src2_Mux(
.sel(Inst2_Src2_Match),
.in(Mux2),
.out(RInst2.Src2)
);

Physical_Register_Free_List Physical_logicister_Free_List (
.in(Phy_can_Used),//can_Use_Phy
.Take1(RegW1&Inst1_en),
.Take2(RegW2&Inst2_en),
.Take_Phy1(RInst1.Phydst),
.Take_Phy2(RInst2.Phydst),
.Stall(RU_Stall)
);

endmodule
