HDL_DIR := ../rtl
BUILD_DIR := ./build
TB_DIR := ./testbenches
WAVEFORM_DIR := ./waveforms

HDL_FILES := $(shell find $(HDL_DIR) -name '*.sv' -or -name '*.v' -or -name '*.svh')
TB_FILES := $(shell find $(TB_DIR) -name '*.sv' -or -name '*.v')

VERILATOR_BUILD_DIR := $(BUILD_DIR)/verilator
VERIALTOR_FLAGS := --binary -j 0 --trace --no-stop-fail -Mdir $(VERILATOR_BUILD_DIR)

all: $(WAVEFORM_DIR)/input_shifter_tb.vcd

# Verilator
$(WAVEFORM_DIR)/input_shifter_tb.vcd: $(HDL_FILES) $(TB_FILES)
	mkdir -p $(VERILATOR_BUILD_DIR) $(WAVEFORM_DIR)
	verilator $(VERIALTOR_FLAGS) --top-module input_shifter_tb $(HDL_FILES) $(TB_FILES)
	$(VERILATOR_BUILD_DIR)/Vinput_shifter_tb

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(WAVEFORM_DIR)

FORCE: ;

