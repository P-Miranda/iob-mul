# Simulation frequency

# File paths
ROOT_DIR := ../../..
HW_DIR := $(ROOT_DIR)/hardware

TB_DEFINE += -DVCD

# Icarus verilog simulator
VLOG := iverilog -Wall -g2005-sv

# Hardware sources
VSRC_PIPE := $(HW_DIR)/src/xmul_pipe.v $(HW_DIR)/testbench/xmul_pipe_tb.v
VSRC_SERIAL := $(HW_DIR)/src/mul_addshift.v $(HW_DIR)/testbench/mul_addshift_tb.v

all: 

pipe: $(VSRC_PIPE)
	$(VLOG) $(TB_DEFINE) $(VSRC_PIPE)
	./a.out

addshift: $(VSRC_SERIAL)
	$(VLOG) $(TB_DEFINE) $(VSRC_SERIAL)
	./a.out

clean: 
	@rm -f *~ *# *.vcd a.out

.PHONY: all pipe addshift sim-waves clean
