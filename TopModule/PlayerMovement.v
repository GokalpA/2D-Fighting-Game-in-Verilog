module PlayerMovement (
	input wire [3:0] Player1NS,
	input wire [3:0] Player2NS,
	input wire 		  clk,
    input wire reset_n,
	output wire[9:0] Player1LocationsXO,
	output wire[9:0] Player2LocationsXO
	
);
localparam
charW 		 = 7'd64,
charh 		 = 9'd240,
mapW = 10'd640;

localparam
FWDAmount 	 = 2'd3,
BWDAmount 	 = 2'd2;

localparam
S_FORWARD    = 4'd1,
S_BACKWARD   = 4'd2,
S_ATTACK = 4'd3,
S_ATTACK_ACTIVE = 4'd4,
S_ATTACK_RECOVERY 	 = 4'd5,
S_DIR_ATTACK  	 = 4'd6,
S_DIR_ATTACK_ACTIVE 	 = 4'd7,
S_DIR_ATTACK_RECOVERY = 4'd8;

reg [9:0] Player1LocationsX = charW;
reg [9:0] NextPlayer1LocationsX = charW;
reg [9:0] Player2LocationsX = mapW - charW;
reg [9:0] NextPlayer2LocationsX = mapW - charW;

always @(*) begin
case (Player1NS)
	S_FORWARD: begin
		if (Player1LocationsX + charW < Player2LocationsX - 1'b1 - charW) begin // boundries are chosen from debugging on vga screen
			NextPlayer1LocationsX = Player1LocationsX + FWDAmount;
		end
		else begin
			NextPlayer1LocationsX = Player1LocationsX;
		end
	end
	
	S_BACKWARD: begin
		if (Player1LocationsX < BWDAmount + 1'b1 + charW) begin
			NextPlayer1LocationsX = Player1LocationsX;
		end
		else NextPlayer1LocationsX = Player1LocationsX - BWDAmount;
	end
	default: NextPlayer1LocationsX = Player1LocationsX;
	
endcase
case (Player2NS)
	S_FORWARD: begin
		if (Player1LocationsX + charW < Player2LocationsX - charW - 1'b1 -FWDAmount) begin // boundries are chosen from debugging on vga screen
			NextPlayer2LocationsX = Player2LocationsX - FWDAmount;
		end
		else begin
			NextPlayer2LocationsX = Player2LocationsX;
		end
	end
	
	S_BACKWARD: begin
		if (Player2LocationsX + charW > mapW - 1'b1 - BWDAmount) begin // boundries are chosen from debugging on vga screen
			NextPlayer2LocationsX = Player2LocationsX;
		end
		else NextPlayer2LocationsX = Player2LocationsX + BWDAmount;
	end
	default: NextPlayer2LocationsX = Player2LocationsX;
endcase
end

always @(posedge clk) begin
	if (reset_n) begin
		Player1LocationsX <= charW;
		Player2LocationsX <= mapW - charW;
	end
	else begin
		Player1LocationsX <= NextPlayer1LocationsX;
		Player2LocationsX <= NextPlayer2LocationsX;
	end
end

assign Player1LocationsXO = Player1LocationsX;
assign Player2LocationsXO = Player2LocationsX;

endmodule