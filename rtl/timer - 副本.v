module timer(Clk,Rst_n,one_turn,Samp_en,data_in0,data_in1,data_in2,data_in3,data_out);

	input Clk;
	input Rst_n;
	input one_turn;
	input Samp_en;
	

	input [13:0]data_in0;
	input [13:0]data_in1;
	input [13:0]data_in2;
	input [13:0]data_in3;

	output [13:0]data_out;

	parameter pulse_w = 72000;		//pulse width 360us->180points
	parameter period = 20000000;	//0.1hz 28bit

	reg one_turn0;
	reg one_turn1;
	reg posedge_one_turn;			//1:finish one turn(4 channels) and now is start of this turn

	reg [1:0] fst3253;

	reg [27:0]counter;
	reg [13:0]data_temp;
	reg data_write;		//store data require
	reg data_read;		//read data require

	reg sotre_4point;	//finish stor 4point or one turn for 4 channels 1:start store 0:finish or stop store
	
	//finish one turn(4 channels) and now is start of this turn
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		one_turn0 <= 1'b0;
		one_turn1 <= 1'b0;
	end
	else begin
		one_turn0 <= one_turn;
		one_turn1 <= one_turn0;
		posedge_one_turn <= (one_turn0 ^ one_turn1 == 1?1:0) && (one_turn0 == 1);
	end

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		counter <= 28'b0;
	end
	else if(Samp_en && counter < period)begin
		counter <= counter + 1'b1;
	end
	else begin
		counter <= 28'b0;
	end
	//if one turn(4points) store is finish
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		sotre_4point <= 1'b0;
	end
	//start store
	else if(posedge_one_turn && Samp_en && counter < pulse_w)begin
		sotre_4point <= 1'b1;
	end
	//stop store
	else if(fst3253 == 2'b11)begin
		sotre_4point <= 1'b0;
	end

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		data_write <= 1'b0;
		fst3253 <= 2'b0;
	end
	else if(counter < pulse_w && Samp_en && sotre_4point)begin
		data_write <= 1'b1;
		if(fst3253<2'b11)begin
			fst3253 <= fst3253 + 1'b1;
		end else begin
			fst3253 <= 2'b0;
		end
	end else begin
		data_write <= 1'b0;
		fst3253 <= 2'b0;
	end
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
			data_temp <= 14'b0;
	end
	else if(sotre_4point) begin
		case (fst3253)
			2'b00:data_temp <= data_in0;
			2'b01:data_temp <= data_in1;
			2'b10:data_temp <= data_in2;
			2'b11:data_temp <= data_in3;
		endcase
	end
	else begin
		data_temp <= 14'b0;
	end


	dpram dpram0(
		.clock(Clk),
		.data(data_temp),
		.rdreq(data_read),
		.wrreq(data_write),
		.empty(),
		.full(),
		.q(data_out),
		.usedw()
	);

	//send data to uart
endmodule