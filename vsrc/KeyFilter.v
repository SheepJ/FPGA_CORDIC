//
//模块：按键消抖模块
//key_state：输出消抖之后按键的状态
//key_flag：按键消抖结束时产生一个时钟周期的高电平脉冲
//
module KeyFilter(
	input clk,
	input rst_n,
	input key_in,
	output reg key_flag,
	output reg key_state
);

	//按键的四个状态
	localparam
		IDLE 		= 4'b0001,
		FILTER1 	= 4'b0010,
		DOWN 		= 4'b0100,
		FILTER2 	= 4'b1000;

	//状态寄存器
	reg [3:0] curr_st;
	
	//边沿检测输出上升沿或下降沿
	wire pedge;
	wire nedge;
	
	//计数寄存器
	reg [19:0]cnt;
	
	//使能计数寄存器
	reg en_cnt;
	
	//计数满标志信号
	reg cnt_full;//计数满寄存器
	
//------<边沿检测电路的实现>------
	//边沿检测电路寄存器
	reg key_tmp0;
	reg key_tmp1;
	
	//边沿检测
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			key_tmp0 <= 1'b0;
			key_tmp1 <= 1'b0;
		end
		else begin
			key_tmp0 <= key_in;
			key_tmp1 <= key_tmp0;
		end	
	end
		
	assign nedge = (!key_tmp0) & (key_tmp1);
	assign pedge = (key_tmp0)  & (!key_tmp1);

//------<状态机主程序>------	
	//状态机主程序
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			curr_st <= IDLE;
			en_cnt <= 1'b0;
			key_flag <= 1'b0;
			key_state <= 1'b1;
		end
		else begin
			case(curr_st)
				IDLE:begin
					key_flag <= 1'b0;
					if(nedge)begin
						curr_st <= FILTER1;
						en_cnt <= 1'b1;
					end
					else
						curr_st <= IDLE;
				end
				
				FILTER1:begin
					if(cnt_full)begin
						key_flag <= 1'b1;
						key_state <= 1'b0;
						curr_st <= DOWN;
						en_cnt <= 1'b0;
					end	
					else if(pedge)begin
						curr_st <= IDLE;
						en_cnt <= 1'b0;
					end
					else
						curr_st <= FILTER1;
				end
				
				DOWN:begin
					key_flag <= 1'b0;
					if(pedge)begin
						curr_st <= FILTER2;
						en_cnt <= 1'b1;
					end
					else
						curr_st <= DOWN;
				end
				
				FILTER2:begin
					if(cnt_full)begin
						key_flag <= 1'b1;
						key_state <= 1'b1;
						curr_st <= IDLE;
						en_cnt <= 1'b0;
					end	
					else if(nedge)begin
						curr_st <= DOWN;
						en_cnt <= 1'b0;
					end
					else
						curr_st <= FILTER2;
				end
				
				default:begin
					curr_st <= IDLE;
					en_cnt <= 1'b0;
					key_flag <= 1'b0;
					key_state <= 1'b1;
				end
			endcase
		end
	end
	
//------<20ms计数器>------		
	//20ms计数器
	//clk 50_000_000Hz
	//一个时钟周期为20ns
	//需要计数20_000_000 / 20 = 1_000_000次
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 20'd0;
		else if(en_cnt)
			cnt <= cnt + 1'b1;
		else
			cnt <= 20'd0;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_full <= 1'b0;
		else if(cnt == 999_999)
			cnt_full <= 1'b1;
		else
			cnt_full <= 1'b0;
	end
	
endmodule

