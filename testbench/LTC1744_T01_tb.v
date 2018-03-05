`timescale 1ns/1ns
`define clk_period 20

module LTC1744_T01_tb;
	
	reg Clk;
	reg Rst_n;
	reg [15:0] data0;
	integer i;
	integer j;
	
	wire [1:0]FST3253_0;
	wire FST3253_OEN_0;
	wire  ENC_P_0;		//F2
	wire  ENC_N_0;		//D1

	wire led;
	wire Cs_n;
	wire Clk_out;
	wire MOSI;

	
/*
	LTC1744_T01_TOP LTC1744_T01_TOP_01(
	.Clk(Clk),
	.Rst_n(Rst_n),
	.data(data),
	.FST3253(FST3253),
	.ENC_P(ENC_P),
	.ENC_N(ENC_N),
	.data_temp_4(data_temp_3)
	);
*/	
	
	// test adc
	/*LTC1744_T01 LTC1744_T01_00(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data0),
	 .FST3253(FST3253_0),
	 .OE_n(FST3253_OEN_0),
	 .ENC_P(ENC_P_0),
	 .ENC_N(ENC_N_0),
	 .data_out0(data_out_0),
	 .data_out1(data_out_1),
	 .data_out2(data_out_2),
	 .data_out3(data_out_3),
	 .one_turn(one_turn0)
	);*/

	//test top 
	LTC1744_T01_TOP LTC1744_T01_TOP1(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.data0(data0),
		.FST3253_0(FST3253_0),
		.FST3253_OEN_0(FST3253_OEN_0),
		.ENC_P_0(ENC_P_0),
		.ENC_N_0(ENC_N_0),
		.OF_0(),
		.led(led),
		.Cs_n(Cs_n),
		.Clk_out(Clk_out),
		.MOSI(MOSI)
	);
	//test find_start
	/*find_start find_start(
		.Clk(Clk_200),
		.Rst_n(Rst_n),
		.data_in0(data0),
		.find_ok(one_turn0)
	);*/
	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		//复位初始化
		Rst_n = 1'b0;
		data0=0;
		#(`clk_period*100+1);
		Rst_n = 1'b1;
		#(`clk_period*10);
		data0 = 19;
		#(`clk_period*25);
		data0 = 40;
		#(`clk_period*25);
		for(i=2;i<200;i=i+1)begin
			data0 = 5900 + i;
			#(`clk_period*25);
		end
		data0 = 20;
		#(`clk_period*25);
		data0 = 40;
		#(`clk_period*25);
		for(j=1;j<260;j=j+1)begin
				for(i=2;i<200;i=i+1)begin
					data0 = 5900 + i;
					#(`clk_period*25);
				end
				for(i=2;i<200;i=i+1)begin
					data0 = 5900 + i;
					#(`clk_period*25);
				end
				for(i=2;i<200;i=i+1)begin
					data0 = 5900 + i;
					#(`clk_period*25);
				end
				for(i=2;i<200;i=i+1)begin
					data0 = 5900 + i;
					#(`clk_period*25);
				end
		end
		$stop;
	end

endmodule
