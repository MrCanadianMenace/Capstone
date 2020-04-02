module RAM2B 
    # (parameter WORD_SIZE = 16,
       parameter MEM_SIZE = 32,
       parameter ADDR_SIZE = $clog2(MEM_SIZE))
    (
        input wire i_CLK,
        input wire i_RST,
        input wire i_write_en_A,
        input wire i_write_en_B,
        input wire i_read_en_A,
        input wire i_read_en_B,
        input wire [ADDR_SIZE-1:0] i_write_addr_A,
        input wire [ADDR_SIZE-1:0] i_write_addr_B,
        input wire [ADDR_SIZE-1:0] i_read_addr_A,
        input wire [ADDR_SIZE-1:0] i_read_addr_B,
        input wire [WORD_SIZE-1:0] i_write_data_A,
        input wire [WORD_SIZE-1:0] i_write_data_B,
        output wire [WORD_SIZE-1:0] o_read_data_A,
        output wire [WORD_SIZE-1:0] o_read_data_B
    );

    /* Block Memory Definition */
    reg [WORD_SIZE-1:0] RAM [MEM_SIZE-1:0];

    integer i;

    initial begin
        $display("Loading memory");
        $readmemh("pipe_memory.mem", RAM);
    end

    /** Asynchronous Reading **/
    assign o_read_data_A = (i_read_en_A) ? RAM[i_read_addr_A] : 16'h0;
    assign o_read_data_B = (i_read_en_B) ? RAM[i_read_addr_B] : 16'h0;

    always @ (posedge i_CLK) begin

        /** Synchronous Writing **/
        if (i_write_en_A)
            RAM[i_write_addr_A] = i_write_data_A;

        if (i_write_en_B)
            RAM[i_write_addr_B] = i_write_data_B;
    end
endmodule
