module game_menu (
   input wire sw, 
	input wire clock,
	input wire clk60,
	input wire [9:0] next_x,
	input wire [9:0] next_y,
	input wire reset_n,
   input wire [2:0]confirm_button, 
   output reg trigger_count_start,  
	output reg [6:0] hexout,
	output reg [6:0] hexout2,
	output reg [7:0] pixel_color,
	output reg game_mode_chosen
);



parameter TEXT1_COLOR = 8'b000_011_11;    // menu color
parameter TEXT2_COLOR = 8'b111_000_00;    // red
parameter BACKGROUND_COLOR = 8'b111_111_11; // White background

wire res1,res2,res3;
	 							
Pixel_On_Text2 #(.displayText("M E N U")) t1(
                clock,
                285, // text position.x (top left)
                80, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res1  // result, 1 if current pixel is on text, 0 otherwise
);

							
Pixel_On_Text2 #(.displayText("2 P")) t2(
                clock,
                140, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res2  // result, 1 if current pixel is on text, 0 otherwise
);

							
Pixel_On_Text2 #(.displayText("1 P")) t3(
                clock,
                450, // text position.x (top left)
                240, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res3  // result, 1 if current pixel is on text, 0 otherwise
);




// display for game mode
always @(posedge clock) begin
    if (reset_n) begin
        pixel_color <= BACKGROUND_COLOR;  // Reset to background color
    end
    else begin
        if (res1) begin
            pixel_color <= TEXT1_COLOR;
        end
        else if (res2 && sw) begin
            pixel_color <= TEXT2_COLOR;
        end
        else if (res3 && !sw) begin
            pixel_color <= TEXT2_COLOR;
        end
        else begin
            pixel_color <= BACKGROUND_COLOR;
        end
    end
end

reg [4:0] game_end_counter;

// Game start trigger logic 
always @(posedge clk60) begin
    if (reset_n) begin
        trigger_count_start <= 1'b0;
        hexout <= 7'b1000000;  // Display 0 on reset
        hexout2 <= 7'b1000000; // Display 0 on reset
		  game_end_counter <= 5'b0;
    end
    else begin
		if (game_end_counter < 5'd30) begin
			game_end_counter <= game_end_counter + 1'b1;
		end
		else begin
        if (confirm_button[2]||confirm_button[1]||confirm_button[0]) begin
            trigger_count_start <= 1'b1;
        end 
		  else trigger_count_start <= 1'b0;
		end
		
		  if (sw) begin
				hexout <= 7'b0100100;  // display 2
				hexout2 <= 7'b0001100; // display P
				game_mode_chosen = 1'b1;
		  end
		  else begin
				hexout <= 7'b1001111;  // display 1 
				hexout2 <= 7'b0001100; // display P
				game_mode_chosen = 1'b0;
		  end
    end
end	
endmodule