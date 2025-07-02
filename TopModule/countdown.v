module countdown (
	input wire clk,
	input wire clk60,
	input wire reset_n,  
	input wire count_can_start,
	input wire [9:0] next_x,
	input wire [9:0] next_y,
	output reg trigger_gameplay_start,
	output reg [7:0] pixel_color	
);

localparam 
S_THREE  = 3'd0,
S_TWO    = 3'd1,
S_ONE    = 3'd2,
S_START  = 3'd3,
S_HOLD = 3'd4;

parameter THREE_COLOR = 8'b010_001_10; //RANDOMLY CHOSEN COLORS
parameter TWO_COLOR = 8'b010_100_11; 
parameter ONE_COLOR = 8'b111_000_11; 
parameter START_COLOR = 8'b011_100_01;   
parameter BACKGROUND_COLOR = 8'b111_111_11; // White background

wire res1, res2, res3, res4;  // Wire declarations for text results
	 							
Pixel_On_Text2 #(.displayText("3")) t1(
                clk,
                320, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res1  // result, 1 if current pixel is on text, 0 otherwise
);
							
Pixel_On_Text2 #(.displayText("2")) t2(
                clk,
                320, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res2  // result, 1 if current pixel is on text, 0 otherwise
);
							
Pixel_On_Text2 #(.displayText("1")) t3(
                clk,
                320, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res3  // result, 1 if current pixel is on text, 0 otherwise
);

Pixel_On_Text2 #(.displayText("S T A R T")) t4(
                clk,
                280, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res4  // result, 1 if current pixel is on text, 0 otherwise
);

// FSM LOGIC
reg [5:0] frame_count;
reg [2:0] current_state;
reg [2:0] next_state;

// Combinational logic for next state
always @(*) begin
    next_state = current_state;
    trigger_gameplay_start = 1'b0;
    
    if (count_can_start == 1'b1) begin
        case(current_state)
            S_THREE: begin
                if (frame_count >= 59) // 60 frames (0-59)
                    next_state = S_TWO;
            end
            S_TWO: begin
                if (frame_count >= 59) 
                    next_state = S_ONE;
            end
            S_ONE: begin
                if (frame_count >= 59) 
                    next_state = S_START;
            end
            S_START: begin
					if (frame_count >= 59) 
                    next_state = S_HOLD;
            end
				S_HOLD: begin
                trigger_gameplay_start = 1'b1;
				end
            default: begin
                next_state = S_THREE;
            end
        endcase
    end
end

// Sequential logic with reset
always @(posedge clk60) begin
    if (reset_n) begin
        current_state <= S_THREE;
        frame_count <= 6'd0;
    end
    else begin
        if (count_can_start == 1'b1) begin
            if (current_state != next_state) begin
                frame_count <= 6'd0;
                current_state <= next_state;
            end
            else begin
                frame_count <= frame_count + 1'b1;
            end
        end
        else begin
            // Reset countdown when not in game state
            current_state <= S_THREE;
            frame_count <= 6'd0;
        end
    end
end

// Display logic with reset
always @(posedge clk) begin
    if (reset_n) begin
        pixel_color <= BACKGROUND_COLOR;
    end
    else begin
        if (count_can_start == 1'b1) begin
            if (res1 && current_state == S_THREE) begin
                pixel_color <= THREE_COLOR;
            end
            else if (res2 && current_state == S_TWO) begin
                pixel_color <= TWO_COLOR;
            end
            else if (res3 && current_state == S_ONE) begin
                pixel_color <= ONE_COLOR;
            end
            else if (res4 && current_state == S_START) begin
                pixel_color <= START_COLOR;
            end
            else begin
                pixel_color <= BACKGROUND_COLOR;
            end   
        end
        else begin
            pixel_color <= BACKGROUND_COLOR;
        end
    end
end

endmodule