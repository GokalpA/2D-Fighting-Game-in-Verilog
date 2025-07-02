module Game2P (
input wire clk60,
input wire clk2,
input wire reset_n,
input wire [9:0] next_x,
input wire [9:0] next_y,
input [2:0] buttons,
input [2:0] buttons2, 
input wire clock,     // 25 MHz
output reg [6:0] hexout0,
output reg [6:0] hexout1,
output reg [6:0] hexout2,
output reg [6:0] hexout3,
output reg [6:0] hexout4,
output reg [6:0] hexout5,
output reg [7:0] hex_count,
output wire [2:0] lives,
output [2:0] lives1,
output [2:0] blocks1,
output [2:0] lives2,
output [2:0] blocks2,
output died1,
output died2,
output reg [7:0] pixel_color,
output reg game_over,
output reg menu_can_start
);



parameter PLAYER_COLOR = 8'b000_011_01;    // dark green player
parameter ATTACK_COLOR = 8'b111_000_00;    // red attack
parameter BACKGROUND_COLOR = 8'b100_110_11; // light blue background
parameter BLOCK_COLOR = 8'b00000011;
parameter HIT_COLOR = 8'b00011100;
parameter ATTACK_START_COLOR = 8'b11111100;
parameter GROUND_COLOR = 8'b100_010_00; //brown
parameter PLAYER_HAIR_COLOR = 8'B000_000_00;
parameter PLAYER_EYE_COLOR = 8'B111_111_11;
parameter PLAYER_WIDTH = 10'd64;
parameter PLAYER_HEIGHT = 10'd240;


parameter PLAYER_Y = 10'd120;
parameter ATTACK_Y = 10'd340;
parameter DIR_ATTACK_Y = 10'd260;

parameter ATTACK_WIDTH = 10'd70;           
parameter ATTACK_HURTBOX_WIDTH = 10'd60;
parameter ATTACK_HEIGHT = 10'd20;      
parameter ATTACK_HURTBOX_HEIGHT = 10'd25;

parameter DIR_ATTACK_WIDTH = 10'd40;       
parameter DIR_ATTACK_HURTBOX_WIDTH = 10'd30;
parameter DIR_ATTACK_HEIGHT = 10'd100;      
parameter DIR_ATTACK_HURTBOX_HEIGHT = 10'd110;



wire player1_area   = (next_y >= PLAYER_Y && next_y < PLAYER_Y + PLAYER_HEIGHT) &&
							(next_x >= P1_LocationX && next_x < P1_LocationX + PLAYER_WIDTH);
							
wire player1_hair_area   = (next_y >= PLAYER_Y && next_y < PLAYER_Y + 10'd20) &&
							(next_x >= P1_LocationX && next_x < P1_LocationX + PLAYER_WIDTH);

wire player1_eye_area   = (next_y >= PLAYER_Y + 10'd25 && next_y < PLAYER_Y + 10'd30) &&
							(next_x >= P1_LocationX + PLAYER_WIDTH - 10'd6 && next_x < P1_LocationX + PLAYER_WIDTH - 10'd3);
							
wire attack1_area = (next_y >= ATTACK_Y && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
							(next_x >= P1_LocationX + PLAYER_WIDTH  && next_x < P1_LocationX + PLAYER_WIDTH + ATTACK_WIDTH);

wire attack1_hurtbox_area = (next_y >= ATTACK_Y - 10'd5  && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
									 (next_x >= P1_LocationX + PLAYER_WIDTH  && next_x < P1_LocationX + PLAYER_WIDTH + ATTACK_HURTBOX_WIDTH);

wire dir_attack1_hurtbox_area = (next_y >= DIR_ATTACK_Y - 10'd5  && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
										  (next_x >= P1_LocationX + PLAYER_WIDTH && next_x < P1_LocationX + PLAYER_WIDTH + DIR_ATTACK_HURTBOX_WIDTH);
							
wire dir_attack1_area = (next_y >= DIR_ATTACK_Y && next_y < DIR_ATTACK_Y + DIR_ATTACK_HEIGHT) &&
							   (next_x >= P1_LocationX + PLAYER_WIDTH && next_x < P1_LocationX + PLAYER_WIDTH + DIR_ATTACK_WIDTH);
							
wire player2_area   = (next_y >= PLAYER_Y && next_y < PLAYER_Y + PLAYER_HEIGHT) &&
							(next_x <= P2_LocationX && next_x > P2_LocationX - PLAYER_WIDTH);
							
wire player2_hair_area   = (next_y >= PLAYER_Y && next_y < PLAYER_Y + 10'd20) &&
							(next_x <= P2_LocationX && next_x > P2_LocationX - PLAYER_WIDTH);
							
wire player2_eye_area   = (next_y >= PLAYER_Y + 10'd25 && next_y < PLAYER_Y + 10'd30) &&
							(next_x <= P2_LocationX - PLAYER_WIDTH + 10'd6 && next_x > P2_LocationX - PLAYER_WIDTH + 10'd3);
							
wire attack2_area = (next_y >= ATTACK_Y && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
							(next_x <= P2_LocationX - PLAYER_WIDTH && next_x > P2_LocationX - PLAYER_WIDTH - ATTACK_WIDTH);
							
wire dir_attack2_area = (next_y >= DIR_ATTACK_Y && next_y < DIR_ATTACK_Y + DIR_ATTACK_HEIGHT) &&
							(next_x <= P2_LocationX - PLAYER_WIDTH && next_x > P2_LocationX - PLAYER_WIDTH - DIR_ATTACK_WIDTH);

wire attack2_hurtbox_area = (next_y >= ATTACK_Y - 10'd5 && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
									 (next_x <= P2_LocationX - PLAYER_WIDTH  && next_x > P2_LocationX - PLAYER_WIDTH - ATTACK_HURTBOX_WIDTH);

wire dir_attack2_hurtbox_area = (next_y >= DIR_ATTACK_Y - 10'd5  && next_y < ATTACK_Y + ATTACK_HEIGHT) &&
										  (next_x <= P2_LocationX - PLAYER_WIDTH && next_x > P2_LocationX - PLAYER_WIDTH - DIR_ATTACK_HURTBOX_WIDTH);
										  
wire ground_area = (next_y >= 10'd360  && next_y < 10'd480) &&
										(next_x <= 10'd640 && next_x >= 10'd0);



wire res,res1,res2,res4,res1_0,res1_1,res1_2,res1_3,res1_4,res1_5,res1_6,res1_7,res1_8,res1_9,res2_0;
wire res2_1,res2_2,res2_3,res2_4,res2_5,res2_6,res2_7,res2_8,res2_9,resh_1	,resh_2,resh_3,resh_4,resh_5,resh_6;
wire resb_1,resb_2,resb_3,resb_4,resb_5,resb_6;
		
Pixel_On_Text2 #(.displayText(" GAME OVER ")) t1(clock, 265, 70, next_x, next_y, res);
Pixel_On_Text2 #(.displayText(" P1 WINS ")) t2(clock,275, 90, next_x, next_y, res1);
Pixel_On_Text2 #(.displayText(" P2 WINS ")) t3(clock,275, 90, next_x, next_y, res2);
Pixel_On_Text2 #(.displayText(" DRAW ")) t4(clock,283, 90, next_x, next_y, res4);

Pixel_On_Text2 #(.displayText("0")) count0(clock, 300, 50, next_x, next_y, res1_0);
Pixel_On_Text2 #(.displayText("1")) count11(clock, 300, 50, next_x, next_y, res1_1);
Pixel_On_Text2 #(.displayText("2")) count12(clock, 300, 50, next_x, next_y, res1_2);
Pixel_On_Text2 #(.displayText("3")) count3(clock, 300, 50, next_x, next_y, res1_3);
Pixel_On_Text2 #(.displayText("4")) count4(clock, 300, 50, next_x, next_y, res1_4);
Pixel_On_Text2 #(.displayText("5")) count5(clock, 300, 50, next_x, next_y, res1_5);
Pixel_On_Text2 #(.displayText("6")) count6(clock, 300, 50, next_x, next_y, res1_6);
Pixel_On_Text2 #(.displayText("7")) count7(clock, 300, 50, next_x, next_y, res1_7);
Pixel_On_Text2 #(.displayText("8")) count8(clock, 300, 50, next_x, next_y, res1_8);
Pixel_On_Text2 #(.displayText("9")) count9(clock, 300, 50, next_x, next_y, res1_9);

Pixel_On_Text2 #(.displayText("0")) count20(clock, 310, 50, next_x, next_y, res2_0);
Pixel_On_Text2 #(.displayText("1")) count21(clock, 310, 50, next_x, next_y, res2_1);
Pixel_On_Text2 #(.displayText("2")) count22(clock, 310, 50, next_x, next_y, res2_2);
Pixel_On_Text2 #(.displayText("3")) count23(clock, 310, 50, next_x, next_y, res2_3);
Pixel_On_Text2 #(.displayText("4")) count24(clock, 310, 50, next_x, next_y, res2_4);
Pixel_On_Text2 #(.displayText("5")) count25(clock, 310, 50, next_x, next_y, res2_5);
Pixel_On_Text2 #(.displayText("6")) count26(clock, 310, 50, next_x, next_y, res2_6);
Pixel_On_Text2 #(.displayText("7")) count27(clock, 310, 50, next_x, next_y, res2_7);
Pixel_On_Text2 #(.displayText("8")) count28(clock, 310, 50, next_x, next_y, res2_8);
Pixel_On_Text2 #(.displayText("9")) count29(clock, 310, 50, next_x, next_y, res2_9);

Pixel_On_Text2 #(.displayText("H H H")) heart1(clock, 60, 50, next_x, next_y, resh_1);
Pixel_On_Text2 #(.displayText("H H")) heart2(clock,60, 50, next_x, next_y, resh_2);
Pixel_On_Text2 #(.displayText("H")) heart3(clock, 60, 50, next_x, next_y, resh_3);
Pixel_On_Text2 #(.displayText("H H H")) heart4(clock, 550, 50, next_x, next_y, resh_4);
Pixel_On_Text2 #(.displayText("H H")) heart5(clock, 550, 50, next_x, next_y, resh_5);
Pixel_On_Text2 #(.displayText("H")) heart6(clock, 550, 50, next_x, next_y, resh_6);

Pixel_On_Text2 #(.displayText("B B B")) heart7(clock,60, 80, next_x, next_y, resb_1);
Pixel_On_Text2 #(.displayText("B B")) heart8(clock, 60, 80, next_x, next_y, resb_2);
Pixel_On_Text2 #(.displayText("B")) heart9(clock, 60, 80, next_x, next_y, resb_3);
Pixel_On_Text2 #(.displayText("B B B")) heart10(clock, 550, 80, next_x, next_y, resb_4);
Pixel_On_Text2 #(.displayText("B B")) heart11(clock, 550, 80, next_x, next_y, resb_5);
Pixel_On_Text2 #(.displayText("B")) heart12(clock, 550, 80, next_x, next_y, resb_6);

reg count1_res;
reg count2_res;
reg [3:0] count1 = 4'b0;
reg [3:0] count2 = 4'b0;

wire [3:0] P1_Current_State;
wire [3:0] P2_Current_State;
wire [3:0] P_Next_State;
wire [9:0] P1_LocationX;
wire [9:0] P2_LocationX;

wire hitscan1;
wire hitscan2;

wire [2:0] p1input;
assign p1input = game_over ? 3'b0: buttons;
wire [2:0] p2input;
assign p2input = game_over ? 3'b0: buttons2;
wire fsmclock;
assign fsmclock = game_over ? 1'b0: clk60;

FSM MY_fsm(.clk(fsmclock), .buttons(p1input), .hitscan(hitscan1), .reset_n(reset_n),.Opponent_CS(P2_Current_State), 
			.P_Current_State(P1_Current_State), .lives_led(lives1), .blocks_led(blocks1), .died(died1));
FSM MY_fsm1(.clk(fsmclock), .buttons(p2input), .hitscan(hitscan2),.reset_n(reset_n), .Opponent_CS(P1_Current_State), 
			.P_Current_State(P2_Current_State),.lives_led(lives2), .blocks_led(blocks2), .died(died2));
			

PlayerMovement my_move(.Player1NS(P1_Current_State), 
.Player2NS(P2_Current_State), 
.clk(clk60),
.reset_n(reset_n),
.Player1LocationsXO(P1_LocationX),
.Player2LocationsXO(P2_LocationX)
);

HitScan my_scanner(
.Player1NS(P1_Current_State),
.Player2NS(P2_Current_State),
.Player1LocationsXO(P1_LocationX),
.Player2LocationsXO(P2_LocationX),
.clk(clk60),
.hitscan1(hitscan1),
.hitscan2(hitscan2)
);


always@(*) begin
	case (count2)
        4'd0: count1_res = res1_0;
        4'd1: count1_res = res1_1;
        4'd2: count1_res = res1_2;
        4'd3: count1_res = res1_3;
        4'd4: count1_res = res1_4;
        4'd5: count1_res = res1_5;
        4'd6: count1_res = res1_6;
        4'd7: count1_res = res1_7;
        4'd8: count1_res = res1_8;
        4'd9: count1_res = res1_9;
        default: count1_res = 1'b0;
    endcase
	 case (count1)
        4'd0: count2_res = res2_0;
        4'd1: count2_res = res2_1;
        4'd2: count2_res = res2_2;
        4'd3: count2_res = res2_3;
        4'd4: count2_res = res2_4;
        4'd5: count2_res = res2_5;
        4'd6: count2_res = res2_6;
        4'd7: count2_res = res2_7;
        4'd8: count2_res = res2_8;
        4'd9: count2_res = res2_9;
        default: count2_res = 1'b0;
    endcase
end

reg p1wins;
reg p2wins;
reg draw;


always @(*) begin 
if (reset_n) begin
p1wins = 1'b0;
p2wins = 1'b0;
draw = 1'b0;
game_over = 1'b0;
 end
 else begin
if (died1 && died2) begin
    draw = 1'b1 ;  // Draw - both players dead (highest priority)
	 game_over = 1'b1;
	 p1wins = 1'b0 ;
	 p2wins = 1'b0;
end
else if (died1 ) begin
    p2wins = 1'b1;  // Player 1 dead
	 game_over = 1'b1;
	 	 p1wins = 1'b0 ;
	 draw = 1'b0;
end
else if (died2) begin
    p1wins = 1'b1;  // Player 2 dead
	 game_over=1'b1;
	 	 p2wins = 1'b0 ;
	 draw = 1'b0;
end
else if ((count1==4'd9 && count2==4'd9)) begin
    draw = 1'b1;  // draw by time
	 game_over=1'b1;
	 	 p1wins = 1'b0 ;
	 p2wins = 1'b0;
end
else begin
    draw = 1'b0; 
	 game_over=1'b0;
	 	 p1wins = 1'b0 ;
	 p2wins = 1'b0;
 end
end
end

// hex output according to gameover status 
always @(*)begin
if (game_over == 1'b0 ) begin 
hexout0 = 7'b1111111; //display nothing
hexout1= 7'b0000111; //display t
hexout2= 7'b0001001; //display H
hexout3= 7'b0000010; //display G
hexout4= 7'b11001111; //display I
hexout5= 7'b0001110; //display F
end
else if (game_over == 1'b1 && !draw) begin
hexout0= 7'b0111111; // display - 
hexout1=hexout1wire; //display counter result
hexout2=hexout2wire;  //display counter result
hexout3 = 7'b0111111; // display - 
hexout4 = p1wins ? 7'b1001111: 7'b0100100; // display 1 or 2
hexout5 = 7'b0001100; // display P
end
else if (game_over == 1'b1 && draw) begin
hexout0= 7'b0111111; // display - 
hexout1=hexout1wire; //display counter result
hexout2=hexout2wire;  //display counter result
hexout3 = 7'b0111111; // display - 
hexout4 = 7'b0011000; // display q
hexout5 = 7'b0000110; // E
end
else begin
hexout0 = 7'b1111111; //display nothing
hexout1= 7'b0000111; //display t
hexout2= 7'b0001001; //display H
hexout3= 7'b0000010; //display G
hexout4= 7'b11001111; //display I
hexout5= 7'b0001110; //display F
end 
end




always @(posedge clock) begin
	if (reset_n) begin
		pixel_color = BACKGROUND_COLOR;
	end
	else begin
		if (attack1_area &&  (P1_Current_State == 4'd4)) begin
			pixel_color = ATTACK_COLOR;
		end
 else if (draw && res) begin
          pixel_color = ATTACK_COLOR;
    end
    else    if (draw && res4) begin
          pixel_color = ATTACK_COLOR; 
    end
    else    if (p1wins && res && !draw) begin
          pixel_color = ATTACK_COLOR;  
    end  
else if (p1wins  && res1 && !draw) begin
          pixel_color = ATTACK_COLOR;  
    end
    else    if (p2wins && res && !draw) begin
          pixel_color = ATTACK_COLOR;   
    end
    else    if (p2wins && res2 && !draw) begin
          pixel_color = ATTACK_COLOR;   
    end
		else if (dir_attack1_area &&  (P1_Current_State == 4'd7)) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (player1_area && ((P1_Current_State == 4'd15) || (P1_Current_State == 4'd14))) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (player2_area && (P2_Current_State == 4'd9)) begin
			pixel_color = HIT_COLOR;
		end
		else if (player1_area && (P1_Current_State == 4'd9)) begin
			pixel_color = HIT_COLOR;
		end
		else if (player2_area && (P2_Current_State == 4'd3)) begin
			pixel_color = ATTACK_START_COLOR;
		end
		else if (player1_area && (P1_Current_State == 4'd3)) begin
			pixel_color = ATTACK_START_COLOR;
		end
		else if (player2_area && (P2_Current_State == 4'd6)) begin
			pixel_color = ATTACK_START_COLOR;
		end
		else if (player1_area && (P1_Current_State == 4'd6)) begin
			pixel_color = ATTACK_START_COLOR;
		end
		else if (player2_area && (P2_Current_State == 4'd10)) begin
			pixel_color = BLOCK_COLOR;
		end
			else if (player1_area && (P1_Current_State == 4'd10)) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (attack2_area &&  (P2_Current_State == 4'd4)) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (dir_attack2_area &&  (P2_Current_State == 4'd7)) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (attack1_hurtbox_area &&  ( (P1_Current_State == 4'd4) || (P1_Current_State == 4'd5))) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (dir_attack1_hurtbox_area &&  ( (P1_Current_State == 4'd7) || (P1_Current_State == 4'd8))) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (attack2_hurtbox_area &&  ( (P2_Current_State == 4'd4) || (P2_Current_State == 4'd5))) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (dir_attack2_hurtbox_area &&  ( (P2_Current_State == 4'd7) || (P2_Current_State == 4'd8))) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (count1_res) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (count2_res) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (player1_area && player2_area) begin // for debugging purpose
			pixel_color = ATTACK_COLOR;
		end
		else if (player1_hair_area) begin
			pixel_color = PLAYER_HAIR_COLOR;
		end
		else if (player1_eye_area) begin
			pixel_color = PLAYER_EYE_COLOR;
		end
		else if (player1_area) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (player2_hair_area) begin
			pixel_color = PLAYER_HAIR_COLOR;
		end
		else if (player2_eye_area) begin
			pixel_color = PLAYER_EYE_COLOR;
		end
		else if (player2_area) begin
			pixel_color = PLAYER_COLOR;
		end
		else if (ground_area)begin
			pixel_color = GROUND_COLOR;
		end
		else if (lives1 == 3'b111 && resh_1) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (lives1 == 3'b110 && resh_2) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (lives1 == 3'b100 && resh_3) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (lives2== 3'b111 && resh_4) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (lives2 == 3'b110 && resh_5) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (lives2 == 3'b100 && resh_6) begin
			pixel_color = ATTACK_COLOR;
		end
		else if (blocks1 == 3'b111 && resb_1) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (blocks1 == 3'b110 && resb_2) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (blocks1 == 3'b100 && resb_3) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (blocks2== 3'b111 && resb_4) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (blocks2 == 3'b110 && resb_5) begin
			pixel_color = BLOCK_COLOR;
		end
		else if (blocks2 == 3'b100 && resb_6) begin
			pixel_color = BLOCK_COLOR;
		end
		else begin
			pixel_color = BACKGROUND_COLOR;
		end
	end
end

wire [3:0]count1wire; 
wire [3:0]count2wire;
assign count1wire = count1;
assign count2wire = count2;
wire [6:0] hexout1wire;
wire [6:0] hexout2wire;

hexto7seg hexp(.hexn(hexout1wire), .hex(count1wire));
hexto7seg hexo(.hexn(hexout2wire), .hex(count2wire));

always @(posedge clk2) begin
	if (reset_n) begin
		count1 <= 4'd0;
		count2 <= 4'd0;
	end
	else begin
		if (game_over==1'b0) begin
		if (count1 < 4'd9) count1 <= count1 + 1'b1;
		else begin count1 <= 4'd0; count2<= count2 + 1'b1; 
		end

	end
	else if (game_over==1'b1 ) begin 
		count1 <= count1;
		count2 <= count2;	
	end
	end
end

reg [4:0] counter_game_over;

reg [2:0] buttons_prev;

wire p1_any_button_posedge;

assign p1_any_button_posedge =
    (buttons[0] & ~buttons_prev[0]) |
    (buttons[1] & ~buttons_prev[1]) |
    (buttons[2] & ~buttons_prev[2]);
always @(posedge clk60) begin
        buttons_prev <= buttons;
        if (game_over) begin
				if (counter_game_over < 5'd30) begin
					counter_game_over <= counter_game_over + 1'b1;
					menu_can_start <= 1'b0;
				end
            else if (!menu_can_start && (p1_any_button_posedge)) begin
                menu_can_start <= 1'b1;
					 counter_game_over <= 5'b0;
            end
        end 
		  else begin
			  menu_can_start <= 1'b0;
			  counter_game_over <= 5'b0;
		  end
end


//always @(posedge clk60) begin
//        buttons_prev <= buttons;
//        if (game_over) begin
//            if (!menu_can_start && (p1_any_button_posedge)) begin
//                menu_can_start <= 1'b1;
//            end
//        end 
//		  else menu_can_start <= 1'b0;
//end

endmodule
