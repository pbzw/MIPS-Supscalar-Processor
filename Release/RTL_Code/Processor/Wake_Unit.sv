//Release 2016.10.10
//File         : Wake_Unit.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description  : 
//version : 1.0

import System_Pkg::*;

module Wake_Unit(
input Global System,
input Local Cntl,
input [5:0]Inst1_Phydst,
input [5:0]Inst2_Phydst,

input Wake_Up_port Port1,Port2,Port3,Port4,

output logic[0:63]List
);


logic [0:63]Phy_Wake,Wake_List[7];

assign Wake_List[0]=64'h8000_0000_0000_0000>>Port1.Phydst;
assign Wake_List[1]=64'h8000_0000_0000_0000>>Port2.Phydst;
//assign Wake_List[2]=64'h8000_0000_0000_0000>>Port3.Phydst;
//assign Wake_List[3]=64'h8000_0000_0000_0000>>Port4.Phydst;
assign Wake_List[5]=Cntl.Stall?~64'h0:~(64'h8000_0000_0000_0000>>Inst1_Phydst);
assign Wake_List[6]=Cntl.Stall?~64'h0:~(64'h8000_0000_0000_0000>>Inst2_Phydst);

assign List = {1'b1,Phy_Wake[1:63]};

always_ff@(posedge System.Clk)begin
  if(System.Rst|Cntl.Flush)
    Phy_Wake<=64'hffffffffffffffff;
  else 
    Phy_Wake<=((Phy_Wake|Wake_List[0])|Wake_List[1]/*|Wake_List[2]))|Wake_List[3]*/)&(Wake_List[5]&Wake_List[6]);
  end
  
endmodule


