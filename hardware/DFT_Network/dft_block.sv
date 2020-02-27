module butterfly_sum #(parameter WORD_SZ = 8)
    (
            i_CLK,
            i_RESET,
            in1,
            in2,
            out1,
            out2
    );


    // Declaration of port types
    input wire i_CLK, i_RESET;
    input wire [WORD_SZ-1:0] in1; 
    input wire [WORD_SZ-1:0] in2; 
    output reg [WORD_SZ-1:0] out1;
    output reg [WORD_SZ-1:0] out2;

    // Useful constant for splitting registers in half
    parameter midpoint = WORD_SZ/2;
	 
    twiddle_ram (
        .address_a(),
        .address_b(),
        .clock(),
        .data_a(),
        .data_b(),
        .rden_a(),
        .rden_b(),
        .wren_a(),
        .wren_b(),
        .q_a(),
        .q_b()
    );

    
endmodule
