
module Show_In_block(
	input       clk,
	input			rst_n,
   input		 	[8:0]in_num,			//输入显示数据，范围0-360度
   output      [6:0]out_Seg0_num,
	output      [6:0]out_Seg1_num,
	output      [6:0]out_Seg2_num
);

wire [3:0]Seg0_in_num;
wire [3:0]Seg1_in_num;
wire [3:0]Seg2_in_num;

assign Seg0_in_num = (in_num%10)		;	//个位
assign Seg1_in_num = (in_num/10)%10	;	//十位	
assign Seg2_in_num = (in_num/100)%10;	//百位


///////////////////////////////////
//数码管0显示个位
Seg_block u_Seg_block0(
	.clk				(clk),
	.rst_n			(rst_n),
	.in_num			(Seg0_in_num),
   .out_Seg_num	(out_Seg0_num)
);
///////////////////////////////////

///////////////////////////////////
//数码管1显示十位
Seg_block u_Seg_block1(
	.clk				(clk),
	.rst_n			(rst_n),
	.in_num			(Seg1_in_num),
   .out_Seg_num	(out_Seg1_num)
);
///////////////////////////////////

///////////////////////////////////
//数码管2显示百位
Seg_block u_Seg_block2(
	.clk				(clk),
	.rst_n			(rst_n),
	.in_num			(Seg2_in_num),
   .out_Seg_num	(out_Seg2_num)
);
///////////////////////////////////

endmodule 
