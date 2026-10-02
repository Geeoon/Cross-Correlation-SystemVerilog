/**
 * @file input_shifter_tb.sv
 * @author Geeoon Chung
 * @brief testbench for input_shifter module
 */

module input_shifter_tb #(
    parameter int KERNEL_SIZE=2,
    parameter int CLOCK_PERIOD=100
) ();
    // inputs
    logic clk, rst, in_signal, in_kernel;
    
    // outputs
    logic filled;
    logic [(2**KERNEL_SIZE)-1:0] signal, kernel;

    input_shifter #(
        .KERNEL_SIZE(KERNEL_SIZE)
    ) dut (
        .clk, .rst, .in_signal, .in_kernel,  // inputs
        .filled, .signal, .kernel  // outputs
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
        in_signal = 0;
        in_kernel = 1;
        @(posedge clk);
        rst = 0;
        
        for (int i = 0; i < 2 * (2**KERNEL_SIZE); i++) begin
            @(posedge clk);
            $display("fill: %b", dut.fill);
            $display("signal: %b", signal);
            $display("kernel: %b", kernel);
            $display("filled: %b\n", filled);
            in_signal = ~in_signal;
            in_kernel = ~in_kernel;
        end

        $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // input_shifter_tb
