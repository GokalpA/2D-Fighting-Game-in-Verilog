module button_debouncer(
    input clock,   
    input buttons_in, 
	 output reg buttons_debounced
);
reg [6:0] counter = 0;
reg stable = 0;

 always @(posedge clock) begin
	  buttons_debounced <= stable;
	  if (buttons_in != stable ) begin
			if (counter == 7'd10) begin
				 stable <= buttons_in;
				 counter <= 0;
			end
			else begin
				 stable <= buttons_in;
				 counter <= counter + 1;
			end
	  end else begin
			counter <= 0;
	  end
 end
endmodule