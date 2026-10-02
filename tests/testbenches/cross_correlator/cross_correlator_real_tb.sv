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

    // loaded binaries
    int file_handle;
    logic [7:0] loaded_kernel [0:KERNEL_LENGTH-1];
    logic [7:0] loaded_trace [0:TRACE_LENGTH-1];
    logic [31:0] loaded_correlation [0:CORRELATION_LENGTH-1];

    int i = 1;
    initial begin
        // dump waveforms
        $dumpfile("waveforms/cross_correlator_real_tb.vcd");
        $dumpvars;

        $display(" -- Loading the trace binaries -- ");
        file_handle = $fopen("binaries/kernel.bin", "rb");
        if (file_handle == 0) begin
            $error("Filed to open kernel file");
            $finish;
        end
        $fread(loaded_kernel, file_handle);
        file_handle = $fopen("binaries/trace.bin", "rb");
        if (file_handle == 0) begin
            $error("Filed to open trace file");
            $finish;
        end
        $fread(loaded_trace, file_handle);
        file_handle = $fopen("binaries/correlation.bin", "rb");
        if (file_handle == 0) begin
            $error("Filed to open correlation file");
            $finish;
        end
        // load kernel into signal
        $fread(loaded_correlation, file_handle);
        for (int i = 0; i < KERNEL_LENGTH; i++) begin
            kernel[i] = loaded_kernel[i][0];
        end

        $display(" -- Starting cross_correlator tests on real traces -- ");

        // reset
        rst = 1;
        signal_in = loaded_trace[0][0];
        @(posedge clk);

        rst = 0;
        while (!valid) begin
            signal_in = loaded_trace[i][0];
            i++;
            @(posedge clk);
        end
        for (int j = 0; j < CORRELATION_LENGTH; j++) begin
            signal_in = loaded_trace[i+j][0];
            $display(i, j, out, loaded_correlation[j][OUT_SIZE-1:0]);
            //assert(out == loaded_correlation[j][OUT_SIZE-1:0]);
        end

        signal_in = 0;
        @(posedge valid);
        assert(out == 0);

        $finish;
    end
endmodule  // cross_correlator_real_tb
