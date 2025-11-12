`timescale 1ns / 1ps
module trafficlight_tb;
// Inputs
reg reset;
reg Clk;
// Outputs
wire [5:0] q;
// Instantiate the Unit Under Test (UUT)
trafficlight uut (
.out(q),
.reset(reset),
.Clk(Clk)
);
always #5 Clk=~Clk;
initial begin
// Initialize Inputs
Clk = 0;
reset = 1;
#5;
reset = 0;
#700;
reset = 1;
#100;
reset = 0;
end
endmodule