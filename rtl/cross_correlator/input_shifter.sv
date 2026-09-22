/**
 * @file input_shifter.sv
 * @author Geeoon Chung
 * @brief shifts inputs into a packed array
 * @param KERNEL_SIZE       the size of the kernel, in terms of 2^KERNEL_SIZE
 * @param[in] clk           the clock driving the sequential logic
 * @param[in] rst           the signal to reset the kernel fill
 * @param[in] in_signal     the in_signal the new sample from the actual signal
 * @param[in] in_kernel     the next sample from the kernel
 * @param[out] filled       whether or not the kernel has finished loading
 * @param[out] signal       the current signal
 * @param[out] kernel       the loaded kernel
 */
module input_shifter #(
    parameter KERNEL_SIZE=9
)(
    input logic clk,
    input logic rst,
    input logic in_signal,
    input logic in_kernel,

    output logic filled,
    output logic [(2**KERNEL_SIZE)-1:0] signal,
    output logic [(2**KERNEL_SIZE)-1:0] kernel
);
    logic [KERNEL_SIZE:0] fill;

    always_ff @(posedge clk) begin
        // shift signal, always do this
        signal <= { signal[(2**KERNEL_SIZE)-2:0], in_signal };
        if (rst) begin
            fill <= '0;
        end else begin
            // shift kernel, if not yet filled
            if (!filled) begin
                fill <= fill + 1;
                kernel <= { kernel[(2**KERNEL_SIZE)-2:0], in_kernel };
            end
        end
    end  // always_ff

    assign filled = fill[KERNEL_SIZE];
endmodule  // input_shifter
