module sign_multiply_tb;

// Useful Parameters
parameter WORD_MID = 16;
parameter WORD_SZ = 32; 

// Define modifiable real and imaginary components for input ports
reg [WORD_MID-1:0] test_A, test_B;
wire [WORD_MID-1:0] test_C;

sign_mult TEST_UNIT (
    .A(test_A),
    .B(test_B),
    .C(test_C)
);

    initial begin
        $dumpfile("sign_multiply_tb.vcd");
        $dumpvars(0, sign_multiply_tb);

        #1 
        test_A = (16'd2 << 6);
        test_B = (16'd3 << 6);

        #1
        test_A = (16'd1 << 5);
        test_B = (16'd1 << 4);

        #1  // Increment CLK by 1
        test_A = 16'h0050;
        test_B = 16'h00A0;
        
        #1  // Increment CLK by 1
        test_A = 16'h00E0;
        test_B = 16'h0110;

        #1  // Increment CLK by 1
        test_A = 16'hFE70;
        test_B = 16'h00A0;

        #1  // Increment CLK by 1
        test_A = 16'h0110;
        test_B = 16'hFF60;

        #1 $finish;
    end
endmodule

