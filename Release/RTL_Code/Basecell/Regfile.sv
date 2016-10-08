//Release 2016.10.08
//File         : Regfile.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: 暫存器檔案MIPS用,Reg[0]固定輸出為0
//version : 1.0
//

module Regfile #(Read_Port=8,Write_Port=4,Width=32,Depth=64)(
input clk,
input [Width-1:0] WD[Write_Port],
input [$clog2(Depth)-1:0]WA[Write_Port],RA[Read_Port],
input  We[Write_Port],
output logic[Width-1:0]RD[Read_Port]
);

integer i,j,k;
reg [31:0]file [0:63];

`ifdef RTLsim
initial begin //test use
  for(k=0;k<Depth;k=k+1)
    file[k]='d0;
  end
`endif

always_comb begin
  for(j=0;j<Read_Port;j++)
    RD[j]=(|RA[j])?file[RA[j]]:'b0;
end

always_ff @(posedge clk)begin
  for(i=0;i<Write_Port;i++)
    if(We[i])
      file[WA[i]]<=WD[i];
end

endmodule
