module ledhienthi(
	input [5:0] q,
	output x1,v1,d1,x2,v2,d2
);
assign x1 = q[0];
assign v1 = q[1];
assign d1 = q[2];
assign x2 = q[3];
assign v2 = q[4];
assign d2 = q[5];
endmodule

module mux2_1(
input [5:0] in0,
input [5:0] in1,
input s,
output [5:0] out
);
reg [5:0] y=0;
	always @(*)
	begin
		y = s ? in1 : in0;
	end
	assign out = y;
endmodule
module vang_chop_tat(
input clk,
input reset,
output reg [0:5] out
);
initial out = 0;
always @(posedge clk, posedge reset)
	if (reset)
	begin
		out[1] <= 0; //VANG1
		out[4] <= 0; //VANG2
	end
	else
	begin
		out[1] <= ~out[1]; //VANG1
		out[4] <= ~out[4]; //VANG2
	end
endmodule
module trafficlight (
output [5:0] out,
input reset,
input Clk
);
timer part1 (TS, TL, ST, Clk);
fsm part2(RA, YA, GA, RB, YB, GB, ST, TS, TL, reset, Clk);
assign out[0]= GA;
assign out[1]= YA;
assign out[2]= RA ;
assign out[3]= GB ;
assign out[4]= YB ;
assign out[5]= RB ;
endmodule

module timer(
output TS,
output TL,
input ST,
input Clk
);
integer value;
assign TS = (value>=4);
assign TL = (value>=14);
always@(posedge ST or posedge Clk)
begin
if(ST==1)begin
value<=0;
end
else begin
value<=value+1;
end
end
endmodule
module fsm(
output RA,
output YA,
output GA,
output RB,
output YB,
output GB,
output reg ST,
input TS,
input TL,
input reset,
input Clk
);
reg [6:1] state;
parameter GR= 6'b001100;
parameter YR= 6'b010100;
parameter RG= 6'b100001;
parameter RY= 6'b100010;
assign RA = state[6];
assign YA = state[5];
assign GA = state[4];
assign RB = state[3];
assign YB = state[2];
assign GB = state[1];
initial begin state = GR; ST = 1; end
always @(posedge Clk)
begin
if (reset)
begin state <= GR; ST <= 1; end
else
begin
ST <= 0;
case (state)
GR:
if (TL) begin state <= YR; ST <= 1; end
YR:
if (TS) begin state <= RG; ST <= 1; end
RG:
if (TL) begin state <= RY; ST <= 1; end
RY:
if (TS) begin state <= GR; ST <= 1; end
endcase
end
end
endmodule

module top(
input clk_top,
input s,
input reset_top,
output x1,v1,d1,x2,v2,d2
);
wire [5:0] in1,in2,q;
trafficlight b_ngoc (
.out(in1),
.Clk(clk_top),
.reset(reset_top)
);
ledchoptat v_anh (
.clk(clk_top),
.reset(reset_top),
.out(in2)
);
mux2_1 l_nhan (
.in0(in1),
.in1(in2),
.s(s),
.out(q)
);
ledhienthi q_dung (
.q(q),
.x1(x1),
.v1(v1),
.d1(d1),
.x2(x2),
.v2(v2),
.d2(d2)
);
endmodule