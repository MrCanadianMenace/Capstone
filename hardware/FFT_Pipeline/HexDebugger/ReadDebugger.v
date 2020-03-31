module ReadDebugger
    #( parameter WORD_SIZE = 16,
       parameter MEM_SIZE = 32,
       parameter ADDR_SIZE = $clog2(MEM_SIZE))
    (
        input i_CLK,
        input i_memval,
        input i_pipeval,
        input wire [ADDR_SIZE-1:0] i_rdaddr_A,
        input wire [ADDR_SIZE-1:0] i_rdaddr_B,
        input wire [WORD_SIZE-1:0] i_rddata_A,
        input wire [WORD_SIZE-1:0] i_rddata_B,
        input wire [WORD_SIZE-1:0] i_pipedata_A,
        input wire [WORD_SIZE-1:0] i_pipedata_B,
        input wire [3:0]           i_STATE,

        output wire [6:0] o_HEX7,
        output wire [6:0] o_HEX6,
        output wire [6:0] o_HEX5,
        output wire [6:0] o_HEX4,
        output wire [6:0] o_HEX0
    );

/** Internal Hex Arrays **/
reg [1:0] decode;

wire [3:0] w_HEX_addr_in [3:0];
wire [3:0] w_HEX_val_in [3:0];
wire [3:0] w_HEX_pipe_in [3:0];
wire [6:0] w_HEX_addr_out [3:0];
wire [6:0] w_HEX_val_out [3:0];
wire [6:0] w_HEX_pipe_out [3:0];

/** Seven segment display array **/
wire [6:0] HEX_out [3:0];

assign o_HEX4 = HEX_out[2];
assign o_HEX5 = HEX_out[3];
assign o_HEX6 = HEX_out[0];
assign o_HEX7 = HEX_out[1];

/** Read Driver State **/
hex_driver STATE_HEX(i_STATE, o_HEX0);

// Assign input read addresses
assign w_HEX_addr_in[0] = i_rdaddr_A[3:0];
assign w_HEX_addr_in[1] = {{3{1'b0}}, i_rdaddr_A[4]};
assign w_HEX_addr_in[2] = i_rdaddr_B[3:0];
assign w_HEX_addr_in[3] = {{3{1'b0}}, i_rdaddr_B[4]};

// Assign output read data
assign w_HEX_val_in[0] = i_rddata_A[3:0];
assign w_HEX_val_in[1] = i_rddata_A[7:4];
assign w_HEX_val_in[2] = i_rddata_B[3:0];
assign w_HEX_val_in[3] = i_rddata_B[7:4];

// Assign piped output data
assign w_HEX_pipe_in[0] = i_pipedata_A[3:0];
assign w_HEX_pipe_in[1] = i_pipedata_A[7:4];
assign w_HEX_pipe_in[2] = i_pipedata_B[3:0];
assign w_HEX_pipe_in[3] = i_pipedata_B[7:4];

/** Generate Hex Drivers **/
genvar i;
generate
    for (i=0; i<4; i=i+1) 
    begin: BUILD_HEX_DRIVERS
        hex_driver ADDR_HEX(w_HEX_addr_in[i], w_HEX_addr_out[i]);
        hex_driver VAL_HEX(w_HEX_val_in[i], w_HEX_val_out[i]);
        hex_driver PIPE_HEX(w_HEX_pipe_in[i], w_HEX_pipe_out[i]);

        /** Logic for switching between address and value display modes **/
        assign HEX_out[i] = (~i_memval) ? w_HEX_addr_out[i] :
                            (i_pipeval) ? w_HEX_pipe_out[i] :
                            w_HEX_val_out[i];
    end 
endgenerate

wire [3:0] debug_hex_addr_in0 = w_HEX_addr_in[0];
wire [6:0] debug_hex_addr_out0 = w_HEX_addr_out[0];

endmodule
