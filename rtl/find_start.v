module find_start(Clk,Rst_n,data_in0,Samp_en);
	input Clk;				//200M
	input Rst_n;
	input [15:0]data_in0;	//input data, z axis data is best

	output reg Samp_en;		//if detect a pulse wave, the output Samp_en, high level is effect

	reg find_ok;

	reg [15:0]data_0;	//new
	reg [15:0]data_1;
	reg [15:0]data_2;
	reg [15:0]data_3;	//old

	parameter threshold = 2000;
	parameter counts = 65200;	//after find_start_ok, delay 65200*5s=326us to sample_en
	reg [19:0] counter;

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		data_0 <= 0;
		data_1 <= 0;
		data_2 <= 0;
		data_3 <= 0;
	end
	else if(~find_ok) begin
		data_0 <= data_in0;
		data_1 <= data_0;
		data_2 <= data_1;
		data_3 <= data_2;
	end else begin
		data_0 <= data_0;
		data_1 <= data_1;
		data_2 <= data_2;
		data_3 <= data_3;
	end

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		find_ok <= 1'b0;
	end
	else if(~find_ok) begin
		if (data_3 < data_0 && data_3 < data_1 && data_3 < data_2 && data_0 > threshold)begin
			find_ok <= 1'b1;
		end
	end
	else begin
		find_ok <= find_ok;
	end

	//delay 163 points (326us), than sample en
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			counter <= 20'd0;
		else begin
			if (find_ok == 1 && Samp_en == 0)begin
				if(counter == counts-1)
					counter <= 20'd0;
				else 
					counter <= counter + 1'b1;			
			end // 
			else 
				counter <= counter;				
		end // else
	end // always

	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			Samp_en <= 1'b0;
		else begin
			if (counter == counts-1)
				Samp_en <= 1'b1;
			else
				Samp_en <= Samp_en;
				
		end // else
	end // always
	
	
endmodule
