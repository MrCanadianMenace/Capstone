module fft_layer
#(  parameter FFT_SIZE = 8,
    parameter LAYER_NUM = 0,
    parameter ADDR_SIZE = 5,
    parameter TWID_ADDR_SIZE = $clog2(127) )
(
    input wire i_CLK, 
    input wire i_RST,

    output reg o_done,
    output reg o_rden,
    output reg o_wren,
    output wire [ADDR_SIZE-1:0] o_rdaddr_A,
    output wire [ADDR_SIZE-1:0] o_rdaddr_B,
    output wire [TWID_ADDR_SIZE-1:0] o_rdaddr_tw
);

/** DFT Block Parameters
*   Each individual DFT block will be called a
*   partition.  This simplifies organizing every 
*   individual DFT block
*
*   LAYER_ORDER: Useful variable for determining
*       the size and number of partitions using
*       overall FFT size and layer number which
*       can be iterated over
*   NUM_PARTS: Number of partitions in this 
*       layer
*   PART_LEN: Length of each partition
*   PART_MID: Midpoint location of each 
*       partition, used to pick elements for 
*       butterfly sums
**/
parameter LAYER_ORDER = $clog2(FFT_SIZE) - 1 - LAYER_NUM;
parameter NUM_PARTS = 1 << LAYER_ORDER; // 2 ^ LAYER_ORDER
parameter PART_LEN = FFT_SIZE / NUM_PARTS;
parameter PART_MID = PART_LEN / 2;

/** Register Sizing Parameters
*   Parameters for determining the number of
*   bits for the partition iterator and 
*   position iterator
*
*   POS_DONE: A position 2 clock cycles after
*       partition length so that data in the
*       fft pipe may reach the write phase
*   PART_ITR_SIZE: Partition Iterator Size
*   POS_ITR_SIZE:  Position Iterator Size
**/
parameter POS_DONE      = PART_LEN+2;
parameter PART_ITR_SIZE = $clog2(NUM_PARTS);
parameter POS_ITR_SIZE  = $clog2(POS_DONE);

// TODO: Debug print important information
initial begin
    $display("FFTsize=%d, LayerOrder=%d, NumberPartitions=%d", FFT_SIZE, LAYER_ORDER, NUM_PARTS);
    $display("PartitionLength=%d, PartitionMid=%d", PART_LEN, PART_MID);
    $display("PartItrSize=%d, PositionItrSize=%d", PART_ITR_SIZE, POS_ITR_SIZE);
end

/** FFT Layer Iterators **/
reg [PART_ITR_SIZE-1:0] POSITION  = 'h0;
reg [POS_ITR_SIZE-1:0]  PARTITION = 'h0;

/** Variable Read Address Ports **/
wire DISPLACED_POSITION = POSITION + PARTITION * PART_LEN; //TODO: Maybe replace with cumulative partition displacement
assign o_rdaddr_A = DISPLACED_POSITION;
assign o_rdaddr_B = DISPLACED_POSITION + PART_MID;

always @ (posedge i_CLK, posedge i_RST) begin

    // Reset signal received so apply 0 to everything
    if (i_RST == 1'b1) begin
        POSITION    <= 'h0;
        PARTITION   <= 'h0;
        o_done      <= 1'b0;
        o_rden      <= 1'b0;
        o_wren      <= 1'b0;
    end

    else begin
        o_rdaddr_tw <= 'd0;

        // Walk through several memory addresses to read from
        case (POSITION)
            // Starting position, enable reading
            'h0: begin
                o_rden      <= 'b1;
                POSITION    <= POSITION + 1;
            end

            // First calculated value has reached writing phase
            // so let's enable writing so it can be written to
            // memory
            'h2: begin
                o_wren      <= 'h1;
                POSITION	<= POSITION + 1;
            end

            // Reached the end of current partition.  Increase
            // partition iterator and reset position iterator
            PART_LEN-1: begin

                // If we're at the last partition then continue
                // increasing position to the DONE position so
                // that remaining values can reach write stage
                // and disable reading
                if (PARTITION == NUM_PARTS-1) begin
                    o_rden      <= 1'b0;
                    POSITION    <= POSITION + 1;
                end 

                // Otherwise, start reading for next partition
                else
                    POSITION    <= 'h0;
                    PARTITION   <= PARTITION + 1;
                end
            end
                
            // Finished writing out remaining data in pipe
            // stay at this state and set done flag
            POS_DONE: begin
                o_done  <= 1'b1;
                o_wren  <= 1'b0;
            end
                    
            // Nothing special at this state, move on to
            // the next
            default: begin 
                POSITION    <= POSITION + 1;
            end

        endcase
    end // end if
end // end always

endmodule
