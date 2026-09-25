/**
 * @file input_shifter.sv
 * @author Geeoon Chung
 * @brief shifts inputs into a packed array
 * @param KERNEL_SIZE       the size of the kernel, in terms of number of samples
 * @param[in] clk           the clock driving the sequential logic
 * @param[in] rst           the signal to reset the kernel fill. does not set
 *                          the signal buffer to zeros
 * @param[in] signal_in     the new sample from the actual signal
 * @param[out] filled       whether or not the signal has finished loading in the buffer
 * @param[out] signal       the current signal
 */
module input_shifter #(
    parameter int KERNEL_LENGTH,

    localparam int KERNEL_SIZE=$clog2(KERNEL_LENGTH)
)(
    input logic clk,
    input logic rst,
    input logic signal_in,

    output logic filled,
    output logic [KERNEL_LENGTH-1:0] signal
);
    logic [KERNEL_SIZE:0] fill;

    always_ff @(posedge clk) begin
        // shift, always do this
        signal <= { signal_in, signal[KERNEL_LENGTH-1:1] };
        if (rst) begin
            fill <= '0;
        end else if (!filled) begin
            // increment until filled
            fill <= fill + 1;
        end
    end  // always_ff

    assign filled = (fill == {KERNEL_SIZE+1}'(KERNEL_LENGTH));
endmodule  // input_shifter
