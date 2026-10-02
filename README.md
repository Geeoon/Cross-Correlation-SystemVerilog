# Cross-Correlation Implementation in SystemVerilog
This project implements cross-correlation in hardware.

This implementation is done on a 1-bit input stream.  For my specific usage, this is necessary.

The output will have a latency of around `1 + ceil(log(<adder size>, N / <LUT size>)) cycles`, where `N` is the size of the kernel, `<adder_size>` is the number of adder inputs, and `<LUT size>` is the size of the LUTs.  Adder size and LUT size is determined by the FPGA you are targetting.  Most modern FPGAs will use a LUT6.  The adder size is depent on your acceleration options.

Throughput will be 1 correlation per cycle.
