module scramble
#( parameter WORD_SIZE = 74,
   parameter ADDR_SIZE = 5,
   parameter FFT_SIZE = 4,
   parameter MAX_STATE = FFT_SIZE/2 )
(
    input i_CLK,
    input i_RST,
    input [WORD_SIZE-1:0] i_rddata_A,
    input [WORD_SIZE-1:0] i_rddata_B,

    output reg o_rden,
    output reg o_wren,
    output reg o_done,
    output reg  [ADDR_SIZE-1:0] o_rdaddr_A,
    output reg  [ADDR_SIZE-1:0] o_rdaddr_B,
    output wire [ADDR_SIZE-1:0] o_wraddr_A,
    output wire [ADDR_SIZE-1:0] o_wraddr_B,
    output wire [WORD_SIZE-1:0] o_wrdata_A,
    output wire [WORD_SIZE-1:0] o_wrdata_B
);

/** Useful Parameter **/
// Add 1 to Max State to account for extra clock cycle 
// in bit swap pipeline
parameter STATE_SIZE = $clog2(MAX_STATE+1);
// Create a size to be used for bit swapping specifically
parameter FLIP_SIZE = $clog2(FFT_SIZE);

/** Internal Registers/Wires **/
reg  [STATE_SIZE-1:0] STATE = 'h0;
wire [FLIP_SIZE-1:0] w_wraddr_flip_A, w_wraddr_flip_B;

bit_flip 
#( .WORD_SIZE(WORD_SIZE),
   .ADDR_SIZE(FLIP_SIZE) )
flip_A
(
    // Inputs
    .i_CLK(i_CLK),
    .i_pipeaddr_A(o_rdaddr_A[FLIP_SIZE-1:0]),
    .i_pipeaddr_B(o_rdaddr_B[FLIP_SIZE-1:0]),
    .i_pipedata_A(i_rddata_A),
    .i_pipedata_B(i_rddata_B),

    // Outputs
    .o_pipeaddr_A(w_wraddr_flip_A),
    .o_pipeaddr_B(w_wraddr_flip_B),
    .o_pipedata_A(o_wrdata_A),
    .o_pipedata_B(o_wrdata_B)
);

// Offset the flipped write address
assign o_wraddr_A = w_wraddr_flip_A + FFT_SIZE;
assign o_wraddr_B = w_wraddr_flip_B + FFT_SIZE;


always @ (posedge i_CLK, posedge i_RST) begin

    if (i_RST) begin
        STATE       <= 'h0;
        o_rdaddr_A  <= 'h0;
        o_rdaddr_B  <= 'h0;
        o_rden      <= 1'b0;
        o_wren      <= 1'b0;
        o_done      <= 1'b0;
    end

    else begin
        case (STATE)
            'h0: begin
                // Enable reading/writing to  memory
                o_rden      <= 1'b1;
                // Set starting memory addresses
                o_rdaddr_A  <= 'h0;
                o_rdaddr_B  <= 'h1;

                // Go to next state
                STATE       <= STATE + 1;
            end

            'h1: begin
                // Enable reading/writing to  memory
                o_wren  <= 1'b1;
                // Set starting memory addresses
                o_rdaddr_A  <= o_rdaddr_A + 2;
                o_rdaddr_B  <= o_rdaddr_B + 2;

                // Go to next state
                STATE       <= STATE + 1;
            end

            // Finished scrambling data so disable memory
            // operations and set done pin
            MAX_STATE: begin
                // Disable reading from memory
                o_rden  <= 1'b0;
                STATE   <= STATE + 1;
            end

            MAX_STATE+1: begin
                // Disable writing to memory
                o_wren  <= 1'b0;
                // Set the done bin to show this layer is done
                o_done  <= 1'b1;
            end

            // For the default case simply increase STATE
            default: begin
                // Set starting memory addresses
                o_rdaddr_A  <= o_rdaddr_A + 2;
                o_rdaddr_B  <= o_rdaddr_B + 2;

                STATE   <= STATE + 1;
            end
        endcase
    end
end

endmodule
