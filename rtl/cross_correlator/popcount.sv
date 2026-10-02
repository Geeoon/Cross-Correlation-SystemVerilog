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

// Constant function to compute ceil(log_base(value))
function automatic integer clogb_n;
    input integer base;
    input integer value;
    integer temp;
    begin
        clogb_n = 0;
        temp = 1;
        while (temp < value) begin
            temp = temp * base;
            clogb_n = clogb_n + 1;
        end
    end
endfunction

module popcount #(
    parameter int IN_LENGTH,
    parameter int LUT_SIZE=4,
    parameter int ADDER_SIZE=2,

    localparam int DEPTH=clogb_n(ADDER_SIZE, IN_LENGTH / LUT_SIZE),
    localparam int TOTAL_SIZE=LUT_SIZE * (ADDER_SIZE**(DEPTH-1)),
    localparam int OUTPUT_BITS=$clog2(IN_LENGTH+1),
    localparam int SUBSECTION_SIZE=TOTAL_SIZE/ADDER_SIZE
)(
    input logic clk,
    input logic start,
    input logic [IN_LENGTH-1:0] in_arr,

    output logic [OUTPUT_BITS-1:0] out_arr,
    output logic valid
);
    logic [TOTAL_SIZE-1:0] padded;
    assign padded = {TOTAL_SIZE}'(in_arr);  // pads to expected lengths
    if (DEPTH == 1)  // base case
        begin : DEPTH_eq_1
            // LUT compressor logic
            logic [OUTPUT_BITS-1:0] compressor;
            always_comb begin
                compressor = '0;
                for (int i = 0; i < LUT_SIZE; i++) begin
                    compressor = compressor + {OUTPUT_BITS}'(in_arr[i]);
                end  // for
            end  // always_comb
            // pipeline DFF
            always_ff @(posedge clk) begin
                valid <= start;
                out_arr <= compressor;
            end  // always_ff
        end  // DEPTH_eq_1
    else
        begin : DEPTH_gt_1  // recursive case
            logic [($clog2(SUBSECTION_SIZE+1))-1:0] outs [0:ADDER_SIZE-1];
            logic [ADDER_SIZE-1:0] valids;

            // submodules
            for (genvar i = 0; i < ADDER_SIZE; i++) begin
                popcount #(
                    .IN_LENGTH(SUBSECTION_SIZE),
                    .LUT_SIZE(LUT_SIZE),
                    .ADDER_SIZE(ADDER_SIZE)
                ) popcount_section (
                    .clk,
                    .start,
                    .in_arr(in_arr[((i+1)*SUBSECTION_SIZE)-1:i*SUBSECTION_SIZE]),
                    .out_arr(outs[i]),
                    .valid(valids[i])
                );
            end  // for

            // Adder optimization
            logic [OUTPUT_BITS-1:0] sum;
            always_comb begin
                sum = 0;
                for (int i = 0; i < ADDER_SIZE; i++) begin
                    sum = sum + {OUTPUT_BITS}'(outs[i]);
                end  // for
            end  // always_comb
            
            // pipeline
            always_ff @(posedge clk) begin
                valid <= &valids;
                out_arr <= sum;
            end  // always_ff
        end  // DEPTH_gt_1
endmodule
