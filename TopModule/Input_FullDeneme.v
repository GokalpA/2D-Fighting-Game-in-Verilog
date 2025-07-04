
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Input_FullDeneme(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire vga_pll;
wire clk_60;
wire clk_game;

ClockDivider #(2) my_div(
.clk(CLOCK_50),
.clk_out(vga_pll)
);

ClockDivider #(50000000) my_div0(
.clk(CLOCK_50),
.clk_out(clk_2)
);

ClockDivider #(833334) my_div1(
.clk(CLOCK_50),
.clk_out(clk_60)
);

assign LEDR[1] = clk_60;
assign LEDR[2] = clk_2;


assign LEDR[0] = KEY[0];

wire [9:0] next_x;
wire [9:0] next_y;

//vga_driver draw   ( .clock(vga_pll),        // 25 MHz PLL
//                    .reset(SW[0]),      // Active high reset, manipulated by instantiating module
//                    .color_in(8'b11100000), // Pixel color (RRRGGGBB) for pixel being drawn
//                    .next_x(next_x),        // X-coordinate (range [0, 639]) of next pixel to be drawn
//                    .next_y(next_y),        // Y-coordinate (range [0, 479]) of next pixel to be drawn
//                    .hsync(VGA_HS),         // All of the connections to the VGA screen below
//                    .vsync(VGA_VS),
//                    .red(VGA_R),
//                    .green(VGA_G),
//                    .blue(VGA_B),
//                    .sync(VGA_SYNC_N),
//                    .clk(VGA_CLK),
//                    .blank(VGA_BLANK_N)
//);
wire [3:0] buttons_gpio;
kontrol my_buttons(
    .clk(CLOCK_50), 
    .GPIO({{GPIO_0[9], GPIO_0[7], GPIO_0[5], GPIO_0[3], GPIO_0[1]}}), 
    .buttons(buttons_gpio)
);

assign clk_game = SW[1] ? (KEY[3]):(clk_60);

wire [7:0] hex_cont;

VGADenemeGame Game( .clock(vga_pll),        // 25 MHz PLL
						  .clk60(clk_game),
						  .clk2(clk_2),
						  .buttons(buttons_gpio[2:0]),
						  .hex_count(hex_cont),
						  .buttons2	(~KEY[2:0]),
						  .hexout1(HEX5),
						  .hexout2(HEX4),
						  .hexout3(HEX3),
						  .hexout4(HEX2),
						  .hexout5(),
                    .reset(SW[0]),      // Active high reset, manipulated by instantiating module
                    .hsync(VGA_HS),         // All of the connections to the VGA screen below
                    .vsync(VGA_VS),
                    .red(VGA_R),
                    .green(VGA_G),
                    .blue(VGA_B),
                    .sync(VGA_SYNC_N),
                    .clk(VGA_CLK),
                    .blank(VGA_BLANK_N)
);

hexto7seg seg0(.hexn(HEX0),.hex(hex_cont[3:0]));
hexto7seg seg1(.hexn(HEX1),.hex(hex_cont[7:4]));


//game_menu menu1(
//						.sw(SW[0]), 
//						.confirm_button(KEY[3]), 
//						.trigger_count_start (LEDR[4]), 
//
//	
//						  .clock(vga_pll),     // 25 MHz
//                    .reset(SW[1]),      // Active high reset, manipulated by instantiating module
//                    .hsync(VGA_HS),         // All of the connections to the VGA screen below
//                    .vsync(VGA_VS),
//                    .red(VGA_R),
//                    .green(VGA_G),
//                    .blue(VGA_B),
//                    .sync(VGA_SYNC_N),
//                    .clk(VGA_CLK),
//                    .blank(VGA_BLANK_N)
//);

//countdown countdown1(
//							.clk60(clk_60),
//							.count_can_start(0),
//							.trigger_gameplay_start(LEDR[5]),
//
//	
//						  .clock(vga_pll),     // 25 MHz
//                    .reset(SW[1]),      // Active high reset, manipulated by instantiating module
//                    .hsync(VGA_HS),         // All of the connections to the VGA screen below
//                    .vsync(VGA_VS),
//                    .red(VGA_R),
//                    .green(VGA_G),
//                    .blue(VGA_B),
//                    .sync(VGA_SYNC_N),
//                    .clk(VGA_CLK),
//                    .blank(VGA_BLANK_N)
//);


//=======================================================
//  Structural coding
//=======================================================

endmodule
