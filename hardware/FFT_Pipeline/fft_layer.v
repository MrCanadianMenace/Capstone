module fft_layer
#(  parameter FFT_SIZE = 8,
    parameter MEM_OFFSET = 0,
    parameter LAYER_NUM = 0,
    parameter ADDR_SIZE = 5,
    parameter TWID_ADDR_SIZE = $clog2(127) )
(
    input i_CLK, 
    input i_RST,
    input i_CS,

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
parameter TWIDDLE_OFFSET = (LAYER_NUM == 0) ? 0 : (1 << LAYER_NUM) - 1; // 2 ^ (LayerNum - 1) - 1

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
parameter POS_DONE      = PART_MID+1;
parameter PART_ITR_SIZE = $clog2(NUM_PARTS);
parameter POS_ITR_SIZE  = $clog2(POS_DONE+1);

// TODO: Debug print important information
initial begin
    $display("LayerNumber=%d, LayerOrder=%d", LAYER_NUM, LAYER_ORDER);
    $display("FFTsize=%d, NumberPartitions=%d, TwiddleOffset=%d", FFT_SIZE, NUM_PARTS, TWIDDLE_OFFSET);
    $display("PartitionLength=%d, PartitionMid=%d", PART_LEN, PART_MID);
    $display("PartItrSize=%d, PositionItrSize=%d\n\n", PART_ITR_SIZE, POS_ITR_SIZE);
end

/** FFT Layer Iterators **/
reg [POS_ITR_SIZE-1:0]  POSITION  = 'h0;
reg [PART_ITR_SIZE-1:0] PARTITION = 'h0;

/** Write delay register **/
reg r_wrdelay;

/** Variable Read Address Ports **/
wire [ADDR_SIZE-1:0] DISPLACED_POSITION = POSITION + PARTITION * PART_LEN + MEM_OFFSET; //TODO: Maybe replace with cumulative partition displacement
assign o_rdaddr_A = DISPLACED_POSITION;
assign o_rdaddr_B = DISPLACED_POSITION + PART_MID;
assign o_rdaddr_tw = POSITION + TWIDDLE_OFFSET;

always @ (posedge i_CLK, posedge i_RST) begin

    // Reset signal received so apply 0 to everything
    if (i_RST) begin
        POSITION    <= 'h0;
        PARTITION   <= 'h0;
        o_done      <= 1'b0;
        o_rden      <= 1'b1;
        o_wren      <= 1'b0;
        r_wrdelay   <= 2'h0;
    end

    else if (i_CS) begin

        /** Write Delay Counter
        *   Small counter that counts 2 clock edges
        *   then sets memory write enable high so 
        *   that writing won't begin until data 
        *   reaches writing stage of fft pipe
        **/
        if (r_wrdelay == 1'b1) 
            o_wren <= 1'b1;
        else
            r_wrdelay   <= r_wrdelay + 1; 

        // Walk through several memory addresses to read from
        case (POSITION)
            // Reached the end of current partition.  Increase
            // partition iterator and reset position iterator
            PART_MID-1: begin
                // If we're at the last partition then continue
                // increasing position to the DONE position so
                // that remaining values can reach write stage
                // and disable reading
                if (PARTITION == NUM_PARTS-1) begin
                    o_rden      <= 1'b0;
                    POSITION    <= POSITION + 1;
                end 

                // Otherwise, start reading for next partition
                else begin
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
