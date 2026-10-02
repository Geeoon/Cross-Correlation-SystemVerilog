/**
 * @file input_shifter_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the input_shifter module
 */

module input_shifter_tb #(
    parameter int KERNEL_LENGTH=4,
    parameter int CLOCK_PERIOD=100
) ();
    // inputs
    logic clk, rst, in_signal;
    
    // outputs
    logic filled;
    logic [KERNEL_LENGTH-1:0] signal;

    input_shifter #(
        .KERNEL_LENGTH(KERNEL_LENGTH)
    ) dut (
        .clk, .rst, .in_signal,  // inputs
        .filled, .signal  // outputs
    );

    initial begin
        clk = 0;
        forever begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end  // forever
    end  // initial

    initial begin
        // dump waveforms
        $dumpfile("waveforms/input_shifter_tb.vcd");
        $dumpvars;

        $display(" -- Starting input_shifter test -- ");
        // reset
        rst = 1;
        in_signal = 1;
        #5;
        @(posedge clk); #5;
        rst = 0;
        
        for (int i = 0; i < 2 * KERNEL_LENGTH; i++) begin
            in_signal = ~in_signal;
            $display("fill: %b", dut.fill);
            $display("signal: %b", signal);
            $display("filled: %b\n", filled);
            @(posedge clk); #5;
        end

        $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // input_shifter_tb
