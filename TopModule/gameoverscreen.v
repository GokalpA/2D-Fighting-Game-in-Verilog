module game_over( 
input wire game_over_flag,
input wire game_over_state,
input wire [7:0] game_duration,
input wire clock,     // 25 MHz
input wire reset,     // Active high
output wire hsync,    // HSYNC (to VGA connector)
output wire vsync,    // VSYNC (to VGA connctor)
output [7:0] red,     // RED (to resistor DAC VGA connector)
output [7:0] green,   // GREEN (to resistor DAC to VGA connector)
output [7:0] blue,    // BLUE (to resistor DAC to VGA connector)
output sync,          // SYNC to VGA connector
output clk,           // CLK to VGA connector
output blank          // BLANK to VGA connector
);

parameter GAMEOVERCOLOR = 8'b001_101_11; 
parameter GAMEDURATIONCOLOR = 8'b111_011_01;   
parameter WINNERCOLOR = 8'b011_000_11;

wire [9:0] next_x, next_y;
reg [7:0] pixel_color;
wire res1, res2,res3,res4;

Pixel_On_Text2 #(.displayText("Game Over")) t1(
                clock,
                300, // text position.x (top left)
                50, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res1  // result, 1 if current pixel is on text, 0 otherwise
            );
Pixel_On_Text2 #(.displayText("P1 Wins")) t2(
                clock,
                400, // text position.x (top left)
                50, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res2  // result, 1 if current pixel is on text, 0 otherwise
            );
Pixel_On_Text2 #(.displayText("P2 Wins")) t3(
                clock,
                400, // text position.x (top left)
                50, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res3  // result, 1 if current pixel is on text, 0 otherwise
            );
Pixel_On_Text2 #(.displayText("Game duration : XX Seconds")) t4(
                clock,
                500, // text position.x (top left)
                50, // text position.y (top left)
                next_x, // current position.x
                next_y, // current position.y
                res4  // result, 1 if current pixel is on text, 0 otherwise
            );
vga_driver vga (
        .clock(clock),
        .reset(reset),
        .color_in(pixel_color),
        .next_x(next_x),
        .next_y(next_y),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue),
        .sync(sync),
        .clk(clk),
        .blank(blank)
    );
	 
// ALSO INSTANT FSM TO CHECK GAME OVER STATE
// ADD FSM TO CHECK GAME OVER FROM LIFES 
	 
always @(posedge clock) begin
	if (game_over_flag) begin
		if (res1) begin
		pixel_color = GAMEOVERCOLOR;
		end
		else if (res4) begin
		pixel_color = GAMEDURATIONCOLOR;
		end
		else if (res2 && game_over_state == 1'b0) begin
		pixel_color = WINNERCOLOR;
		end
		else if (res3 && game_over_state == 1'b1) begin
		pixel_color = WINNERCOLOR;
		end
		else begin
		pixel_color = pixel_color;
		end
		end
end
endmodule