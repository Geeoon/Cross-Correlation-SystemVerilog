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
    (* adder_threshold = 4, dont_touch = "true" *) 
    logic [KERNEL_SIZE:0] fill;

    always_ff @(posedge clk) begin
        if (CONVOLVE) begin
            signal <= { signal[KERNEL_LENGTH-2:0], signal_in };
        end else begin
            signal <= { signal_in, signal[KERNEL_LENGTH-1:1] };
        end

        if (rst) begin
            filled <= 0;
            fill <= (KERNEL_SIZE+1)'(KERNEL_LENGTH - 1);
        end else begin
            fill <= fill - 1;
            filled <= (fill == 0) | filled;
        end
    end  // always_ff
endmodule  // input_shifter
