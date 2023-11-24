


module LCD_block(
	input			clk,
	input			rst_n,
	
	input  		lcd_on_in,
	input			lcd_blon_in,
	output      lcd_on_out,
	output		lcd_blon_out,
	
	input cos_sign,
	input sin_sign,
				
	input [3:0]cos_dec_one 			,
	input [3:0]cos_dec_two 			,
	input [3:0]cos_dec_thr 			,
	input [3:0]cos_dec_four 		,
	input [3:0]cos_dec_five 		,
	input [3:0]cos_dec_six 			,
	input [3:0]cos_dec_seven 		,
	input [3:0]cos_dec_eight 		,
	input [3:0]cos_dec_nine 		,
	input [3:0]cos_dec_ten 			,
	
	input [3:0]sin_dec_one 			,
	input [3:0]sin_dec_two 			,
	input [3:0]sin_dec_thr 			,
	input [3:0]sin_dec_four 		,
	input [3:0]sin_dec_five 		,
	input [3:0]sin_dec_six 			,
	input [3:0]sin_dec_seven 		,
	input [3:0]sin_dec_eight 		,
	input [3:0]sin_dec_nine 		,
	input [3:0]sin_dec_ten 			,
	
	
	
	
	input               	lcd_w_en_i  ,   //
	output	reg			lcd_rs		,   //状态or数据选择
	output	reg		   lcd_rw		,   //读or写选择
	output	reg			lcd_en		,   //使能信号
	output	reg	[7:0]	lcd_data,       //输出LCD指令
	
	output reg lcd_req
);

    reg	[7:0]	data_display;           //显示数据
    reg [5:0] data_cnt;                //数据计数器
    reg [3:0] state;                   //状态
	 reg wr_en_state;							//写入状态(lcd_en是否拉高)
	 
	assign lcd_on_out 	= lcd_on_in;	//lcd电源
	assign lcd_blon_out  = lcd_blon_in;	//lcd背光电源

	 
    
    parameter IDLE =4'd0;
    parameter S0   =4'd1;
    parameter S1   =4'd2;
    parameter S2   =4'd3;
    parameter S3   =4'd4;
    parameter S4   =4'd5;
    parameter Addr1=4'd6;
    parameter WR1  =4'd7;
    parameter Addr2=4'd8;
    parameter WR2  =4'd9;
    parameter stop =4'd10;
	 
	 
wire [7:0]cos_sign_data;
wire [7:0]sin_sign_data;
assign cos_sign_data = cos_sign? "-" : "+";
assign sin_sign_data = sin_sign? "-" : "+";
	 
    
 always @(*) begin//根据数据计数器输出显示数据
		case(data_cnt)
			5'd0: data_display   = cos_sign_data;
			5'd1: data_display   = "0";
			5'd2: data_display   = ".";
			5'd3: data_display   = cos_dec_one		+ "0";
			5'd4: data_display   = cos_dec_two 		+ "0";
			5'd5: data_display   = cos_dec_thr 		+ "0";
			5'd6: data_display   = cos_dec_four 	+ "0";
			5'd7: data_display   = cos_dec_five 	+ "0";
			5'd8: data_display   = cos_dec_six 		+ "0";
			5'd9: data_display   = cos_dec_seven	+ "0";
			5'd10: data_display  = cos_dec_eight	+ "0";
			5'd11: data_display  = cos_dec_nine 	+ "0";
			5'd12: data_display  = cos_dec_ten 		+ "0";
			5'd13: data_display  = " ";
			5'd14: data_display  = " ";
			5'd15: data_display  = " ";
			5'd16: data_display  = sin_sign_data;
			5'd17: data_display  = "0";
			5'd18: data_display  = ".";
			5'd19: data_display  = sin_dec_one 		+ "0";
			5'd20: data_display  = sin_dec_two 		+ "0";
			5'd21: data_display  = sin_dec_thr 		+ "0";
			5'd22: data_display  = sin_dec_four 	+ "0";
			5'd23: data_display  = sin_dec_five 	+ "0";
			5'd24: data_display  = sin_dec_six 		+ "0";
			5'd26: data_display  = sin_dec_seven	+ "0";
			5'd27: data_display  = sin_dec_eight	+ "0";
			5'd28: data_display  = sin_dec_nine 	+ "0";
			5'd29: data_display  = sin_dec_ten 		+ "0";
			5'd30: data_display  = "-";
			5'd31: data_display  = "-";
			
			default:data_display = "-";
		endcase
	end
  
  
  
//接收开始标志
reg start_flag;
reg clear_start_flag;
always@(posedge clk ) begin
	if(lcd_w_en_i) begin
		start_flag <= 1'b1;
	end
	else if (clear_start_flag) begin
		start_flag <= 1'b0;
	end
end
 
 
 
//生成lcd刷新时钟
 reg clk_en;
 reg [31:0]clk_cnt;
 always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		clk_cnt <= 0;
		clk_en  <= 1'b0;
	end
	else if(clk_cnt == 32'd49999) begin
		clk_en <= 1'b1;
		clk_cnt <= 32'd0;
	end
	else begin
		clk_cnt <= clk_cnt + 1'b1;
		clk_en <= 1'b0;
	end
end
  

 always@(posedge clk or negedge rst_n)begin
  	if(~rst_n)begin
		  lcd_rs  <=1'd0;
        lcd_rw  <=1'd0;
        lcd_en  <=1'd0;
        lcd_data<=8'd0;
        data_cnt<=6'd0;
		  lcd_req <= 1'b1;
        state   <=IDLE;

  	end
  	else if(clk_en == 1'b1)begin
  		case(state)												//待机状态
			IDLE :begin
  				if(start_flag)begin								//lcd_w_en_i是开启信号
  					state   <=S0;
					wr_en_state <=1'b0;
					data_cnt <= 6'd0;
					clear_start_flag <= 1'b0;
					lcd_req <= 1'b0;
  				end
  				else begin
  					state   <=IDLE;
					lcd_req <= 1'b1;
					data_cnt <= 6'd0;
  				end
  			end
        S0 :begin												//S0-S4是写入初始化命令
					 if(~wr_en_state) begin					//wr_en_state判断是否拉高了lcd_en,要等数据准备好后，在下一个时钟再拉高lcd_en
						lcd_en  <=1'd0;						//写入命令rs rw要求低电平，写入数据rs高，rw低
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data<=8'h38;
						state <= S0;							//数据准备好后，再进入一次该状态，把lcd_en拉高，写入数据
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=S1;
						wr_en_state <= 1'b0;
					 end
  			end  
        S1  :begin
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data<=8'h08;
						state <= S1;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=S2;
						wr_en_state <= 1'b0;
					 end
  			end 
        S2  :begin
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data<=8'h01;
						state <= S2;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=S3;
						wr_en_state <= 1'b0;
					 end
  			end 
        S3  :begin
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data<=8'h06;
						state <= S3;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=S4;
						wr_en_state <= 1'b0;
					 end
  			end 
        S4 :begin
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data<=8'h0C;
						state <= S4;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=Addr1;
						wr_en_state <= 1'b0;
					 end
            end
				
        Addr1:begin												//写入命令，从第一行第一列开始
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data =8'h80;//第一行地址
						state <= Addr1;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=WR1;
						wr_en_state <= 1'b0;
					 end
				end
				
				
        WR1 :begin
               if(data_cnt==6'd16)begin//第一行写完
                   state   <=Addr2;
						 wr_en_state <= 1'b0;
                   //data_cnt<=6'd0;
               end
               else begin
						if(~wr_en_state) begin
							lcd_en  <=1'd0;
							lcd_rs  <=1'd1;
							lcd_rw  <=1'd0;
							data_cnt<=data_cnt+6'd1;
							lcd_data<=data_display;//显示第一行数据
							wr_en_state <= 1'b1;
							state <=WR1;
						 end
						 else begin 
							lcd_en  <=1'd1;
							state   <=WR1;
							wr_en_state <= 1'b0;
						 end
               end
  			end 
        Addr2:begin												//写第二行
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data =8'hC0;
						state <= Addr2;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=WR2;
						wr_en_state <= 1'b0;
					 end
				end
        WR2 :begin
                if(data_cnt==6'd32)begin//第二行写完
                    state   <=stop;
                    data_cnt<=6'd0;
                end
                else begin
							if(~wr_en_state) begin
								lcd_en  <=1'd0;
								lcd_rs  <=1'd1;
								lcd_rw  <=1'd0;
								
								data_cnt<=data_cnt+6'd1;
								lcd_data<=data_display;//显示第二行数据
								state <= WR2;
								wr_en_state <= 1'b1;
							 end
							 else begin 
								lcd_en  <=1'd1;
								state   <=WR2;
								wr_en_state <= 1'b0;
							 end
                end
            end 
        stop :begin									//停止
					if(~wr_en_state) begin
						lcd_en  <=1'd0;
						lcd_rs  <=1'd0;
						lcd_rw  <=1'd0;
						lcd_data =8'h38;
						state <= stop;
						wr_en_state <= 1'b1;
					 end
					 else begin 
						lcd_en  <=1'd1;
						state   <=IDLE;
						wr_en_state <= 1'b0;
						clear_start_flag <= 1'b1;
					 end
				end
  		endcase
  	end
 end

 
 
endmodule



