module mem_tb;

// Useful Parameters
parameter MEM_SIZE = 5;
parameter WORD_SIZE = 16;

// Test Signals
reg test_CLK = 1'b0, test_read_en, test_write_en = 1'b0;
reg [4:0] test_read_addr, test_write_addr;
reg [15:0] test_write_data;
wire [WORD_SIZE-1:0] test_read_data;

mem TEST_UNIT (
    test_CLK, 
    test_read_en, 
    test_write_en, 
    test_read_addr, 
    test_write_addr, 
    test_write_data, 
    test_read_data
);

    always    
        #1 test_CLK <= ~test_CLK;

    initial begin
        $dumpfile("mem_tb.vcd");
        $dumpvars(0, mem_tb);
        
        #2
        test_write_en = 1'b1;
        test_write_addr = 5'b00111;
        test_write_data = 16'hbeef;

        #2
        test_write_en = 1'b0;
        test_read_en = 1'b1;
        test_read_addr = 5'b00111;

        #2
        test_read_en = 1'b0;

        #2 $finish;
    end
endmodule
