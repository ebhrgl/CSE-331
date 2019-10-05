module mips_testbench 
(
 output [31:0]Result,
 input [31:0]input_inst,
 input [31:0]rs_content,
 input [31:0]rt_content,
 output clock
 
 );
	wire [31:0] result;
	reg [5:0] OPCode;
	reg [31:0] ins_Add,ins_Sub,ins_And,ins_Or,ins_Sra,ins_Srl,ins_Sll,ins_Sltu,Sonuc;
	reg [31:0] Addi,Addiu,Andi,Ori,Slti,Lui;
	reg [31:0] Sub;
	
	wire [32:0]Immediate=input_inst[15:0];
	wire [5:0]Funct=input_inst[31:26];
	wire [4:0]shift=input_inst[10:6];
	
	reg [31:0] immUnsigned;
	wire cout1,cout2,slt;
	reg wire_slti;
	
	parameter bit_size = 32;
	parameter mem_size = 32;
	integer i;
	integer a, b;
	parameter addi  = 6'b001000;
	parameter addiu = 6'b001001;
	parameter andi  = 6'b001100;
	parameter ori   = 6'b001101;
	parameter slti  = 6'b001010;
	parameter lui   = 6'b001111;
		
	reg [bit_size-1:0] array [0:mem_size-1];
	
	eda mips_core(.result(result));
		
	initial begin
	
	mips_core.clock=0;
	
		//dosyadan okuma
		
		$readmemh("registers.mem", mips_core.mips_registers);
		$readmemb("instruction.mem", mips_core.mips_instr_mem);
		$readmemb("data.mem", mips_core.mips_data_mem);
	end
		
		
	//R-Type icin
always @ (*) begin
	if(input_inst[31:26] == 6'b000000) begin
	
	//instructionsların islemleri tanimlandi
	 ins_Add = array[input_inst[25:21]] + array[input_inst[20:16]];
	 ins_Sub = array[input_inst[25:21]] - array[input_inst[20:16]];
	 ins_And = array[input_inst[25:21]] & array[input_inst[20:16]];
	 ins_Or  = array[input_inst[25:21]] | array[input_inst[20:16]];
	 ins_Srl = array[input_inst[20:16]] >> shift;
	 ins_Sll = array[input_inst[20:16]] << shift;
	 ins_Sltu = {31'b0, (array[input_inst[25:21]] < array[input_inst[20:16]])};
	 ins_Sra = array[input_inst[20:16]] >>> shift;
	
	//6 bitlik Funct kısmı hangi islemi yapacagini seciyor
	 Sonuc = (Funct == 6'b000000) ? ins_Sll : 
						(Funct == 6'b100000) ? ins_Add :
						(Funct == 6'b100010) ? ins_Sub :
						(Funct == 6'b100100) ? ins_And :
						(Funct == 6'b100101) ? ins_Or  :
						(Funct == 6'b000011) ? ins_Sra :
						(Funct == 6'b000010) ? ins_Srl :
						(Funct == 6'b000000) ? ins_Sll :
						(Funct == 6'b101001) ? ins_Sltu:  32'hx;	

		end
		
	else 
	
	//R-Type icin
	 Addi = array[input_inst[25:21]] + Immediate; // signed 
	 Addiu = array[input_inst[25:21]] + Immediate; //unsigned 
	 Andi = array[input_inst[25:21]] & Immediate;
	 Ori  = array[input_inst[25:21]] | Immediate;
	 Lui = {Immediate[31:16], 16'b0};
		 
	//slti pozitif negatif karşılaştırırken karıştırıyordu
	 Sub = array[input_inst[25:21]] - Immediate;
	 
	 // islemi  secimi
	 Sonuc =(input_inst[31:26] == addi) ? Addi :
						(input_inst[31:26] == addiu) ? Addiu :
						(input_inst[31:26] == andi) ? Andi :
						(input_inst[31:26] == ori) ? Ori :
						(input_inst[31:26] == slti) ? {{31{1'b0}}, wire_slti} :
						(input_inst[31:26] == lui) ? Lui : 32'hx;
	
	end							
	
		initial begin
		//ilk degerleri dosyaya yazma
		
		$writememh("initial_registers.mem", mips_core.mips_registers);
		$writememb("initial_instruction.mem", mips_core.mips_instr_mem);
		$writememb("initial_data.mem", mips_core.mips_data_mem);
		
		//son degerleri dosyaya yazma
		
		$writememh("result_registers.mem", mips_core.mips_registers);
		$writememb("result_instruction.mem", mips_core.mips_instr_mem);
		$writememb("result_data.mem", mips_core.mips_data_mem);
		#50;
		$finish;
		
	end
	
	always begin
		#25 mips_core.clock = ~ mips_core.clock;
	end
endmodule 