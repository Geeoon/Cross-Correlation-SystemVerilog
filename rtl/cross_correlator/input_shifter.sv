/**
 * @file input_shifter.sv
 * @author Geeoon Chung
 * @brief shifts inputs into a packed array
 * @param KERNEL_SIZE       the size of the kernel, in terms of number of samples
 * @param CONVOLVE          set to 1'b1 to do a convolution instead of correlation
 *                          (i.e., flip the kernel)
 * @param[in] clk           the clock driving the sequential logic
 * @param[in] rst           the signal to reset the kernel fill. does not set
 *                          the signal buffer to zeros
 * @param[in] signal_in     the new sample from the actual signal
 * @param[out] filled       whether or not the signal has finished loading in the buffer
 * @param[out] signal       the current signal
 */
module input_shifter #(
    parameter int KERNEL_LENGTH,
    parameter bit CONVOLVE=1'b0,
    
    localparam int KERNEL_SIZE=$clog2(KERNEL_LENGTH)
)(
    input logic clk,
    input logic rst,
    input logic signal_in,

    output logic filled,
    output logic [KERNEL_LENGTH-1:0] signal
);
    always_ff @(posedge clk) begin
        if (rst) begin
            // time and resource saving hack
            signal <= { 1'b1, {KERNEL_LENGTH-1}'(0) };
            filled <= 0;
        end else begin
            if (CONVOLVE) begin
                signal <= { signal[KERNEL_LENGTH-2:0], signal_in };
            end else begin
                signal <= { signal_in, signal[KERNEL_LENGTH-1:1] };
            end
        end

        // this hack helps remove a slow path.  originally, there was a counter
        // to determine when the signal had been fully filled.  This caused a
        // adder to by synthesized, which slowed down our entire design
        // with this hack, on reset we set the signal to '0, except for the first
        // sample, setting it to 1. when the 1 bit reaches the final sample,
        // set set a flip flop to 1.  the output of that flip flop determines
        // whether or not our signal has been filled. by doing this, we prevent
        // the synthesis of an adder, improving our timing and saving resources
        if (signal[0]) begin
            filled <= 1;
        end
    end  // always_ff
endmodule  // input_shifter
