module hex_driver (
    input wire [3:0] i_hex,
    output reg [6:0] o_seg
);

always @ (i_hex) begin
    case(i_hex) 
        4'h0: o_seg = 7'b1_00_00_00;
        4'h1: o_seg = 7'b1_11_10_01;
        4'h2: o_seg = 7'b0_10_01_00;
        4'h3: o_seg = 7'b0_11_00_00;
        4'h4: o_seg = 7'b0_01_10_01;
        4'h5: o_seg = 7'b0_01_00_10;
        4'h6: o_seg = 7'b0_00_00_10;
        4'h7: o_seg = 7'b1_11_10_00;
        4'h8: o_seg = 7'b0_00_00_00;
        4'h9: o_seg = 7'b0_01_00_00;
        4'hA: o_seg = 7'b0_00_10_00;
        4'hB: o_seg = 7'b0_00_00_11;
        4'hC: o_seg = 7'b1_00_01_10;
        4'hD: o_seg = 7'b0_10_00_01;
        4'hE: o_seg = 7'b0_00_01_10;
        4'hF: o_seg = 7'b0_00_11_10;

    endcase
end

endmodule
