# Variables
# ==============================================================================

# Always use `bash`, not `sh`.
SHELL = /usr/bin/bash

# Colors for "echo -e".
_COL_OK  = \033[0;32m
_COL_ERR = \033[1;31m
_COL_WRN = \033[0;33m
_COL_RES = \033[0m

# Automatic parallelization of generic rules.
NPROCS     =  $(shell grep -c 'processor' /proc/cpuinfo)
MAKEFLAGS += -j$(NPROCS)
