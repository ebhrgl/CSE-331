module ALU(read_data_1, read_data_2, AluCtr, Zero, Alu_Result);

	output[31:0] Alu_Result;
	output[1:0] Zero;
	input [2:0]AluCtr;
	input [31:0] read_data_1;
	input [31:0] read_data_2;
	
	assign Alu_Result=(AluCtr==3'b010)?  read_data_1 + read_data_2 ://add komutunun islevini yapar.
							(AluCtr==3'b110)?  read_data_1 - read_data_2 ://sub komutunun islevini yapar.
							(AluCtr==3'b000)?  read_data_1 & read_data_2 ://and komutunun islevini yapar.
							(AluCtr==3'b001)?  read_data_1 | read_data_2 ://or komutunun islevini yapar.
	
							(AluCtr==3'b011)?  ~(read_data_1 | read_data_2)://nor olmadigi icin ekledim.
							(AluCtr==3'b100)?  (read_data_1 << read_data_2)://sll olmadigi icin ekledim.
							(AluCtr==3'b101)?  (read_data_1 >> read_data_2)://srl olmadigi icin ekledim.
							
							
							(AluCtr==3'b111)?  (read_data_1 < read_data_2 ?
																			32'b0000000000000000000000000000001:
																			32'b0000000000000000000000000000000):0;//set on less than	
	
	assign Zero = (Alu_Result==0)? 1'b1 : 1'b0;
	
endmodule 
	