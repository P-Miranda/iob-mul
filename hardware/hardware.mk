#add itself to MODULES list
MODULES+=$(shell make -C $(MUL_DIR) corename | grep -v make)
