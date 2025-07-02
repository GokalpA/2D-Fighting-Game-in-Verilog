module kontrol(
    input clk,
    inout [4:0] GPIO,  // 5 pins: 4 buttons + 1 common
    output reg [3:0] buttons
);

// Internal signals
reg [3:0] button_sync [1:0];  // Two-stage synchronizer
reg [3:0] button_debounced;
reg [19:0] debounce_counter;  // 20-bit counter for debouncing
reg [3:0] button_stable;

// GPIO pin assignments based on DE1-SoC GPIO_0 connector pinout (odd pins):
// GPIO[0] = Physical Pin 1 (GPIO_0_D0) = Button 1
// GPIO[1] = Physical Pin 3 (GPIO_0_D2) = Button 2  
// GPIO[2] = Physical Pin 5 (GPIO_0_D4) = Button 3
// GPIO[3] = Physical Pin 7 (GPIO_0_D6) = Button 4
// GPIO[4] = Physical Pin 9 (GPIO_0_D8) = Common (connect to ground)

// Set common pin as output (ground)
assign GPIO[4] = 1'b0;

// Set button pins as inputs with internal pull-ups
// The buttons will pull the pins low when pressed
assign GPIO[3:0] = 4'bzzzz;  // High impedance (input mode)

/*
// Two-stage synchronizer to prevent metastability
always @(posedge clk) begin
    button_sync[0] <= ~GPIO[3:0];  // Invert because buttons are active low
    button_sync[1] <= button_sync[0];
end

// Debouncing logic
always @(posedge clk) begin
    if (button_sync[1] != button_stable) begin
        debounce_counter <= 0;
        button_stable <= button_sync[1];
    end else if (debounce_counter < 20'd1000000) begin  // ~20ms at 50MHz
        debounce_counter <= debounce_counter + 1;
    end else begin
        button_debounced <= button_stable;
    end
end

// Output assignment
always @(posedge clk) begin
    buttons <= button_debounced;
end
*/

always @(*) begin
	buttons = ~GPIO[3:0];

end

endmodule