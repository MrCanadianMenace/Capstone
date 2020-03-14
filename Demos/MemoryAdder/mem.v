module mem(
    i_CLK,
    i_read_en, 
    i_write_en,
    i_read_addr,
    i_write_addr,
    i_write_data,
    o_read_data
);

    /** Memory Parameters **/
    parameter MEM_SIZE = 32;     // 32 memory elements
    parameter WORD_SIZE = 16;

    /** Port Declarations **/
    input wire i_CLK, i_read_en, i_write_en;
    input wire [4:0] i_read_addr, i_write_addr;
    input wire [15:0] i_write_data;

    output wire [WORD_SIZE-1:0] o_read_data;

    /** Memory Instantiation **/
    reg [WORD_SIZE-1:0] r_ram [MEM_SIZE-1:0];

    initial begin
        $display("Loading memory");
        $readmemh("mem_inst.mem", r_ram);
    end

    /** Asynchronous Read Memory **/
    // Note: must have o_read_data as wire
    assign o_read_data = r_ram[i_read_addr];

    always @ (posedge i_CLK) begin
        /** Synchronous Read Memory **/
        // Note: must have o_read_data as reg
        //if (i_read_en==1'b1)
        //    o_read_data <= r_ram[i_read_addr];

        if (i_write_en==1'b1)
            r_ram[i_write_addr] <= i_write_data;
    end
endmodule
