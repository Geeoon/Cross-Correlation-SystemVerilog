/**
 * @file input_shifter.sv
 * @author Geeoon Chung
 * @brief shifts inputs into a packed array
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
