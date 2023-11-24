
module Seg_block(
	input       clk,
	input 		rst_n,
   input		 	[3:0]in_num,
   output      [6:0]out_Seg_num
);

parameter   NUM0     = 7'h40,
            NUM1     = 7'h79,
            NUM2     = 7'h24,
            NUM3     = 7'h30,
            NUM4     = 7'h19,
            NUM5     = 7'h12,
            NUM6     = 7'h02,
            NUM7     = 7'h78,
            NUM8     = 7'h00,
            NUM9     = 7'h10,
            NUMA     = 7'h08,
            NUMB     = 7'h03,
            NUMC     = 7'h46,
            NUMD     = 7'h21,
            NUME     = 7'h06,
            NUMF     = 7'h0e;
				
reg [6:0]    tmp_num_reg = 7'h00;
   
always @(posedge clk or negedge rst_n) begin
	if(~rst_n) tmp_num_reg <=0;
	else begin
      case (in_num)
			  4'b0000 : tmp_num_reg <= NUM0;
			  4'b0001 : tmp_num_reg <= NUM1;
			  4'b0010 : tmp_num_reg <= NUM2;
			  4'b0011 : tmp_num_reg <= NUM3;
			  4'b0100 : tmp_num_reg <= NUM4;          
			  4'b0101 : tmp_num_reg <= NUM5;
			  4'b0110 : tmp_num_reg <= NUM6;
			  4'b0111 : tmp_num_reg <= NUM7;
			  4'b1000 : tmp_num_reg <= NUM8;
			  4'b1001 : tmp_num_reg <= NUM9;
			  4'b1010 : tmp_num_reg <= NUMA;
			  4'b1011 : tmp_num_reg <= NUMB;
			  4'b1100 : tmp_num_reg <= NUMC;
			  4'b1101 : tmp_num_reg <= NUMD;
			  4'b1110 : tmp_num_reg <= NUME;
			  4'b1111 : tmp_num_reg <= NUMF;
      endcase
	end
end

assign out_Seg_num = tmp_num_reg;


endmodule

