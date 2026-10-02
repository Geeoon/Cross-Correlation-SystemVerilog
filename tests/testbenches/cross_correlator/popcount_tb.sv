/**
 * @file popcount_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the popcount module
 */

module popcount_tb #(
    parameter int DEPTH=9,
    parameter int CLOCK_PERIOD=100
) ();
    // inputs
    logic clk, start;
    logic [(2**DEPTH)-1:0] in_arr;

    // outputs
    logic [DEPTH:0] out_arr;
    logic valid;

    popcount #(
        .IN_LENGTH(2**DEPTH)
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

        // for (int i = 0; i < 100; i++) begin
        //     @(posedge clk);
        // end
        // $finish;
        
        @(posedge valid);
        assert(out_arr == '0);
        start = 0;
        @(negedge valid);

        $display("\n -- One Hot -- ");
        for (int i = 0; i < 2**DEPTH; i++) begin
            start = 1;
            in_arr = 1 << i;
            @(posedge valid);
            start = 0;
            assert(out_arr == 1);
            @(negedge valid);
        end

        $display("\n -- Two Hot -- ");
        for (int i = 0; i < 2**DEPTH; i++) begin
            for (int j = 0; j < 2**DEPTH; j++) begin
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
            assert(out_arr == {DEPTH+1}'(i));
            @(posedge clk);
        end
        #1; assert(valid == 0);

        $display("\n -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // input_shifter_tb
