module mips_core(clock);

	input clock;
	wire [31:0] instruction;
	reg [7:0] pc_counter;
	wire [7:0] pc;
	 
	//pc_counter in ilk deger atamasi 
	
	initial begin
	pc_counter  = 8'b0;//
	end
	
	wire [4:0] Rs;
	wire [4:0] Rt;
	wire [4:0] Rd;
	
	wire [4:0] read_reg_1;//mips register modul input ve outputlari
	wire [4:0] read_reg_2;
	wire [31:0] read_data_1;
	wire [31:0] read_data_2;
	wire [31:0] write_data;
	wire [4:0] write_reg;
	wire signal_reg_write;
	
	wire [31:0] sign_extend; 
	wire [31:0]shift_left_2;
	
	wire [31:26] opcode;//control modul input ve outputlari
	wire RegDst;
	wire MemRead;
	wire MemtoReg;
	wire MemWrite;
	wire ALUSrc;
	wire [1:0] ALUOp;
	wire Branch;
	wire RegWrite;
	wire Jump;

	wire [5:0] func; 	
	wire [2:0] ALU_ctrl;	
	
	wire [31:0] read_data;//datamem input ve outputlari
	wire [31:0] mem_address;
	wire [31:0] write_data_1;
	wire [7:0] data_mem [1023:0];
	wire[31:0] read_data_5;
	wire sig_mem_read;
	wire sig_mem_write;
	
	wire [31:0] ALUResult;
	wire zero;
	wire [31:0] rs_content; /* ikisini deiştirdim .*/
	wire [31:0] rt_content;
	wire [2:0] ALUCtr;
	
	mips_instr_mem eda1(instruction,pc_counter);//insttruction okumasi icin cagrilan fonk
	
	assign func=instruction[5:0]; //Rtype ler icin cagrildi
	
	assign Rs = instruction[25:21];
	assign Rt = instruction[20:16];
	assign Rd = instruction[15:11];
	//sign extend icin calisir.
	assign sign_extend = (instruction[15] == 0 ) ? {16'b0,instruction[15:0]} : {16'b1,instruction[15:0]} ;
	
	assign opcode= instruction[31:26];
	
	Control eda2(opcode,RegDst,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Jump);//main control moduludur.
	
	assign write_reg = (RegDst==1) ? Rd : Rt;//mux1 = instruction memory ve register arasindaki mux.
	
	mips_registers eda3(read_data3, read_data_2 ,{32'b0}, Rs, Rt, write_reg,0, clock);
	
	ALU eda4( func,ALUOp,ALUCtr);
	
	assign read_data_2 =(ALUSrc==0) ? read_data_2 : sign_extend;// mux2 = register ve alu arasindaki mux.
	
	ALU eda5(read_data3,read_data_2,ALU_ctrl,zero,ALUResult);
	
	mips_data_mem  eda6(read_data_5, ALUResult, read_data_2, MemRead, MemWrite);
	
	
	assign write_data_1 = (MemtoReg==1 ) ? read_data_5 : ALUResult; // mux3 data memory den sonra gelen  mux. 
	
	assign shift_left_2 = sign_extend << 2;//2 sola shift edildi.
	
	
	
	
	assign pc = ((Branch & zero)==1 ) ? pc_counter + 4 + shift_left_2[7:0] : pc_counter+4; // mux4 en sonda kalan mux.
	
	
	always@(pc_counter)//pc guncelleme izin oldugu icin always kullanildi.
	begin
		pc_counter = pc;
	end
	
	mips_registers eda7(read_data3, read_data_2 ,write_data_1, Rs, Rt, write_reg,RegWrite, clock);
	
endmodule 

