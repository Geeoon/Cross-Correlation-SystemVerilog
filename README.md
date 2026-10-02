# Cross-Correlation Implementation in SystemVerilog
This project implements cross-correlation in hardware.

This implementation is done on a 1-bit input stream.  For my specific usage, this is necessary.

The output will have a latency of around 1 + log(N) cycles, where N is the size of the kernel.

