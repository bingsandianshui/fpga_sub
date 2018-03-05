module led_control(Clk, Rst_n, led);
	input Clk;
	input Rst_n;
	
	output reg led;
	
	reg [23:0] counter;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		led <= 1'b1;
		counter <= 24'b0;
	end
	else begin
		if(counter < 2500000)	//10hz
			counter <= counter + 1'b1;
		else begin
			led <= ~led;
			counter <= 24'b0;
		end
	end
endmodule
