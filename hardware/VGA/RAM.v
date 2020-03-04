// RAM Module

module RAM(Addr, Data, KEY, SW);
	parameter AddrSize = 138;
	parameter WordSize = 8;

	input [3:0] KEY;				// 4 buttons on the de2-115 board
	input [17:0] SW;				// 18 Switches on the de2-115
	input [AddrSize-1:0] Addr;
	inout [WordSize-1:0] Data;

	reg [WordSize-1:0] Mem [0:(1<<AddrSize)-1];
	initial begin
	Mem[0] = 85;
	Mem[1] = 0;
	Mem[2] = 30;
	Mem[3] = 1;
	Mem[4] = 27;
	Mem[5] = 2;
	Mem[6] = 97;
	Mem[7] = 3;
	Mem[8] = 60;
	Mem[9] = 4;
	Mem[10] = 70;
	Mem[12] = 5;
	Mem[13] = 86;
	Mem[14] = 6;
	Mem[15] = 50;
	Mem[16] = 7;
	Mem[17] = 52;
	Mem[18] = 8;
	Mem[19] = 1;
	Mem[20] = 9;
	Mem[21] = 25;
	Mem[22] = 10;
	Mem[23] = 26;
	Mem[24] = 11;
	Mem[25] = 96;
	Mem[26] = 12;
	Mem[27] = 87;
	Mem[28] = 13;
	Mem[29] = 1;
	Mem[30] = 14;
	Mem[31] = 83;
	Mem[32] = 15;
	end

	assign Data = (SW[0] == 1 && SW[1] == 1) ? Mem[Addr]:{WordSize{1'bz}};
		
endmodule