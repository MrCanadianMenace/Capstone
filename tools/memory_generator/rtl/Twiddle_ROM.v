module Twiddle_ROM 
    # (parameter WORD_SIZE = 74,
       parameter MEM_SIZE = 127,
       parameter ADDR_SIZE = $clog2(MEM_SIZE))
    (
        input wire i_read_en,
        input wire  [ADDR_SIZE-1:0] i_read_addr,

        output wire [WORD_SIZE-1:0] o_read_data
    );

    /* Block Memory Definition */
    reg [WORD_SIZE-1:0] ROM [MEM_SIZE-1:0];

    initial begin
        $display("Loading memory");
        $readmemh("twid.mem", ROM);
    end

    /** Asynchronous Reading **/
    assign o_read_data = (i_read_en) ? ROM[i_read_addr] : 16'h0;

endmodule
