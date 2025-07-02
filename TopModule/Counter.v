module Counter #(parameter W = 4)(
input 		[1:0]  control,
input 				 clk,
output reg [W-1:0] count_out
);

localparam
hold = 2'b00,
inc = 2'b01,
dec = 2'b10,
res = 2'b11;

initial begin
count_out <= {W{1'b0}};
end


always @(posedge clk) begin
if (control == res) count_out <= {W{1'b0}};
else if (control == hold) count_out <= count_out;
else if(control == inc) begin
	if (count_out == {W{1'b1}}) count_out <= {W{1'b0}};
	else count_out <= count_out + 1'b1;
	end
else if(control == dec) begin
	if (count_out == {W{1'b0}}) count_out <= {W{1'b1}};
	else count_out <= count_out - 1'b1;
	end 
end
endmodule