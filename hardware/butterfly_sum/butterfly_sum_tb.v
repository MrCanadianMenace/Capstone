module butterfly_sum_tb;

reg     [31:0]
wire    []out

    initial begin
        $dumpfile("butterfly_sum_tb.vcd");
        $dumpvars(0, butterfly_sum_tb);

        #5 $finish;
    end
endmodule
