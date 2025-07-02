module Shifter #(parameter W = 4)(
input [1:0]			    control,
input			 		 serialL,
input			 		 serialR,
input 				 clk,
input 			reset_n,
output wire [W-1:0] Sout
);

localparam
SR = 2'b00,
SL = 2'b01,
LO = 2'b11;

reg [W-1:0] Soutreg = {W{1'b1}};


always @(posedge clk) begin
 if (reset_n) begin 
 Soutreg <= {W{1'b1}};
 end
 else begin
	if (control == SR) Soutreg <= {serialL ,Soutreg[W-1:1]};
	else if (control == SL) Soutreg <= {Soutreg[W-2:0], serialR};
	else if (control == LO) Soutreg <= Soutreg;
	else Soutreg <= {W{1'b0}};
end
end

assign Sout = Soutreg;
endmodule