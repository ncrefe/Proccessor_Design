module alucont(aluop1, aluop2, aluop3, f3, f2, f1, f0, gout);

input aluop1,aluop2,aluop3,f3,f2,f1,f0;
output [3:0] gout;
reg [3:0] gout;

always @(aluop1 or aluop2 or aluop3 or f3 or f2 or f1 or f0)
begin
	if(~(aluop1|aluop2|aluop3)) // aluop 000
		// I type and addition
		// lw sw addi
		gout=4'b0010;
	if(aluop2) // beq
		gout=4'b0110;
	if(aluop1) // r-type
	begin
		if (~(f3|f2|f1|f0))
			gout=4'b0010;
		if (f1 & f3)
			gout=4'b0111;
		if (f1 &~(f3))
			gout=4'b0110;
		if (f2 & f0)
			gout=4'b0001;
		if (f2 &~(f0))
			gout=4'b0000;
		if (f2 & f1 & f3 & f0)
			gout = 4'b0011;
		if ((~f3) & f2 & f1 & f0)
			gout = 4'b0101;
	end
	if(aluop1 & aluop2) // ben
		gout = 4'b1000;
	if(aluop3) // bvf
		gout = 4'b1001;
end
endmodule
