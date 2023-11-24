
//顶层模块
module CORDIC_top(
input clk,												//时钟
input button,											//角度加按键
input button_sub,										//角度减按键
input rst_n,											//复位
input button_start,
input Mode_sel,


output [6:0]out_Seg0_num,
output [6:0]out_Seg1_num,
output [6:0]out_Seg2_num,

output uart_tx_out



);

wire key_flag1;
wire key_state1;
wire key_flag2;
wire key_state2;

wire [6:0]angle_to_arith;
wire [8:0]angle_to_show_in;

wire Arith_start_to_UART;
wire Arith_Ext_start_to_UART;
wire cos_sign_to_output;
wire sin_sign_to_output;
wire c_s_swap_to_output;
wire [41:0]Cos;
wire [41:0]Sin;
wire [41:0]Cosh;
wire [41:0]Sinh;

/************输入模块***************/
Input_block  u_Input_block_1(
	.clk							(clk),
	.rst_n						(rst_n),
	.button						(button),
	.button_sub					(key_flag2 & key_state2),
	.Mode_sel					(Mode_sel),
	.angle_to_show_in			(angle_to_show_in),
	.angle_to_arith			(angle_to_arith),
	.cos_sign_to_output		(cos_sign_to_output),
	.sin_sign_to_output		(sin_sign_to_output),	
	.c_s_swap_to_output		(c_s_swap_to_output)	
);

	
/************输入显示模块************/
Show_In_block u_Show_In_block_1(
	.clk				(clk),
	.rst_n			(rst_n),
	.in_num			(angle_to_show_in),
	.out_Seg0_num	(out_Seg0_num),
	.out_Seg1_num	(out_Seg1_num),
	.out_Seg2_num	(out_Seg2_num)
);
///////////////////////////////////


wire Arith_start;
wire Arith_Ext_start;

assign Arith_start  		= (~Mode_sel)? (key_flag1 & key_state1) : 1'b0;
assign Arith_Ext_start 	= (Mode_sel)? (key_flag1 & key_state1) : 1'b0;

/************运算模块************/
Arith_block u_Arith_block(
	.clk					(clk),
	.rst_n				(rst_n),
	.theta				(angle_to_arith),
	.start				(Arith_start),
	.start_to_UART		(Arith_start_to_UART),
	.Sin					(Sin),
	.Cos					(Cos)
);



Arith_block_Ext u_Arith_block_Ext(
	.clk					(clk),
	.rst_n				(rst_n),
	.theta				(angle_to_arith),
	.start				(Arith_Ext_start),
	.start_to_UART		(Arith_Ext_start_to_UART),
	.Sinh					(Sinh),
	.Cosh					(Cosh)
);



wire [41:0]uart_data_A_in;
wire [42:0]uart_data_B_in;
wire start_to_UART;
assign uart_data_A_in = (Mode_sel)? Cosh : Cos;
assign uart_data_B_in = (Mode_sel)? Sinh : Sin;
assign start_to_UART  = (Mode_sel)? Arith_Ext_start_to_UART : Arith_start_to_UART;

Output_block u_Output_block(
	.clk							(clk),
	.rst_n						(rst_n),
	.cos_sign_to_output		(cos_sign_to_output),				//cos符号，传给Show_Out_block
	.sin_sign_to_output		(sin_sign_to_output),				//sin符号，传给Show_Out_block
	.c_s_swap_to_output		(c_s_swap_to_output),				//cos与sin交换标志，传给Show_Out_block
	.tx_start					(start_to_UART),
	.data_A_in					(uart_data_A_in),
	.data_B_in					(uart_data_B_in),
	.uart_tx		    			(uart_tx_out)
);


KeyFilter u_KeyFilter1(
	.clk				(clk),
	.rst_n			(rst_n),
	.key_in			(button_start),
	.key_flag		(key_flag1),
	.key_state		(key_state1)
);

KeyFilter u_KeyFilter2(
	.clk				(clk),
	.rst_n			(rst_n),
	.key_in			(button_sub),
	.key_flag		(key_flag2),
	.key_state		(key_state2)
);


endmodule
