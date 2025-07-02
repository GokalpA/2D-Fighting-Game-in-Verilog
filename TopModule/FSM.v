module FSM(
    input clk,
    input reset_n, 
    input [2:0] buttons,
	 input hitscan,
	 input [3:0] Opponent_CS,
    output reg [3:0] P_Current_State,
	 output wire [2:0] lives_led, blocks_led,
	 output reg died
);

localparam
SERIAL_L = 2'b01,
HOLD = 2'b11;

localparam 
S_IDLE          		 = 4'd0,
S_FORWARD             = 4'd1,
S_BACKWARD            = 4'd2,

S_BASIC_ATTACK_START  = 4'd3,
S_BASIC_ATTACK_ACTIVE = 4'd4,
S_BASIC_ATTACK_REC 	 = 4'd5,

S_DIR_ATTACK_START  	 = 4'd6,
S_DIR_ATTACK_ACTIVE 	 = 4'd7,
S_DIR_ATTACK_REC 		 = 4'd8,

S_HIT_STUN 				 = 4'd9,
S_BLOCK_STUN 			 = 4'd10;

localparam 
S_BASIC_ATTACK_START_FRAME  = 4'd5,
S_BASIC_ATTACK_ACTIVE_FRAME = 4'd2,
S_BASIC_ATTACK_REC_FRAME 	 = 5'd16,

S_DIR_ATTACK_START_FRAME  	 = 4'd4,
S_DIR_ATTACK_ACTIVE_FRAME 	 = 4'd3,
S_DIR_ATTACK_REC_FRAME 		 = 4'd15,

S_HIT_STUN_FRAME_BASIC 		 = 4'd15,
S_HIT_STUN_FRAME_DIR 		 = 4'd14,

S_BLOCK_STUN_FRAME_BASIC	 = 4'd13,
S_BLOCK_STUN_FRAME_DIR	    = 4'd12;



wire left = buttons[2];
wire right = buttons[1];
wire attack = buttons[0];
reg [1:0] lives;
reg [1:0] blocks;
reg [4:0] frame_count;
reg [3:0] State_Frame_Holder;
reg [3:0] NS;
reg [1:0] block_control;
reg [1:0] life_control;

Shifter #(3) lifeshifter(.control(life_control),.reset_n(reset_n),.serialL(1'b0), .serialR(1'b0), .clk(clk),  .Sout(lives_led));
Shifter #(3) blockshifer(.control(block_control), .reset_n(reset_n),.serialL(1'b0), .serialR(1'b0), .clk(clk),  .Sout(blocks_led));


always @(*) begin
State_Frame_Holder = State_Frame_Holder;
life_control = HOLD;
block_control = HOLD;
NS = P_Current_State;
	if ((hitscan == 1) && (P_Current_State != S_HIT_STUN) && (P_Current_State != S_BLOCK_STUN)) begin
		if ((P_Current_State == S_BACKWARD) && (blocks != 0)) begin
			NS = S_BLOCK_STUN;
			block_control = SERIAL_L;
			if (Opponent_CS == S_DIR_ATTACK_ACTIVE) State_Frame_Holder = S_BLOCK_STUN_FRAME_DIR;
			else State_Frame_Holder = S_BLOCK_STUN_FRAME_BASIC;
		end
		else begin
			NS = S_HIT_STUN;
			life_control = SERIAL_L;
			if (Opponent_CS == S_DIR_ATTACK_ACTIVE) State_Frame_Holder = S_HIT_STUN_FRAME_DIR;
			else State_Frame_Holder = S_HIT_STUN_FRAME_BASIC;
		end
	end
	
	else begin
		case(P_Current_State)
		  S_IDLE: begin
				if (attack & right & left) NS = S_BASIC_ATTACK_START;
				else if (attack & right) NS = S_DIR_ATTACK_START;
				else if (attack & left) NS = S_DIR_ATTACK_START;
				else if (right & left) NS = S_IDLE;
				else if (attack) NS = S_BASIC_ATTACK_START;
				else if (left) NS = S_BACKWARD;
				else if (right) NS = S_FORWARD;
				else NS = S_IDLE;
		  end

		  S_BACKWARD: begin
				if (attack & right & left) NS = S_BASIC_ATTACK_START;
				else if (attack & right) NS = S_DIR_ATTACK_START;
				else if (attack & left) NS = S_DIR_ATTACK_START;
				else if (right & left) NS = S_IDLE;
				else if (attack) NS = S_BASIC_ATTACK_START;
				else if (left) NS = S_BACKWARD;
				else if (right) NS = S_FORWARD;
				else NS = S_IDLE;
		  end

		  S_FORWARD: begin
				if (attack & right & left) NS = S_BASIC_ATTACK_START;
				else if (attack & right) NS = S_DIR_ATTACK_START;
				else if (attack & left) NS = S_DIR_ATTACK_START;
				else if (right & left) NS = S_IDLE;
				else if (attack) NS = S_BASIC_ATTACK_START;
				else if (left) NS = S_BACKWARD;
				else if (right) NS = S_FORWARD;
				else NS = S_IDLE;
		  end

		  S_BASIC_ATTACK_START: begin
				if (frame_count < S_BASIC_ATTACK_START_FRAME) NS = S_BASIC_ATTACK_START;
				else if (frame_count == S_BASIC_ATTACK_START_FRAME) NS = S_BASIC_ATTACK_ACTIVE;
		  end

		  S_BASIC_ATTACK_ACTIVE: begin
				if (frame_count < S_BASIC_ATTACK_ACTIVE_FRAME) NS = S_BASIC_ATTACK_ACTIVE;
				else if (frame_count == S_BASIC_ATTACK_ACTIVE_FRAME) NS = S_BASIC_ATTACK_REC;
		  end
		  
		  S_BASIC_ATTACK_REC: begin
				if (frame_count < S_BASIC_ATTACK_REC_FRAME) NS = S_BASIC_ATTACK_REC;
				else if (frame_count == S_BASIC_ATTACK_REC_FRAME) begin
					if (attack & right & left) NS = S_BASIC_ATTACK_START;
					else if (attack & right) NS = S_DIR_ATTACK_START;
					else if (attack & left) NS = S_DIR_ATTACK_START;
					else if (right & left) NS = S_IDLE;
					else if (attack) NS = S_BASIC_ATTACK_START;
					else if (left) NS = S_BACKWARD;
					else if (right) NS = S_FORWARD;
					else NS = S_IDLE;
				end
		  end
		  
		  S_DIR_ATTACK_START: begin
				if (frame_count < S_DIR_ATTACK_START_FRAME) NS = S_DIR_ATTACK_START;
				else if (frame_count == S_DIR_ATTACK_START_FRAME) NS = S_DIR_ATTACK_ACTIVE;
		  end

		  S_DIR_ATTACK_ACTIVE: begin
				if (frame_count < S_DIR_ATTACK_ACTIVE_FRAME) NS = S_DIR_ATTACK_ACTIVE;
				else if (frame_count == S_DIR_ATTACK_ACTIVE_FRAME) NS = S_DIR_ATTACK_REC;
		  end
		  S_DIR_ATTACK_REC: begin
				if (frame_count < S_DIR_ATTACK_REC_FRAME) NS = S_DIR_ATTACK_REC;
				else if (frame_count == S_DIR_ATTACK_REC_FRAME) begin
					if (attack & right & left) NS = S_BASIC_ATTACK_START;
					else if (attack & right) NS = S_DIR_ATTACK_START;
					else if (attack & left) NS = S_DIR_ATTACK_START;
					else if (right & left) NS = S_IDLE;
					else if (attack) NS = S_BASIC_ATTACK_START;
					else if (left) NS = S_BACKWARD;
					else if (right) NS = S_FORWARD;
					else NS = S_IDLE; 
				end
		  end
		  
		  S_HIT_STUN: begin
				if (frame_count < State_Frame_Holder) NS = S_HIT_STUN;
				else if (frame_count == State_Frame_Holder) begin
					if (attack & right & left) NS = S_BASIC_ATTACK_START;
					else if (attack & right) NS = S_DIR_ATTACK_START;
					else if (attack & left) NS = S_DIR_ATTACK_START;
					else if (right & left) NS = S_IDLE;
					else if (attack) NS = S_BASIC_ATTACK_START;
					else if (left) NS = S_BACKWARD;
					else if (right) NS = S_FORWARD;
					else NS = S_IDLE; 
				end
		  end
		  
		  S_BLOCK_STUN: begin
				if (frame_count < State_Frame_Holder) NS = S_BLOCK_STUN;
				else if (frame_count == State_Frame_Holder)  begin
					if (attack & right & left) NS = S_BASIC_ATTACK_START;
					else if (attack & right) NS = S_DIR_ATTACK_START;
					else if (attack & left) NS = S_DIR_ATTACK_START;
					else if (right & left) NS = S_IDLE;
					else if (attack) NS = S_BASIC_ATTACK_START;
					else if (left) NS = S_BACKWARD;
					else if (right) NS = S_FORWARD;
					else NS = S_IDLE; 
				end	
		  end

		  default: NS = S_IDLE;
		endcase
	end
end

always @(posedge clk) begin
    if (reset_n) begin
        lives <= 2'd3;
        blocks <= 2'd3;
        died <= 1'b0;
    end
    else begin
        // Update lives and blocks when transitioning to damage states
        if ((NS == S_BLOCK_STUN) && (NS != P_Current_State) && (blocks != 0)) begin
            blocks <= blocks - 1;
        end
        else if ((NS == S_HIT_STUN) && (NS != P_Current_State) && (lives != 0)) begin
            lives <= lives - 1;
        end
        
        // Update died status
        if (lives == 2'b0) 
            died <= 1'b1;
        else 
            died <= 1'b0;
    end
end

always @(posedge clk ) begin
    if (reset_n) begin
        P_Current_State = S_IDLE;
        frame_count = 5'b0;
    end
	 else begin
	 if (P_Current_State != NS) frame_count = 0; 
	 frame_count = frame_count + 1'b1;
	 P_Current_State = NS;
	 end
end


endmodule