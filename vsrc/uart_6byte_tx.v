`timescale 1ns / 1ps
//
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/28 09:19:27
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//
 
module uart_6byte_tx (
input clk				,
input rst_n				,
input trans_start		,
input [47:0]uart_data_in	,
output uart_tx		   ,
output reg trans_done		
);


wire tx_done;
reg [7:0]data;
reg send_go;

reg [47:0]data_48;
reg trans_start_reg;

//锁住输入数据
always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		data_48 <= 48'd0;
		trans_start_reg <= 1'b0;
	end
	else if(trans_start) begin
		data_48 <= uart_data_in;
		trans_start_reg <= trans_start;
	end
	else begin
		data_48 <= data_48;
		trans_start_reg <= trans_start;
	end
end

 
uart_1byte_tx u_uart_1byte_tx(
    .clk					(clk),
    .rst_n				(rst_n),
    .send_go			(send_go),
    .data			   (data),
    .uart_tx		   (uart_tx),
    .tx_done		   (tx_done)
);

//reg [7:0] tx_state;

//localparam IDLE     = 8'b0000_0001;
//localparam tx_byte1 = 8'b0000_0010;
//localparam tx_byte2 = 8'b0000_0100;
//localparam tx_byte3 = 8'b0000_1000;
//localparam tx_byte4 = 8'b0001_0000;
//localparam tx_byte5 = 8'b0010_0000;
//localparam tx_byte6 = 8'b0100_0000;

reg [2:0]state;



//发送6个字节的时序
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		state <= 0;
		send_go <= 0;
		data <= 0;
		trans_done <= 0;
	end
	else if(state == 0)begin
		trans_done <= 0;
		//if(tx_done)begin             // 当发完的时候  发新的
		if(trans_start_reg)begin             //  由trans_go 点燃第一个状态  启动状态  用tx_done 是无法启动状态机的  tx_done 是 0状态结束标志
			data <= data_48[7:0];
			send_go <= 1;
			state <= 1;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 0;
		end        
	end
	else if(state == 1)begin
		if(tx_done)begin
			data <= data_48[15:8];
			send_go <= 1;
			state <= 2;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 1;
		end        
	end
	else if(state == 2)begin
		if(tx_done)begin
			data <= data_48[23:16];
			send_go <= 1;
			state <= 3;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 2;
		end        
	end
	else if(state == 3)begin
		if(tx_done)begin
			data <= data_48[31:24];
			send_go <= 1;
			state <= 4;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 3;
		end        
	end
	else if(state == 4)begin
		if(tx_done)begin
			data <= data_48[39:32];
			send_go <= 1;
			state <= 5;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 4;
		end        
	end
	else if(state == 5)begin
		if(tx_done)begin
			data <= data_48[47:40];
			send_go <= 1;
			state <= 6;
		end
		else begin
			data <= data;
			send_go <= 0;
			state   <= 5;
		end        
	end
	else if(state == 6)begin
		if(tx_done)begin               // 当发完的时候 回到初始状态
			send_go <= 0;
			state <= 0;
			trans_done <= 1;
		end
		else begin                    // 当没发完的时候 等他发完
			data <= data;
			send_go <= 0;
			state   <= 6;
		end        
	end

endmodule 




