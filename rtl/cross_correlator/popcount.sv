/**
 * @file popcount.sv
 * @author Geeoon Chung
 * @brief counts the 1 bits in a packed array (popcount) using a tree
 * @todo optimize for LUT size
 * @param DEPTH         the number of layers of the adder, log_2(# of samples)
 * @param[in] clk       the clock driving the sequential logic
 * @param[in] start     whether the inputs are valid or not
 * @param[in] in_arr    the input array to count
 * @param[out] out_arr  the solution
 * @param[out] valid    whether the output is valid or not
 */
module popcount #(
    parameter int DEPTH
)(
    input logic clk,
    input logic start,
    input logic [(2**DEPTH)-1:0] in_arr,

    output logic [DEPTH:0] out_arr,
    output logic valid
);

    generate
        if (DEPTH == 1)
            begin : DEPTH_eq_1
                always_ff @(posedge clk) begin
                    valid <= start;
                    out_arr <= in_arr[0] + in_arr[1];
                end  // always_ff
            end  // DEPTH_eq_1
        else
            begin : DEPTH_gt_1
                logic [DEPTH-1:0] left_out, right_out;
                logic left_valid, right_valid;
                
                popcount #(
                    .DEPTH(DEPTH-1)
                ) popcount_left (
                    .clk,
                    .start,
                    .in_arr(in_arr[(2**DEPTH)-1:2**(DEPTH-1)]),
                    .out_arr(left_out),
                    .valid(left_valid)
                );

                popcount #(
                    .DEPTH(DEPTH-1)
                ) popcount_right (
                    .clk,
                    .start,
                    .in_arr(in_arr[(2**(DEPTH-1))-1:0]),
                    .out_arr(right_out),
                    .valid(right_valid)
                );

                always_ff @(posedge clk) begin
                    valid <= left_valid & right_valid;
                    out_arr <= left_out + right_out;  // NOTE: this addition is probably a bottleneck
                end  // always_ff
            end  // DEPTH_gt_1
    endgenerate
endmodule
