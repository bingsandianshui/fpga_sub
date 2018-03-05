// send 4330 bytes (4330*8=34640 bits) per frame
// send speed
//7a00  7a21  7a02

module spi_master(Clk200M, Rst_n, start_send, set_speed, data0, data1, data2, Cs_n, Clk_out, MOSI, finish_n, rdreq0, rdreq1, rdreq2);
	input Clk200M; 
	input Rst_n; 
	input start_send;			// pulse
	input [2:0] set_speed;
	input [15:0] data0;
	input [15:0] data1;
	input [15:0] data2;

	output reg Cs_n; 
	output reg Clk_out; 
	output reg MOSI; 
	output reg finish_n; 		//level

	output reg rdreq0;
	output reg rdreq1;
	output reg rdreq2;

	reg [15:0] cnt_Cs_n_35us;
	parameter cnt_Cs_n_35us_max = 7000;
	wire add_cnt_Cs_n_35us;
	wire end_cnt_Cs_n_35us;

	reg start_send_0;		//new
	reg start_send_1;		//old
	wire start_send_pose;

	//reg finish_n;

	reg [11:0] cnt_table_clk;
	reg [11:0] cnt_table_clk_max;
	reg [7:0]  cnt_table_clk_mid;
	wire add_cnt_tablk_clk;
	wire end_cnt_tablk_clk;

	reg flag_Clk_out;

	reg [4:0] cnt_send_bit;
	wire add_cnt_send_bit;
	wire end_cnt_send_bit;

	reg [11:0] cnt_send_words;	//2 bytes, 16bits
	parameter cnt_send_words_max = 2165;	//4330 bytes / 2 = 2165 words
	wire add_cnt_send_words;
	wire end_cnt_send_words;

	reg [15:0] data_temp;	//

	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)begin	
			cnt_table_clk_mid <= 0;
			cnt_table_clk_max <= 0;
		end
		else begin
			case(set_speed)
			3'd0:begin cnt_table_clk_mid <= 200;	cnt_table_clk_max <= 400; end//400;	//0.5M
			3'd1:begin cnt_table_clk_mid <= 50; 	cnt_table_clk_max <= 100; end//100;	//1M
			3'd2:begin cnt_table_clk_mid <= 25;		cnt_table_clk_max <= 50; end//50;		//4M
			3'd3:begin cnt_table_clk_mid <= 12;		cnt_table_clk_max <= 24; end//24;		//8.33M
			3'd4:begin cnt_table_clk_mid <= 8;		cnt_table_clk_max <= 16; end//16;		//12.5M
			3'd5:begin cnt_table_clk_mid <= 6;		cnt_table_clk_max <= 12; end//12;		//16.67M
			3'd6:begin cnt_table_clk_mid <= 5;		cnt_table_clk_max <= 10; end//10;		//20M			//suggest
			3'd7:begin cnt_table_clk_mid <= 4;		cnt_table_clk_max <= 8; end//8;		//25M
			default:begin cnt_table_clk_mid <=5; 	cnt_table_clk_max <= 10; end
			endcase
		end // else
	end // always

	//start_send_pose
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)begin		
			start_send_0 <= 0;
			start_send_1 <= 0;
		end
		else begin
			start_send_0 <= start_send;
			start_send_1 <= start_send_0;
		end
	end // always
	assign start_send_pose = start_send_0 && (!start_send_1);
	

	//finish_n,  during sending
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			finish_n <= 0;
		else if(start_send_pose == 1)
			finish_n <= 1;
		else if(cnt_send_words == cnt_send_words_max - 1) 
			finish_n <= 0;
	end

	//Cs_n
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			Cs_n <= 1;
		else if(start_send_pose == 1)
			Cs_n <= 0;
		else if(finish_n == 0) 	 //缺少停止条件
			Cs_n <= 1;
	end

	//Cs_n  35us
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_Cs_n_35us <= 0;
		else if(add_cnt_Cs_n_35us)
			if (end_cnt_Cs_n_35us)
				cnt_Cs_n_35us <= 0;
			else
				cnt_Cs_n_35us <= cnt_Cs_n_35us + 1'b1;
	end // always
	assign add_cnt_Cs_n_35us = Cs_n == 0;
	assign end_cnt_Cs_n_35us = (Cs_n == 0) && (cnt_Cs_n_35us == cnt_Cs_n_35us_max - 1) || flag_Clk_out == 1;
	
	//flag_Clk_out already 35us after cs_n goes down
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			flag_Clk_out <= 0;
		else if(Cs_n == 0)begin
			if(end_cnt_Cs_n_35us) begin
				flag_Clk_out <= 1;
			end // else
		end
		else 		//缺少结束条件
			flag_Clk_out <= 0;
	end // always
	
	//cnt_table_clk ,
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_table_clk <= 0;
		else if(Cs_n == 0)begin
			if(add_cnt_tablk_clk)begin
				if (end_cnt_tablk_clk)
					cnt_table_clk <= 0;
				else
					cnt_table_clk <= cnt_table_clk + 1'b1;
			end
			end
		else
			cnt_table_clk <= 0;
	end // always
	assign add_cnt_tablk_clk = flag_Clk_out == 1;
	assign end_cnt_tablk_clk = (flag_Clk_out == 1) && (cnt_table_clk == cnt_table_clk_max - 1);
	
	//clk_out
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			Clk_out <= 1;
		else if (flag_Clk_out == 1) begin
			if((cnt_table_clk == cnt_table_clk_max-1) || (cnt_table_clk == cnt_table_clk_mid-1))
				Clk_out <= !Clk_out;
		end // else
		else 		//缺少结束条件
			Clk_out <= 1;
	end // always
	
	//cnt_send_bit , max 0-15
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_send_bit <= 0;
		else if(Cs_n == 0)begin
			if(add_cnt_send_bit)begin
				if (end_cnt_send_bit)
					cnt_send_bit <= 0;
				else
					cnt_send_bit <= cnt_send_bit + 1'b1;
			end
		end
		else
			cnt_send_bit <= 0;
	end // always
	assign add_cnt_send_bit = (flag_Clk_out == 1) && (cnt_table_clk == cnt_table_clk_max - 1);
	assign end_cnt_send_bit = (flag_Clk_out == 1) && (cnt_send_bit == (16 - 1));

	//cnt_send_words , max 2165
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_send_words <= 4095;
		else if(Cs_n == 0)begin
			if(add_cnt_send_words)begin
				if (end_cnt_send_words)
					cnt_send_words <= 0;
				else
					cnt_send_words <= cnt_send_words + 1'b1;
			end
		end
		else
			cnt_send_words <= 4095;
	end // always
	assign add_cnt_send_words = (flag_Clk_out == 1) && (cnt_send_bit == 15) && (end_cnt_tablk_clk == 1);
	assign end_cnt_send_words = (flag_Clk_out == 1) && (cnt_send_words == cnt_send_words_max);




	//  data_temp
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			data_temp <= 16'h7a63;		//start frame
		else if(cnt_send_words == 4095)
			data_temp <= 16'h7a63;		//start frame
		else if(cnt_send_words == 2163)
			data_temp <= 16'h7a68;		//end frame
		else if(cnt_send_words == 0 || cnt_send_words < 721) 
			data_temp <= data0;
		else if(cnt_send_words > 720 && cnt_send_words < 1442)
			data_temp <= data1;
		else if(cnt_send_words > 1441 && cnt_send_words < 2163)
			data_temp <= data2;
	end // always

	//////////////  MOSI
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			MOSI <= 0;
		else if(flag_Clk_out) begin
			if (cnt_table_clk == cnt_table_clk_mid-1)
				MOSI <= data_temp[15 - cnt_send_bit];
		end // else
		else
			MOSI <= 0;
	end // always

	//////////////////  rdreq0
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			rdreq0 <= 0;
		else if( cnt_send_words == 4095 || cnt_send_words < 720) begin //0-721 is adc0
			if (add_cnt_send_words && cnt_send_bit == 15)
				rdreq0 <= 1;
			else
				rdreq0 <= 0;
		end // else
		else
			rdreq0 <= 0;
	end // always	

	//////////////////  rdreq1
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			rdreq1 <= 0;
		else if(cnt_send_words > 719 && cnt_send_words < 1441) begin //0-721 is adc0
			if (add_cnt_send_words && cnt_send_bit == 15)
				rdreq1<= 1;
			else
				rdreq1 <= 0;
		end // else
		else
			rdreq1 <= 0;
	end // always	

	//////////////////  rdreq2
	always @(posedge Clk200M or negedge Rst_n) begin
		if (!Rst_n)		
			rdreq2 <= 0;
		else if(cnt_send_words > 1440 && cnt_send_words < 2162) begin //0-721 is adc0
			if (add_cnt_send_words && cnt_send_bit == 15)
				rdreq2 <= 1;
			else
				rdreq2 <= 0;
		end // else
		else
			rdreq2 <= 0;
	end // always	

endmodule