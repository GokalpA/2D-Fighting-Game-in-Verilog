module HitScan (
	input wire [3:0] Player1NS,
	input wire [3:0] Player2NS,
	input wire[9:0] Player1LocationsXO,
	input wire[9:0] Player2LocationsXO,
	input wire 		  clk,
	output reg hitscan1,
	output reg hitscan2
);

parameter PLAYER_WIDTH = 10'd64;

localparam
S_BASIC_ATTACK_START  = 4'd3,
S_BASIC_ATTACK_ACTIVE = 4'd4,
S_BASIC_ATTACK_REC 	 = 4'd5,
S_DIR_ATTACK_START  	 = 4'd6,
S_DIR_ATTACK_ACTIVE 	 = 4'd7,
S_DIR_ATTACK_REC 		 = 4'd8;

parameter ATTACK_WIDTH = 10'd70;     
parameter ATTACK_HURTBOX_WIDTH = 10'd60;
parameter DIR_ATTACK_WIDTH = 10'd40;     
parameter DIR_ATTACK_HURTBOX_WIDTH = 10'd30;


wire [9:0] player1_right_edge, player2_left_edge;
assign player1_right_edge = Player1LocationsXO + PLAYER_WIDTH;
assign player2_left_edge = Player2LocationsXO -PLAYER_WIDTH; 

// Player 1 attack areas (attacking rightward)
wire [9:0] attack1_right_edge, attack1_hurtbox_right_edge;
wire [9:0] dir_attack1_right_edge, dir_attack1_hurtbox_right_edge;
assign attack1_right_edge = Player1LocationsXO + PLAYER_WIDTH + ATTACK_WIDTH;
assign attack1_hurtbox_right_edge = Player1LocationsXO + PLAYER_WIDTH +ATTACK_HURTBOX_WIDTH;
assign dir_attack1_right_edge = Player1LocationsXO + PLAYER_WIDTH +  DIR_ATTACK_WIDTH;
assign dir_attack1_hurtbox_right_edge = Player1LocationsXO + PLAYER_WIDTH + DIR_ATTACK_HURTBOX_WIDTH;

// Player 2 attack areas (attacking leftward)
wire [9:0] attack2_left_edge, attack2_hurtbox_left_edge;
wire [9:0] dir_attack2_left_edge, dir_attack2_hurtbox_left_edge;
assign attack2_left_edge = Player2LocationsXO - PLAYER_WIDTH - ATTACK_WIDTH;
assign attack2_hurtbox_left_edge = Player2LocationsXO - PLAYER_WIDTH - ATTACK_HURTBOX_WIDTH;
assign dir_attack2_left_edge = Player2LocationsXO - PLAYER_WIDTH - DIR_ATTACK_WIDTH;
assign dir_attack2_hurtbox_left_edge = Player2LocationsXO - PLAYER_WIDTH - DIR_ATTACK_HURTBOX_WIDTH;

// Player hitbox and hurtbox boundaries
reg [9:0] P1_left, P1_right;   
reg [9:0] P1_attack_left, P1_attack_right; 
reg [9:0] P2_left, P2_right;   
reg [9:0] P2_attack_left, P2_attack_right;  

always @(*) begin
	hitscan1 = 0;
	hitscan2 = 0;
	
	// Player 1 state logic
if (Player1NS == S_BASIC_ATTACK_ACTIVE) begin
    P1_left = Player1LocationsXO;
    P1_right = attack1_hurtbox_right_edge;
    P1_attack_left = Player1LocationsXO;
    P1_attack_right = attack1_right_edge;
end
else if (Player1NS == S_BASIC_ATTACK_REC) begin
    P1_left = Player1LocationsXO;
    P1_right = attack1_hurtbox_right_edge;
    P1_attack_left = 0;
    P1_attack_right = 0;
end
else if (Player1NS == S_DIR_ATTACK_ACTIVE) begin
    P1_left = Player1LocationsXO;
    P1_right = dir_attack1_hurtbox_right_edge;
    P1_attack_left = Player1LocationsXO;
    P1_attack_right = dir_attack1_right_edge;
end
else if (Player1NS == S_DIR_ATTACK_REC) begin
	P1_left = Player1LocationsXO;
   P1_right = dir_attack1_hurtbox_right_edge;
	P1_attack_left = 0;
	P1_attack_right = 0;
end
else begin
    P1_left = Player1LocationsXO;
    P1_right = player1_right_edge;
    P1_attack_left = 0;
    P1_attack_right = 0;
end


if (Player2NS == S_BASIC_ATTACK_ACTIVE) begin
    P2_right        = Player2LocationsXO;
    P2_left         = attack2_hurtbox_left_edge;
    P2_attack_right = Player2LocationsXO;
    P2_attack_left  = attack2_left_edge;
end
else if (Player2NS == S_BASIC_ATTACK_REC) begin
    P2_right        = Player2LocationsXO;
    P2_left         = attack2_hurtbox_left_edge;
    P2_attack_right = 0;
    P2_attack_left  = 0;
end
else if (Player2NS == S_DIR_ATTACK_ACTIVE) begin
    P2_right        = Player2LocationsXO;
    P2_left         = dir_attack2_hurtbox_left_edge;
    P2_attack_right = Player2LocationsXO;
    P2_attack_left  = dir_attack2_left_edge;
end
else if (Player2NS == S_DIR_ATTACK_REC) begin
    P2_right        = Player2LocationsXO;
    P2_left         = dir_attack2_hurtbox_left_edge;
    P2_attack_right = 0;
    P2_attack_left  = 0;
end
else begin
    P2_right        = Player2LocationsXO;
    P2_left         = Player2LocationsXO - PLAYER_WIDTH;
    P2_attack_left  = 0;
    P2_attack_right = 0;
end


if (P1_attack_right > P1_attack_left) begin  
	if (P1_attack_right >= P2_left) begin
		hitscan2 = 1;  
	end
end

if (P2_attack_right > P2_attack_left) begin  
	if (P2_attack_left <= P1_right) begin
		hitscan1 = 1;  
	end
end
end

endmodule