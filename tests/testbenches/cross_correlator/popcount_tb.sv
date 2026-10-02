/**
 * @file popcount_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the popcount module
 */

module popcount_tb #(
    parameter int CLOCK_PERIOD=100,
    parameter int IN_LENGTH=1458,
    parameter int LUT_SIZE=6,
    parameter int ADDER_SIZE=3,

    localparam int DEPTH=clogb_n(ADDER_SIZE, IN_LENGTH / LUT_SIZE)+1,
    localparam int OUTPUT_BITS=$clog2(IN_LENGTH+1)
) ();
    // inputs
    logic clk, start;
    logic [IN_LENGTH-1:0] in_arr;

    // outputs
    logic [OUTPUT_BITS-1:0] out_arr;
    logic valid;

    popcount #(
        .IN_LENGTH(IN_LENGTH),
        .LUT_SIZE(LUT_SIZE),
        .ADDER_SIZE(ADDER_SIZE)
    ) dut (
        .clk,
        .start,
        .in_arr,

        .out_arr,
        .valid
    );
    
    initial begin
        clk = 0;
        forever begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end  // forever
    end  // initial

    initial begin
        // dump waveforms
        $dumpfile("waveforms/popcount_tb.vcd");
        $dumpvars;

        $display(" -- Starting popcount test -- ");
        $display(" -- All 0s -- ");
        start = 1;
        in_arr = 0;
        @(posedge valid);
        assert(out_arr == '0);
        start = 0;
        @(negedge valid);

        $display("\n -- All 1s -- ");
        start = 1;
        in_arr = '1;
        @(posedge valid);
        assert(out_arr == {OUTPUT_BITS}'(IN_LENGTH));
        start = 0;
        @(negedge valid);

        $display("\n -- One Hot -- ");
        for (int i = 0; i < IN_LENGTH-1; i++) begin
            start = 1;
            in_arr = 1 << i;
            @(posedge valid);
            start = 0;
            assert(out_arr == 1);
            @(negedge valid);
        end

        $display("\n -- Two Hot -- ");
        for (int i = 0; i < IN_LENGTH-1; i++) begin
            for (int j = 0; j < IN_LENGTH-1; j++) begin
                if (i == j) continue;
                start = 1;
                in_arr = (1 << i) | (1 << j);
                @(posedge valid);
                start = 0;
                assert(out_arr == 2);
                @(negedge valid);
            end
        end

        $display("\n -- Pipeline -- ");
        for (int i = 0; i < DEPTH; i++) begin
            #5; assert(valid == 0);
            start = 1;
            in_arr = (2**i)-1;
            #5; @(posedge clk);
        end
        #10; start = 0;
        
        for (int i = 0; i < DEPTH; i++) begin
            #5; assert(valid == 1);
            assert(out_arr == {OUTPUT_BITS}'(i));
            @(posedge clk);
        end
        #1; assert(valid == 0);

        $display("\n -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // popcount_tb
