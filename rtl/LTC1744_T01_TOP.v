module LTC1744_T01_TOP(Clk,Rst_n,
data0,FST3253_0,FST3253_OEN_0,ENC_P_0,ENC_N_0,OF_0,
data1,FST3253_1,FST3253_OEN_1,ENC_P_1,ENC_N_1,OF_1,
data2,FST3253_2,FST3253_OEN_2,ENC_P_2,ENC_N_2,OF_2,
led,
Cs_n,
Clk_out,
MOSI,
finish_n_led
);

	input Clk;
	input Rst_n;
	input [15:0] data0;
	input [15:0] data1;
	input [15:0] data2;
	
	input OF_0;
	input OF_1;
	input OF_2;

	output [1:0]FST3253_0;	//fst3253 address
	output [1:0]FST3253_1;	//fst3253 address
	output [1:0]FST3253_2;	//fst3253 address

	output FST3253_OEN_0;
	output FST3253_OEN_1;
	output FST3253_OEN_2;

	output ENC_P_0;			//
	output ENC_N_0;			//

	output ENC_P_1;			//
	output ENC_N_1;			//

	output ENC_P_2;			//
	output ENC_N_2;			//
	
	output led;
	output Cs_n;
	output Clk_out;
	output MOSI;
	output finish_n_led;
		
	wire Clk_200;

	wire [15:0]data_out_0_0;
	wire [15:0]data_out_0_1;
	wire [15:0]data_out_0_2;
	wire [15:0]data_out_0_3;

	wire [15:0]data_out_1_0;
	wire [15:0]data_out_1_1;
	wire [15:0]data_out_1_2;
	wire [15:0]data_out_1_3;

	wire [15:0]data_out_2_0;
	wire [15:0]data_out_2_1;
	wire [15:0]data_out_2_2;
	wire [15:0]data_out_2_3;

	wire [15:0]data_q_0;
	wire [15:0]data_q_1;
	wire [15:0]data_q_2;

	wire Samp_en;
	wire one_turn0;
	wire wrreq_fifo0;
	wire [15:0] data_storein_fifo0;
	wire start_send;
	wire rdreq0;

	wire one_turn1;
	wire wrreq_fifo1;
	wire [15:0] data_storein_fifo1;
	wire rdreq1;

	wire one_turn2;
	wire wrreq_fifo2;
	wire [15:0] data_storein_fifo2;
	wire rdreq2;

	pll_200 pll_200_0(
	.inclk0(Clk),
	.c0(Clk_200)
	);
	//                            0
	LTC1744_T01 LTC1744_T01_00(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data0),
	 .FST3253(FST3253_0),
	 .OE_n(FST3253_OEN_0),
	 .ENC_P(ENC_P_0),
	 .ENC_N(ENC_N_0),
	 .data_out0(data_out_0_0),
	 .data_out1(data_out_0_1),
	 .data_out2(data_out_0_2),
	 .data_out3(data_out_0_3),
	 .one_turn(one_turn0)
	);
	find_start find_start_00(
		.Clk(Clk_200),
		.Rst_n(Rst_n),
		.data_in0(data_out_0_0),
		.Samp_en(Samp_en)
	);	
	timer timer0(
		.Clk(Clk_200),
		.Rst_n(Rst_n),
		.one_turn(one_turn0),
		.Samp_en(Samp_en),
		.data_in0(data_out_0_0),
		.data_in1(data_out_0_1),
		.data_in2(data_out_0_2),
		.data_in3(data_out_0_3),
		.wrreq_fifo(wrreq_fifo0), 
		.data_out(data_storein_fifo0), 
		.start_send(start_send)
	);
	dpram dpram0(
		.clock(Clk_200),
		.data(data_storein_fifo0),
		.rdreq(rdreq0),
		.wrreq(wrreq_fifo0),
		.empty(),
		.full(),
		.q(data_q_0)
	);

	//								1
	LTC1744_T01 LTC1744_T01_01(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data1),
	 .FST3253(FST3253_1),
	 .OE_n(FST3253_OEN_1),
	 .ENC_P(ENC_P_1),
	 .ENC_N(ENC_N_1),
	 .data_out0(data_out_1_0),
	 .data_out1(data_out_1_1),
	 .data_out2(data_out_1_2),
	 .data_out3(data_out_1_3),
	 .one_turn(one_turn1)
	);

	timer timer1(
		.Clk(Clk_200),
		.Rst_n(Rst_n),
		.one_turn(one_turn1),
		.Samp_en(Samp_en),
		.data_in0(data_out_1_0),
		.data_in1(data_out_1_1),
		.data_in2(data_out_1_2),
		.data_in3(data_out_1_3),
		.wrreq_fifo(wrreq_fifo1), 
		.data_out(data_storein_fifo1), 
		.start_send()
	);
	dpram dpram1(
		.clock(Clk_200),
		.data(data_storein_fifo1),
		.rdreq(rdreq1),
		.wrreq(wrreq_fifo1),
		.empty(),
		.full(),
		.q(data_q_1)
	);

	//									2
	LTC1744_T01 LTC1744_T01_02(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data2),
	 .FST3253(FST3253_2),
	 .OE_n(FST3253_OEN_2),
	 .ENC_P(ENC_P_2),
	 .ENC_N(ENC_N_2),
	 .data_out0(data_out_2_0),
	 .data_out1(data_out_2_1),
	 .data_out2(data_out_2_2),
	 .data_out3(data_out_2_3),
	 .one_turn(one_turn2)
	);

	timer timer2(
		.Clk(Clk_200),
		.Rst_n(Rst_n),
		.one_turn(one_turn2),
		.Samp_en(Samp_en),
		.data_in0(data_out_2_0),
		.data_in1(data_out_2_1),
		.data_in2(data_out_2_2),
		.data_in3(data_out_2_3),
		.wrreq_fifo(wrreq_fifo2), 
		.data_out(data_storein_fifo2), 
		.start_send()
	);
	dpram dpram2(
		.clock(Clk_200),
		.data(data_storein_fifo2),
		.rdreq(rdreq2),
		.wrreq(wrreq_fifo2),
		.empty(),
		.full(),
		.q(data_q_2)
	);



	spi_master spi_master0(
		.Clk200M(Clk_200), 
		.Rst_n(Rst_n), 
		.start_send(start_send), 
		.set_speed(3'd6), 
		.data0(data_q_0), 
		.data1(data_q_1), 
		.data2(data_q_2), 
		.Cs_n(Cs_n), 
		.Clk_out(Clk_out), 
		.MOSI(MOSI), 
		.finish_n(finish_n_led), 
		.rdreq0(rdreq0), 
		.rdreq1(rdreq1), 
		.rdreq2(rdreq2)
	);



	/*LTC1744_T01 LTC1744_T01_01(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data1),
	 .FST3253(FST3253_1),
	 .OE_n(FST3253_OEN_1),
	 .ENC_P(ENC_P_1),
	 .ENC_N(ENC_N_1),
	 .OF(OF_1)
	);	
	LTC1744_T01 LTC1744_T01_02(
	 .Clk(Clk_200),
	 .Rst_n(Rst_n),
	 .data_in(data2),
	 .FST3253(FST3253_2),
	 .OE_n(FST3253_OEN_2),
	 .ENC_P(ENC_P_2),
	 .ENC_N(ENC_N_2),
	 .OF(OF_2)
	);	
	*/
	led_control led_control01(
	.Clk(Clk), 
	.Rst_n(Rst_n), 
	.led(led)
	);
	
endmodule
