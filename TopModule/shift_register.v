module shift_register #(
    parameter W = 4
)(
    input wire clk,
    input wire rst, 
    input wire [1:0] ctrl,
    input wire serial_in_right, 
    input wire serial_in_left,
	 input wire load,
    input wire [W-1:0] parallel_in,
    output wire [W-1:0] parallel_out 
);

	reg [W-1:0] shift_reg;

	localparam SHIFT_RIGHT   = 2'b01;
	localparam SHIFT_LEFT    = 2'b10;

	always @(posedge clk) begin
		if (rst) begin
			shift_reg <= {W{1'b0}};
		end
		else if (load) begin
			shift_reg <= parallel_in;
		end	
		else begin
			case (ctrl)
				SHIFT_RIGHT: shift_reg <= {serial_in_right, shift_reg[W-1:1]}; 
				SHIFT_LEFT: shift_reg <= {shift_reg[W-2:0], serial_in_left}; 
				default: shift_reg <= shift_reg;
          endcase
      end
	end
    
    assign parallel_out = shift_reg;

endmodule