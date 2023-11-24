
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
 
module uart_1byte_tx (
input clk				,
input rst_n				,
input send_go			,
input [7:0]data			,
output reg uart_tx		,
output reg tx_done		
);
 

 
localparam bps_max = 1000000000/115200/20;

	  
  reg send_en;
	 
always@(posedge clk or negedge rst_n)
	  if (!rst_n)
			send_en <= 0;
	  else begin
	       if(send_go)
			send_en <= 1;
	       else if(tx_done)
			send_en <= 0;
	   end
//  一旦开始发送，send_go 有效，就将外部的data 锁存起来，，这样防止外部数据变化而采错data【i】
  
reg [7:0]r_data;
always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		r_data <= 0;
	end
	else if(send_go)
		r_data <= data;
	else begin
		r_data <= r_data;
	end
end
  
wire bps_clk;
reg [17:0]div_cnt;
assign bps_clk = (div_cnt == 1);
 

always @(posedge clk or negedge rst_n) begin
	  if(!rst_n)
			div_cnt <= 0;
	  else if(send_en)
	  begin
			if(div_cnt == bps_max - 1)
				 div_cnt <= 0;
			else
				 div_cnt <= div_cnt + 1'b1;
	  end
	 else
			div_cnt <= 0; 
 end
 
 reg [3:0]bps_cnt;   // 11 
 always @(posedge clk or negedge rst_n) begin
	  if(!rst_n)
			bps_cnt <= 0;
	  else if(send_en)begin
			if(bps_clk)begin
			//if(div_cnt == 1)begin                                // 当send_en有效事  bps_cnt 才开始加   bps_cnt 不要等到最大再加一 这样会滞后
				 if(bps_cnt == 11)
					  bps_cnt <= 0;                         
				 else
					  bps_cnt <= bps_cnt + 1'b1;
				end
			  end
		else
				 bps_cnt <= 0; 
 end
 
 // send
 always @(posedge clk or negedge rst_n) 
	  if(!rst_n)begin
			uart_tx <= 1'b1;
	  end
	  else begin
			case(bps_cnt)
				 0:uart_tx <= 1'b1;
				 1:uart_tx <= 1'b0;               
				 2:uart_tx <= r_data[0];
				 3:uart_tx <= r_data[1];
				 4:uart_tx <= r_data[2];
				 5:uart_tx <= r_data[3];
				 6:uart_tx <= r_data[4];
				 7:uart_tx <= r_data[5];
				 8:uart_tx <= r_data[6];
				 9:uart_tx <= r_data[7];
				 10:uart_tx <= 1'b1;
				 11:begin uart_tx <= 1'b1;end
				 default:uart_tx <= 1'b1;
			endcase
	  end
	  // 为了保证 tx_done 只持续一个时钟周  单独写一个process
	  always @(posedge clk or negedge rst_n) 
			if(!rst_n)
				 tx_done <= 1'b0;
			else if ((bps_clk == 1) && (bps_cnt == 10))
				 tx_done <= 1'b1;
			else
				 tx_done <= 1'b0; 
endmodule