module Control(opcode,RegDst,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Jump);

//tüm instruction larin eklendigi moduldur
	input [5:0] opcode;
	output RegDst;
	output Branch;
	output MemRead;
	output MemtoReg;
	output [1:0] ALUOp;
	output MemWrite;
	output ALUSrc;
	output RegWrite;
	output Jump;
	wire rRegDst,rRegWrite,rALUOp1;
	wire addALUSrc,addRegWrite;
	wire addiuALUSrc,addiuRegWrite;
	wire andiALUSrc,andiRegWrite;
	wire qBranch,qALUOp0;
	wire eBranch,eALUOp0;
	wire jJump;
	wire jaRegWrite,jaJump;
	wire lbMemRead,lbMemtoReg,lbALUSrc,lbRegWrite;
	wire lhMemRead,lhMemtoReg,lhALUSrc,lhRegWrite;
	wire luALUSrc,luRegWrite;
	wire lwMemRead,lwMemtoReg,lwALUSrc,lwRegWrite;
	wire orALUSrc,orRegWrite;
	wire sltALUSrc,sltRegWrite;
	wire sltiuALUSrc,sltiuRegWrite;
	wire sbMemWrite,sbALUSrc;
	wire shMemWrite,shALUSrc;
	wire swMemWrite,swALUSrc;
	
	assign rRegDst = (opcode == 6'b000000) ? 1'b1 : 1'b0;//Tum Rtype ler icin 
	assign rRegWrite = (opcode == 6'b000000) ? 1'b1 : 1'b0;
	assign rALUOp1 = (opcode == 6'b000000) ? 1'b1 : 1'b0;
	
	assign addALUSrc=(opcode == 6'b001000) ? 1'b1:1'b0;  //addi  instruction ı ekledim 
	assign addRegWrite=(opcode == 6'b001000) ? 1'b1:1'b0;
	
	assign addiuALUSrc=(opcode == 6'b001001) ? 1'b1:1'b0;// addiu  instruction ı ekledim 
	assign addiuRegWrite=(opcode == 6'b001001) ? 1'b1:1'b0;
	
	assign andiALUSrc=(opcode == 6'b001100) ? 1'b1:1'b0;	// andi instruction ı ekledim 
	assign andiRegWrite=(opcode == 6'b001100) ? 1'b1:1'b0;
	
	assign qBranch=(opcode == 6'b000100) ? 1'b1:1'b0; //beq instructionu ekledim  
	assign qALUOp0=(opcode == 6'b000100) ? 1'b1:1'b0;
	
	assign eBranch=(opcode == 6'b000101) ? 1'b1:1'b0;//bne instructionu ekledim  
	assign eALUOp0=(opcode == 6'b000101) ? 1'b1:1'b0;
	
	
	assign luALUSrc=(opcode == 6'b001111) ? 1'b1:1'b0;
	assign luRegWrite=(opcode == 6'b001111) ? 1'b1:1'b0; // lui instructionu ekledim

	assign lwMemRead=(opcode == 6'b100011) ? 1'b1:1'b0; // lw instructionu ekledim
	assign lwMemtoReg=(opcode == 6'b100011) ? 1'b1:1'b0;
	assign lwALUSrc=(opcode == 6'b100011) ? 1'b1:1'b0;
	assign lwRegWrite=(opcode == 6'b100011) ? 1'b1:1'b0;
	
	assign swMemWrite=(opcode == 6'b101011) ? 1'b1:1'b0; //  sw  instructionu ekledim
	assign swALUSrc=(opcode == 6'b101011) ? 1'b1:1'b0;
	
	assign sltALUSrc=(opcode == 6'b001010) ? 1'b1:1'b0;
	assign sltRegWrite=(opcode == 6'b001010) ? 1'b1:1'b0; //slti instructionu ekledim
	
	assign sltiuALUSrc=(opcode == 6'b001011) ? 1'b1:1'b0; // sltiu instructionu ekledim
	assign sltiuRegWrite=(opcode == 6'b001011) ? 1'b1:1'b0;
	
	assign orALUSrc=(opcode == 6'b001101) ? 1'b1:1'b0;
	assign orRegWrite=(opcode == 6'b001101) ? 1'b1:1'b0;  //ori instructionu ekledim

	
	assign sbMemWrite=(opcode == 6'b101000) ? 1'b1:1'b0; //  sb instructionu ekledim
	assign sbALUSrc=(opcode == 6'b101000) ? 1'b1:1'b0;
	
	assign shMemWrite=(opcode == 6'b101001) ? 1'b1:1'b0; //  sh instructionu ekledim
	assign shALUSrc=(opcode == 6'b101001) ? 1'b1:1'b0;

	assign lbMemRead=(opcode == 6'b100100) ? 1'b1:1'b0; // lbu instructionu ekledim
	assign lbMemtoReg=(opcode == 6'b100100) ? 1'b1:1'b0;
	assign lbALUSrc=(opcode == 6'b100100) ? 1'b1:1'b0;
	assign lbRegWrite=(opcode == 6'b100100) ? 1'b1:1'b0;
	
	assign lhMemRead=(opcode == 6'b100101) ? 1'b1:1'b0;
	assign lhMemtoReg=(opcode == 6'b100101) ? 1'b1:1'b0;   //lhu instructionu ekledim
	assign lhALUSrc=(opcode == 6'b100101) ? 1'b1:1'b0;
	assign lhRegWrite=(opcode == 6'b100101) ? 1'b1:1'b0;

	assign jJump=(opcode == 6'b000010) ? 1'b1:1'b0;	// j instructionu ekledim 
	
	assign jaRegWrite=(opcode == 6'b000011) ? 1'b1:1'b0;	// jal instructionu ekledim 
	assign jaJump=(opcode == 6'b000011) ? 1'b1:1'b0;
	//gelen bitlerin orlanmasi
	
	or(RegDst,rRegDst);
	or(RegWrite,rRegWrite,addRegWrite,addiuRegWrite,sltiuRegWrite,andiRegWrite,jaRegWrite,lbRegWrite,sltRegWrite,lhRegWrite,orRegWrite,luRegWrite,lwRegWrite);
	or(ALUOp[1],rALUOp1);
	or(ALUSrc,addALUSrc,addiuALUSrc,andiALUSrc,swALUSrc,lbALUSrc,shALUSrc,sbALUSrc,lhALUSrc,luALUSrc,lwALUSrc,orALUSrc,sltALUSrc,sltiuALUSrc);
	or(Branch,qBranch,eBranch);
	or(ALUOp[0],qALUOp0,eALUOp0);
	or(Jump,jJump,jaJump);
	or(MemRead,lbMemRead,lhMemRead,lwMemRead);
	or(MemtoReg,lbMemtoReg,lhMemtoReg,lwMemtoReg);
	or(MemWrite,sbMemWrite,shMemWrite,swMemWrite);
	
	
	endmodule 