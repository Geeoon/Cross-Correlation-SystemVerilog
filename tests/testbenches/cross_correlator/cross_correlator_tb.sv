/**
 * @file cross_correlator_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the cross_correlator_tb module
 */

module cross_correlator_tb #(
    parameter int KERNEL_LENGTH=64,
    parameter int CLOCK_PERIOD=100,

    localparam int OUT_SIZE=$clog2(KERNEL_LENGTH+1)
) ();
    // inputs
    logic clk, rst, signal_in;
    logic [KERNEL_LENGTH-1:0] kernel;

    // outputs
    logic valid;
    logic [OUT_SIZE-1:0] out;

    cross_correlator #(
        .KERNEL_LENGTH(KERNEL_LENGTH)
    ) dut (
        .clk,
        .rst,
        .signal_in,
        .kernel,
        .valid,
        .out
    );

    initial begin
        clk = 0;
        forever begin
            #((CLOCK_PERIOD/2)-5) clk = ~clk; #5;
        end  // forever
    end  // initial

    initial begin
        // dump waveforms
        $dumpfile("waveforms/cross_correlator_tb.vcd");
        $dumpvars;

        $display(" -- Starting cross_correlator test -- ");

        $display(" -- Null kernel with null signal -- ");
        // reset
        rst = 1;
        signal_in = 0;
        @(posedge clk);

        rst = 0;
        signal_in = 0;
        @(posedge valid);
        assert(out == 0);

        $display(" -- Null kernel with '1 signal -- ");
        // reset
        rst = 1;
        signal_in = 0;
        @(negedge valid);

        rst = 0;
        signal_in = 1;
        @(posedge valid);
        assert(out == 0);

        $display(" -- '1 kernel with null signal -- ");
        // reset
        rst = 1;
        signal_in = 0;
        @(negedge valid);

        rst = 0;
        signal_in = 0;
        kernel = '1;
        @(posedge valid);
        assert(out == 0);

        $display(" -- '1 kernel with '1 signal -- ");
        // reset
        rst = 1;
        signal_in = 1;
        @(negedge valid);

        rst = 0;
        signal_in = 1;
        kernel = '1;
        @(posedge valid);
        assert(out == {OUT_SIZE}'(KERNEL_LENGTH));

        $display(" -- Alternating 0 and 1, in phase -- ");
        // reset
        rst = 1;
        signal_in = 0;
        // set the kernel to be alternating 0 and 1
        for (int i = 0; i < KERNEL_LENGTH; i++) begin
            kernel[i] = 1'(i % 2);
        end  // for
        @(negedge valid);

        rst = 0;
        while (!valid) begin
            signal_in = ~signal_in;
            @(posedge clk);
        end  // while
        assert(out == {OUT_SIZE}'(KERNEL_LENGTH / 2));

        $display(" -- Alternating 1 and 0, in phase -- "); 
        // reset
        rst = 1;
        signal_in = 1;
        // set the kernel to be alternating 0 and 1
        for (int i = 0; i < KERNEL_LENGTH; i++) begin
            kernel[i] = 1'((i+1) % 2);
        end  // for
        @(negedge valid);

        rst = 0;
        while (!valid) begin
            signal_in = ~signal_in;
            @(posedge clk);
        end  // while
        assert(out == {OUT_SIZE}'(KERNEL_LENGTH / 2));

        $display(" -- Alternating 0 and 1, out of phase -- ");
        // reset
        rst = 1;
        signal_in = 1;
        // set the kernel to be alternating 0 and 1
        for (int i = 0; i < KERNEL_LENGTH; i++) begin
            kernel[i] = 1'(i % 2);
        end  // for
        @(negedge valid);

        rst = 0;
        while (!valid) begin
            signal_in = ~signal_in;
            @(posedge clk);
        end  // while
        assert(out == '0);

        $display(" -- Alternating 1 and 0, out of phase -- "); 
        // reset
        rst = 1;
        signal_in = 0;
        // set the kernel to be alternating 0 and 1
        for (int i = 0; i < KERNEL_LENGTH; i++) begin
            kernel[i] = 1'((i+1) % 2);
        end  // for
        @(negedge valid);

        rst = 0;
        while (!valid) begin
            signal_in = ~signal_in;
            @(posedge clk);
        end  // while
        assert(out == '0);

        $display(" -- Pipeline test -- ");
        // reset
        rst = 1;
        signal_in = 0;
        kernel = '1;
        #5; @(posedge clk); #5;

        rst = 0;
        signal_in = 0;
        @(posedge valid);  // pipeline filled
        assert(out == 0);
        signal_in = 1;
        while (out == 0) @(posedge clk);
        for (int i = 1; i <= KERNEL_LENGTH; i++) begin
            // $display("%d, %d, %b", out, i, valid);
            assert(out == {OUT_SIZE}'(i));
            @(posedge clk);
        end  // while

        $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // cross_correlator_tb
