module timer(Clk,Rst_n,one_turn,Samp_en,data_in0,data_in1,data_in2,data_in3, wrreq_fifo, data_out, start_send);

	input Clk;			//200M
	input Rst_n;
	input one_turn;		//4 channels one turn finish
	input Samp_en;		//after 99640us, 180 points store start, 
	

	input [15:0] data_in0;
	input [15:0] data_in1;
	input [15:0] data_in2;
	input [15:0] data_in3;

	output reg wrreq_fifo;
	output reg [15:0] data_out;
	output reg start_send;

	parameter pulse_w = 72000;		//pulse width 360us->180points
	parameter period = 20000000;	//0.1hz 28bit

	//******************************	store data to fifo
	reg start_store;				//start store effect data at one_turn_count_samp = 49820 point; high level; start 180 points
	reg start_store0;
	reg start_store1;
	wire start_store_nege;

	reg [7:0] store_point;			//the number of store_points, 180 max(0-179)

	reg [11:0] cnt_2M;				//2M frequency cnt 1;99;199;299; store one turn 4 channels
	parameter cnt_2M_max = 400;		//100*5ns
	reg one_turn_0;					//	new	delay 3 clk200M to get stable data		
	reg one_turn_1;
	reg one_turn_2;				//	old
	wire one_turn_posedge;			//  posedge of one_turn, count the one_turn_posedge!!!!

	reg [15:0] one_turn_count;		//0.1s is 50000 points(2us per point)one_turn_posedge
	parameter one_turn_count_max = 50000;	//50000 max 50000 points
	parameter one_turn_count_samp = 49820;	//49820 store from 49820 to 50000 point (store 180 points)
	parameter points = 8'd180;

	reg [11:0] cnt_totalpoint;		//180*4 = 720 points total
	parameter totalpoint = 720;

	reg [11:0] address;				//ram address 0-719
	parameter address_max = 720;	//max ram address 180 points * 4 channel = 720
	reg [15:0] wdata_temp;			//ram write data temp
	
	reg [1:0] cnt_store_4point;		//store 4points ont turn cnt 0 1 2 3
	reg en_store_4point;			//en store 4 points, high level effect

	reg [1:0] cnt_start_store;		//start_store delay delay200Mhz*2cycle

	reg Samp_en_0;
	reg Samp_en_1;
	wire Samp_en_pose;

	parameter frame_head = 16'd31232;	//7a00

	//Samp_en_pose
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)	begin	
			start_store0 <= 0;
			start_store1 <= 0;
		end
		else begin
			start_store0 <= start_store;
			start_store1 <= start_store0;
		end // else
	end // always
	assign start_store_nege = (!start_store0) && start_store1;

	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			start_send <= 0;
		else if(start_store_nege) begin
			start_send <= 1;
		end // else
		else
			start_send <= 0;
			
	end // always
	

	//Samp_en_pose
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)	begin	
			Samp_en_0 <= 0;
			Samp_en_1 <= 0;
		end
		else begin
			Samp_en_0 <= Samp_en;
			Samp_en_1 <= Samp_en_0;
		end // else
	end // always
	assign Samp_en_pose = Samp_en_0 && (!Samp_en_1);

	//delay 3 clk200M to get stable data
	assign one_turn_posedge = (!one_turn_2) && (one_turn_1);
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)	begin	
			one_turn_0 <= 1'b0;
			one_turn_1 <= 1'b0;
			one_turn_2 <= 1'b0;
		end
		else begin
			one_turn_0 <= one_turn;
			one_turn_1 <= one_turn_0;
			one_turn_2 <= one_turn_1;
		end // else
	end // always
	
	//one_turn_count one_turn_posedge
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			one_turn_count <= 16'd0;
		else if(Samp_en == 1) begin
			if(one_turn_count == one_turn_count_max-1)
				one_turn_count <= 16'd0;
			else if(one_turn_posedge == 1)
				one_turn_count <= one_turn_count + 1'b1;
		end // 
	end // always
	
	//start store 180 points, high level effect, 
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)	begin	
			start_store <= 1'b0;
		end
		else begin
			if(one_turn_count == 0 && cnt_store_4point == 3)
				start_store <= 1'b0;
			else if(cnt_start_store == 1)
				start_store <= 1'b1;
		end // else
	end // always

	//start store 180 points, high level effect, 
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)	begin	
			cnt_start_store <= 2'b0;
		end
		else begin
			case(one_turn_count)
				16'd0:
					cnt_start_store <= 2'b0;
				one_turn_count_samp - 1:begin
					if(cnt_start_store == 2)
						cnt_start_store <= cnt_start_store;
					else
						cnt_start_store <= cnt_start_store + 1'b1;
				end
				default:
					cnt_start_store <= cnt_start_store;
			endcase
		end // else
	end // always

	//calculate the store points max 180
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			store_point <= points - 1'b1;
		else if (start_store == 1 && one_turn_posedge == 1) begin
			if(store_point == points - 1'b1)
				store_point <= 8'd0;
			else
				store_point <= store_point + 1'b1;		
		end		 				
		else if(start_store == 0)	
			store_point <= points - 1'b1;
	end // always
	
	//cnt store 4 points
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			cnt_store_4point <= 2'd0;
		else if(start_store==1) begin
			if (en_store_4point)
				cnt_store_4point <= cnt_store_4point + 1'b1;
			else
				cnt_store_4point <= 0;				
		end // else
		else
			cnt_store_4point <= 0;
	end // always
	

	//en store 4 points; high level effect
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			en_store_4point <= 1'b0;
		else if(start_store == 1) begin
			if(one_turn_posedge)
				en_store_4point <= 1'b1;
			else if(cnt_store_4point == 2'd3)
				en_store_4point <= 1'b0;
		end // else
		else
			en_store_4point <= 0;			
	end // always
	
//	always @(posedge Clk or negedge Rst_n) begin
//		if (!Rst_n)		
//			address <= 0;
//		else if(start_store == 1 && wrreq_fifo == 1) begin
//			if (address == address_max - 1)
//				address <= 0;
//			else
//				address <= address + 1'b1;
//		end // else
//		else if(start_store == 0)
//			address <= 0;
//	end // always
//
	//wrreq_fifo en ram
	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			wrreq_fifo <= 0;
		else if(Samp_en_pose)
			wrreq_fifo <= 1;
		else if(start_store==1) begin
				if (en_store_4point)
					wrreq_fifo <= 1;
				else
					wrreq_fifo <= 0;				
			end // else
		else
			wrreq_fifo <= 0;
	end // always
	

	always @(posedge Clk or negedge Rst_n) begin
		if (!Rst_n)		
			data_out <= 16'd0;
		else if(Samp_en_pose)
			data_out <= frame_head;
		else if(start_store == 1) begin
			case(cnt_store_4point)
				0:begin data_out <=  data_in0; end
				1:begin data_out <=  data_in1; end
				2:begin data_out <=  data_in2; end
				3:begin data_out <=  data_in3; end
				default:begin data_out <=  0;   end
			endcase
		end // else
		else 
			data_out <= 0;
	end // always


	//******************************	send data from fifo to uart/spi
	//12.42

endmodule