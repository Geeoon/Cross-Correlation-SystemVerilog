# Cross-Correlation Implementation in SystemVerilog
This project implements cross-correlation in hardware.

This implementation is done on a 1-bit input stream.  The output will also be a stream of `clog2(N+1)`-bit words.

The output will have a latency of `1 + ceil(log(<adder size>, N / <LUT size>)) cycles`, where `N` is the size of the kernel, `<adder_size>` is the number of adder inputs, and `<LUT size>` is the size of the LUTs.  Adder size and LUT size is determined by the FPGA you are targetting.  Most modern FPGAs will use a LUT6.  The adder size is dependent on your acceleration options.

Throughput will be 1 correlation per cycle.

## AMD Xilinx Spartan 7, Arty S7-25 (xc7s25-csga324-1)
For a 512 sample kernel, a maximum clock rate of 464 MHz was achieved.  The design used 25 LUTs and 18 FFs.  No RAM, URAM, or DSPs were used.
For a 1458 sample kernel, a maximum clock rate of 464 MHz was achieved.  The design used 55 LUTs and 19 FFs.  No RAM, URAM, or DSPs were used.
Unfortunately I don't want to spend over a hundred bucks on a dev board, so I have not tested this on real hardware yet.
