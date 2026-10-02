/**
 * @file lfsr_timer_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the input_shifter module
 */

module lfsr_timer_tb #(
    parameter int COUNT=63,
    parameter int CLOCK_PERIOD=100
) ();
    // inputs
    logic clk, rst;

    // outputs
    logic done;

    lfsr_timer #(
        .COUNT(COUNT)
    ) dut (
        .clk, .rst,
        .done
    );

    initial begin
        clk = 0;
        forever begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end  // forever
    end  // initial

    initial begin
        // dump waveforms
        $dumpfile("waveforms/lfsr_timer_tb.vcd");
        $dumpvars;

        $display(" -- Starting lfsr_timer test -- ");
        // reset
        rst = 1;
        #5;
        @(posedge clk); #5;
        rst = 0;
        
        repeat(COUNT) begin
            assert(~done);
            @(posedge clk); #5;
        end  // repeat

        repeat(10) begin
            assert(done);
            @(posedge clk); #5;
        end  // repeat

        $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // lfsr_timer_tb
