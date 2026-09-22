/**
 * @file multiplier_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the multiplier module
 */
module multiplier_tb #(
    SIGNAL_LENGTH=512
) ();
    // inputs
    logic [SIGNAL_LENGTH-1:0] signal_1, signal_2;

    // outputs
    logic [SIGNAL_LENGTH-1:0] out;

    multiplier #(
        .SIGNAL_LENGTH(SIGNAL_LENGTH)
    ) dut (
        .signal_1,
        .signal_2,
        .out
    );

    initial begin
        $dumpfile("waveforms/multiplier_tb.vcd");
        $dumpvars;

        $display(" -- Starting tests for multiplier -- ");
        signal_1 = '0;
        signal_2 = '1;
        #100;

        for (int i = 0; i < SIGNAL_LENGTH; i++) begin
            signal_1 = 1 << i;
            #100;
            assert(signal_1 == out);
            assert($onehot(out));
        end

        $display(" -- Finished tests -- ");

        $finish;
    end  // initial
endmodule  // multiplier_tb
