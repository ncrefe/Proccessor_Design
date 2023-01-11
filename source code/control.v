module control(in, regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop1, aluop2, aluop3, jump);
input [5:0] in;
output regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop1, aluop2,aluop3, jump;

wire rformat,lw,sw,beq,j,ben,bvf,addi;

assign rformat =~| in;

assign lw = in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];

assign sw = in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];

assign beq = ~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);

assign j = ~in[5]& (~in[4])&(~in[3])&(~in[2])&(in[1])&(~in[0]);

assign addi = ~in[5]& (~in[4])&(in[3])&(~in[2])&(~in[1])&(~in[0]);

assign bvf = ~in[5]& (~in[4])&(~in[3])&(in[2])&(~in[1])&(in[0]); // 000101

assign ben = ~in[5]& (~in[4])&(~in[3])&(in[2])&(in[1])&(~in[0]); // 000110

assign regdest = rformat;

assign alusrc = lw|sw|addi;
assign memtoreg = lw;
assign regwrite = rformat|lw|addi;
assign memread = lw;
assign memwrite = sw;
assign branch = beq | ben | bvf; // branch flag is enough to being aware of ben and bvf

// ALUOP  321
//-----------
// I type 000
// R type 001
// Branch 010
// Ben    011
// Bvf    100
assign aluop1 = rformat | ben;
assign aluop2 = beq     | ben;
assign aluop3 = bvf;
assign jump = j;
endmodule
