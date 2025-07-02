module LFSR (
    input wire clk,
    input wire rst, 
    input wire [15:0] seed, 
    output wire [15:0] lfsr_out 
);

    wire feedback;
    assign feedback = lfsr_out[0] ^ lfsr_out[2] ^ lfsr_out[3] ^ lfsr_out[5];

    shift_register #(.W(16)) mysr (
        .clk(clk),
        .rst(1'b0),
		  .load(rst),
        .ctrl(2'b01), //shift direction is to the right
        .serial_in_right(feedback),
        .serial_in_left(1'b0),
        .parallel_in(seed),
        .parallel_out(lfsr_out)
    );

endmodule