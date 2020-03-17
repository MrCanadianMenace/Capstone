module FFT_Pipeline_tb;

// Testbench driving signals
wire [3:0] FAKE_KEY;
wire [7:0] FAKE_SW;
reg CLK = 0, RST = 1, MEMSW = 0, PIPESW = 0;

assign FAKE_KEY[3] = RST;
assign FAKE_SW[0] = MEMSW;
assign FAKE_SW[1] = PIPESW;

// Test module instantiaton
FFT_Pipeline TEST_MOD(
    .CLOCK_50(CLK),
    .KEY(FAKE_KEY),
    .SW(FAKE_SW)
);

    always
        #5 CLK = ~CLK;

    always
        #1 PIPESW = ~PIPESW;

    always
        #2 MEMSW = ~MEMSW;

    initial begin
        $dumpfile("FFT_Pipeline_tb.vcd");
        $dumpvars(0, FFT_Pipeline_tb);

        #1 RST <= 1'b0;

        #1 RST <= 1'b1;

        #50 $finish;
    end
endmodule
