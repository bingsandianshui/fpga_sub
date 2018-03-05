/**

软件的通道0 存储的是硬件通道3(第四路)的数据

**/
module LTC1744_T01(Clk,Rst_n,data_in,FST3253,OE_n,ENC_P,ENC_N,data_out0,data_out1,data_out2,data_out3,one_turn);

	input Clk;
	input Rst_n;
	input [15:0] data_in;
	
	output reg [1:0]FST3253;
	output reg OE_n;
	
	output reg ENC_P;		
	output reg ENC_N;	
	output reg [15:0] data_out0;	
	output reg [15:0] data_out1;	
	output reg [15:0] data_out2;	
	output reg [15:0] data_out3;	
	output reg one_turn;		//4 channels one turn finish
	
	reg[13:0]counter;				//200M-5ns
	parameter Samp_Time = 99;	//sample time (n+1)*5 ns. n is best selected for (12-1) multi 		399			99 			49			23
	parameter Samp_Up = 49;		//sample up time ns 20/60=1/3										199 ADC500k 49 adc2M 	24 ADC4M	11 adc8m
	
	reg [1:0] cnt_one_turn_delay;
	reg en_cnt_one_turn;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		counter <= 14'b0;
	end
	else if(counter < Samp_Time)
		counter <= counter + 1'b1;
	else 
		counter <= 14'b0;
	
	//LTC1746
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		ENC_P <= 1'b0;
		ENC_N <= 1'b1;
	end
	else begin
		case(counter)
			Samp_Up:begin
				ENC_P <= 1'b1;
				ENC_N <= 1'b0;
			end
		
			Samp_Time:begin
				ENC_P <= 1'b0;
				ENC_N <= 1'b1;
			end
		endcase
	end
	
	//Sample
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		data_out0 <= 15'b0;
		data_out1 <= 15'b0;
		data_out2 <= 15'b0;
		data_out3 <= 15'b0;
	end
	else begin
		if(counter == Samp_Time)begin
			case(FST3253)
				2'b00:data_out0 <= data_in;
				2'b01:data_out1 <= data_in;	//hard ware channel 1
				2'b10:data_out2 <= data_in;	//hard ware channel 2
				2'b11:data_out3 <= data_in;	//hard ware channel 3
			endcase
		end
	end
	
	//FST3253
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		FST3253 <= 2'b11;
		OE_n <= 1'b1;	//close
		en_cnt_one_turn <= 1'b0;
	end
	else begin
		case(counter)	
			2:begin				//5ns open fst3253
				OE_n <= 1'b0;
			end
			Samp_Time:begin
				if(FST3253 < 2'b11)begin
					FST3253 <= FST3253 + 1'b1;
				end
				else begin
					FST3253 <= 2'b0;
					en_cnt_one_turn <= 1'b1;	//one turn finish
				end				
			end
			Samp_Time-3:begin
				OE_n <= 1'b1;	//close
				en_cnt_one_turn <= 1'b0;
			end
		endcase
	end

	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_one_turn_delay <= 2'd0;
		else begin
			if (en_cnt_one_turn == 1'b1 && cnt_one_turn_delay != 3)
				cnt_one_turn_delay <= cnt_one_turn_delay + 1'b1;
			else if(en_cnt_one_turn == 1'b0 )
				cnt_one_turn_delay <= 0;
		end // else
	end // always
	
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			one_turn <= 0;
		else begin
			if (cnt_one_turn_delay == 3)
				one_turn <= 1;
			else if(cnt_one_turn_delay == 0)
				one_turn <= 0;
		end // else
	end // always
	
	
endmodule
