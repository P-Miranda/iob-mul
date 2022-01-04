SIM_DIR := hardware/simulation/icarus

corename:
	@echo "MUL"

sim:
	make -C $(SIM_DIR)

clean:
	make -C $(SIM_DIR) clean

.PHONY: corename sim clean
