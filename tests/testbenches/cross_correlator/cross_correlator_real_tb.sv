/**
 * @file cross_correlator_real_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the cross_correlator_real_tb module
 */

module cross_correlator_real_tb #(
    parameter int KERNEL_LENGTH=1458,
    parameter int CLOCK_PERIOD=100,
    parameter int TRACE_LENGTH=4000,

    localparam int OUT_SIZE=$clog2(KERNEL_LENGTH+1),
    localparam int CORRELATION_LENGTH=TRACE_LENGTH-KERNEL_LENGTH+1
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
        $dumpfile("waveforms/cross_correlator_real_tb.vcd");
        $dumpvars;

        $display(" -- Loading the trace binaries -- ");
        logic [7:0] loaded_kernel [0:KERNEL_LENGTH-1];
        logic [7:0] loaded_trace [0:TRACE_LENGTH-1];
        logic [31:0] loaded_correlation [0:CORRELATION_LENGTH-1];
        $loadmemb("binaries/kernel.bin", loaded_kernel);
        $loadmemb("binaires/trace.bin", loaded_trace);
        $loadmemb("binaires/correlation.bin", loaded_correlation);

        $display(" -- Starting cross_correlator tests on real traces -- ");

        // reset
        rst = 1;
        signal_in = 0;
        @(posedge clk);

        // rst = 0;
        // signal_in = 0;
        // @(posedge valid);
        // assert(out == 0);

        $finish;
    end
endmodule  // cross_correlator_real_tb
