module ClockDivider #(parameter D = 4)(
input clk,
output reg clk_out
);

localparam width = $clog2(D);

reg [1:0] control;

initial begin
	clk_out <= 1'b0;
	control <= 2'b01;
end

wire [width-1:0] count_amnt;

Counter #(width) my_counter(.control(control), .clk(clk), .count_out(count_amnt));

always @(*) begin
    if (count_amnt == D/2 - 1)
        control = 2'b11; // Reset counter
    else
        control = 2'b01; // Increment
end


always @(posedge clk) begin
    if (control == 2'b11)
        clk_out <= ~clk_out;
end


endmodule