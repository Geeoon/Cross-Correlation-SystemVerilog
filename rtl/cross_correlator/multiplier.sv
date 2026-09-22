/**
 * @file multiplier.sv
 * @author Geeoon Chung
 * @brief element-wise multiplication of two signals with samples of 1-bit in
 * depth
 * @param SIGNAL_LENGTH     the length of the signal in terms of number of samples
 * @param[in] signal_1      the first operand
 * @param[in] signal_2      the second operand
 * @param[out] out          the result
 */
module multiplier #(
    parameter SIGNAL_LENGTH
)(
    input logic [SIGNAL_LENGTH-1:0]     signal_1,
    input logic [SIGNAL_LENGTH-1:0]     signal_2,

    output logic [SIGNAL_LENGTH-1:0]    out
);
    assign out = signal_1 & signal_2;
endmodule  // multiplier
