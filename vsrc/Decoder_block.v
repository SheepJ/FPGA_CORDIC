module Decoder_block(
input clk			,
input rst_n			,
input start			,

input [41:0]Cos	,
input [41:0]Sin	,

input c_s_swap,


//test//
//output [2:0]state_test				,
output [3:0]cos_dec_one_out 		,
output [3:0]cos_dec_two_out 		,
output [3:0]cos_dec_thr_out 		,
output [3:0]cos_dec_four_out 		,
output [3:0]cos_dec_five_out 		,
output [3:0]cos_dec_six_out 		,
output [3:0]cos_dec_seven_out		,
output [3:0]cos_dec_eight_out		,
output [3:0]cos_dec_nine_out 		,
output [3:0]cos_dec_ten_out 		,

output [3:0]sin_dec_one_out 		,
output [3:0]sin_dec_two_out 		,
output [3:0]sin_dec_thr_out 		,
output [3:0]sin_dec_four_out 		,
output [3:0]sin_dec_five_out 		,
output [3:0]sin_dec_six_out 		,
output [3:0]sin_dec_seven_out		,
output [3:0]sin_dec_eight_out		,
output [3:0]sin_dec_nine_out 		,
output [3:0]sin_dec_ten_out 		,


////////

output reg Decoder_req				,
output reg w_en_to_lcd
//output [33:0]cos_dec_number_o,
//output [33:0]sin_dec_number_o


);



reg [33:0] 	weight;					//9999999999需要34位


reg [33:0]  cos_dec_number_reg;
reg [33:0]  sin_dec_number_reg;
reg [2:0]	state;

parameter 	WAIT 			= 3'd0,
				PROCESSING	= 3'd1;


reg [5:0]   i;

always@(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        cos_dec_number_reg <= 0;
		  sin_dec_number_reg <= 0;
        i <= 0;
		  weight <= 34'd5000000000;
		  state <= WAIT;
		  Decoder_req <= 1'b1;
    end
    else begin
			if(state==WAIT) begin
				if(start) begin
					state <= PROCESSING;
					Decoder_req <= 1'b0;
				end
				else begin
					w_en_to_lcd <= 1'b0;
					Decoder_req <= 1'b1;
					cos_dec_number_reg <= cos_dec_number_reg;
					sin_dec_number_reg <= sin_dec_number_reg;
					i <= 0;
					state <= WAIT;
				end
			end
			else if(state == PROCESSING) begin
				cos_dec_number_reg <= cos_dec_number_reg + ( {34{Cos[33-i]}} & weight>>i );
				sin_dec_number_reg <= sin_dec_number_reg + ( {34{Sin[33-i]}} & weight>>i );
				if(i !=33) begin 
					i <= i + 1'b1;
					state <= PROCESSING;
				end
				else begin
					w_en_to_lcd <= 1'b1;
					state <= WAIT;
					i		<= 0;
				end
			end
    end
end

//assign cos_dec_number_o = cos_dec_number_reg;
//assign sin_dec_number_o = sin_dec_number_reg;
//assign state_test   = state;

wire [3:0]cos_dec_one 	;
wire [3:0]cos_dec_two 	;
wire [3:0]cos_dec_thr 	;
wire [3:0]cos_dec_four 	;
wire [3:0]cos_dec_five 	;
wire [3:0]cos_dec_six 	;
wire [3:0]cos_dec_seven ;
wire [3:0]cos_dec_eight ;
wire [3:0]cos_dec_nine 	;
wire [3:0]cos_dec_ten 	;

wire [3:0]sin_dec_one 	;
wire [3:0]sin_dec_two 	;
wire [3:0]sin_dec_thr 	;
wire [3:0]sin_dec_four 	;
wire [3:0]sin_dec_five 	;
wire [3:0]sin_dec_six 	;
wire [3:0]sin_dec_seven ;
wire [3:0]sin_dec_eight ;
wire [3:0]sin_dec_nine 	;
wire [3:0]sin_dec_ten 	;

assign cos_dec_one 		= 	cos_dec_number_reg / 34'd1000000000				;
assign cos_dec_two 		= 	cos_dec_number_reg / 34'd100000000		% 10	;
assign cos_dec_thr 		= 	cos_dec_number_reg / 34'd10000000		% 10	;
assign cos_dec_four 		= 	cos_dec_number_reg / 34'd1000000			% 10	;
assign cos_dec_five 		= 	cos_dec_number_reg / 34'd100000			% 10	;
assign cos_dec_six 		= 	cos_dec_number_reg / 34'd10000			% 10	;
assign cos_dec_seven 	= 	cos_dec_number_reg / 34'd1000				% 10	;
assign cos_dec_eight 	= 	cos_dec_number_reg / 34'd100				% 10	;
assign cos_dec_nine 		= 	cos_dec_number_reg / 34'd10				% 10	;
assign cos_dec_ten 		= 	cos_dec_number_reg 							% 10	;
	
assign sin_dec_one 		= 	sin_dec_number_reg / 34'd1000000000				;
assign sin_dec_two 		= 	sin_dec_number_reg / 34'd100000000		% 10	;
assign sin_dec_thr 		= 	sin_dec_number_reg / 34'd10000000		% 10	;
assign sin_dec_four 		= 	sin_dec_number_reg / 34'd1000000			% 10	;
assign sin_dec_five 		= 	sin_dec_number_reg / 34'd100000			% 10	;
assign sin_dec_six 		= 	sin_dec_number_reg / 34'd10000			% 10	;
assign sin_dec_seven 	= 	sin_dec_number_reg / 34'd1000				% 10	;
assign sin_dec_eight 	= 	sin_dec_number_reg / 34'd100				% 10	;
assign sin_dec_nine 		= 	sin_dec_number_reg / 34'd10				% 10	;
assign sin_dec_ten 		= 	sin_dec_number_reg  							% 10	;



assign cos_dec_one_out 		= c_s_swap? sin_dec_one 	: cos_dec_one 	;
assign cos_dec_two_out 		= c_s_swap? sin_dec_two 	: cos_dec_two 	;
assign cos_dec_thr_out 		= c_s_swap? sin_dec_thr 	: cos_dec_thr 	;
assign cos_dec_four_out 	= c_s_swap? sin_dec_four 	: cos_dec_four ;	
assign cos_dec_five_out 	= c_s_swap? sin_dec_five 	: cos_dec_five ;	
assign cos_dec_six_out 		= c_s_swap? sin_dec_six 	: cos_dec_six 	;
assign cos_dec_seven_out 	= c_s_swap? sin_dec_seven 	: cos_dec_seven; 
assign cos_dec_eight_out 	= c_s_swap? sin_dec_eight 	: cos_dec_eight; 
assign cos_dec_nine_out 	= c_s_swap? sin_dec_nine 	: cos_dec_nine ;	
assign cos_dec_ten_out 		= c_s_swap? sin_dec_ten 	: cos_dec_ten 	;

assign sin_dec_one_out 		= c_s_swap? cos_dec_one 	: sin_dec_one 	;
assign sin_dec_two_out 		= c_s_swap? cos_dec_two 	: sin_dec_two 	;
assign sin_dec_thr_out 		= c_s_swap? cos_dec_thr 	: sin_dec_thr 	;
assign sin_dec_four_out 	= c_s_swap? cos_dec_four 	: sin_dec_four ;	
assign sin_dec_five_out 	= c_s_swap? cos_dec_five 	: sin_dec_five ;	
assign sin_dec_six_out 		= c_s_swap? cos_dec_six 	: sin_dec_six 	;
assign sin_dec_seven_out 	= c_s_swap? cos_dec_seven 	: sin_dec_seven; 	
assign sin_dec_eight_out 	= c_s_swap? cos_dec_eight 	: sin_dec_eight; 	
assign sin_dec_nine_out 	= c_s_swap? cos_dec_nine 	: sin_dec_nine ;	
assign sin_dec_ten_out 		= c_s_swap? cos_dec_ten 	: sin_dec_ten 	;







endmodule

