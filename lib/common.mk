ifndef MKLATEX_COMMON_H
MKLATEX_COMMON_H = true

# If defined, include the file defined by MKLATEX_INCLUDE_PRE before anything else.
# TODO: Use the same strategy at the end with a MKLATEX_INCLUDE_POST variable.
# However, it will requires code duplication or to modify the architecture of
# common.mk and main.mk because we don't know which file will be the end.
-include $(MKLATEX_INCLUDE_PRE)

# Variables
# ==============================================================================

# Always use `bash`, not `sh`.
SHELL := /usr/bin/bash

# Colors for "echo -e".
_COL_OK  := \033[0;32m
_COL_ERR := \033[1;31m
_COL_WRN := \033[0;33m
_COL_RES := \033[0m

# Use all available CPU cores when parallelizing.
NPROCS ?= $(shell grep -c 'processor' /proc/cpuinfo)
# Automatic parallelization of generic rules.
MAKEFLAGS += -j$(NPROCS)

# mklatex 
# ------------------------------------------------------------------------------

# All variables are prefixed using:
# - `MKLATEX` for public variables.
# - `_MKLATEX` for private variables.

# --- Publics (defining superproject structure)

# Build directory to do all the work.
# NOTE: Get from Bash environment.
MKLATEX_BUILD_DIR := ${MKLATEX_BUILD_DIR}

# Output directory for final file(s).
MKLATEX_OUT_DIR := out

# Source files directory (LaTeX, BibTeX, Graphics, Plots, etc.).
# NOTE: Get from Bash environment.
MKLATEX_SRC_DIR := ${MKLATEX_SRC_DIR}

# Configuration files directory.
MKLATEX_ETC_DIR := etc

# Graphics path.
MKLATEX_GFX_PATH := $(MKLATEX_SRC_DIR)/gfx

# Delete all out-of-tree build and output directories. 
MKLATEX_DISTCLEAN_DIRS += $(MKLATEX_BUILD_DIR) $(MKLATEX_OUT_DIR)

# --- Private (defining mklatex structure)

# Binaries and script directory.
_MKLATEX_BIN_DIR := bin

# Configuration files.
_MKLATEX_ETC_DIR := etc

# External modules.
_MKLATEX_EXT_DIR := ext

# Targets
# ==============================================================================

# Create out directory.
$(MKLATEX_OUT_DIR):
	@mkdir -p $(MKLATEX_OUT_DIR)

# Create build directory.
$(MKLATEX_BUILD_DIR):
	@mkdir -p $(MKLATEX_BUILD_DIR)

endif
