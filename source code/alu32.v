module alu32(alu_out, a, b, zout, alu_control, jump, control_out);
output reg [31:0] alu_out;
input [31:0] a,b;
input [3:0] alu_control;
input jump;
reg update ;
reg [31:0] less;
output zout;
reg zout;

output control_out; // control out
reg control_out;
reg [2:0] svz; // negative, overflow, zero

always @(a or b or alu_control or jump)
begin
	update = ~update; // It is defined to make the alu32 run once per cycle.
	if(update == 0)	begin

	case(alu_control)
	4'b0010: begin // add
		alu_out = a+b; 
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		if(a[31] == 1 & b[31]== 1 & alu_out[31]==0) svz[1]=1;
		else if (a[31] == 0 & b[31]== 0 & alu_out[31]== 1) svz[1]=1;
		else svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b0110: begin // sub
		alu_out = a+1+(~b); 
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		svz[1] = 0; // no overflow
		svz[0] = ~(|alu_out);
		end

	4'b0111: begin // less than
		less = a+1+(~b);
		if (less[31]) alu_out=1;
		else alu_out=0;
		svz[2]= 0;
		svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b0000: begin // and
		alu_out = a & b;
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b0001: begin // or
		alu_out =  a | b;
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b0011: begin // xor
		alu_out = a ^ b; //bitwise XOR
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b0101: begin // nor
		alu_out = ~(a|b);
		if (alu_out[31]) svz[2]=1;
		else svz[2]=0;
		svz[1] = 0;
		svz[0] = ~(|alu_out);
		end

	4'b1001:begin // bvf
		if(svz[1] ==1) control_out=1;
		else control_out = 0;
		svz[2] = 0;
		svz[1] = 0;
		svz[0] = 0;
		end

	4'b1000:begin // ben
		if(svz[0] == 1 | svz[2] == 1) control_out=1;
		else control_out = 0;
		svz[2] = 0;
		svz[1] = 0;
		svz[0] = 0;
		end

	default: alu_out=31'bx;
	endcase

	end

	if(jump == 1) 
		begin
		svz[2]=0;
		svz[1] = 0;
		svz[0] = 0;
		end

	zout=~(|alu_out);
end
initial
begin
	update = 0;
end
endmodule

