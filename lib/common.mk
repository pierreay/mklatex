ifndef MKLATEX_COMMON_H
MKLATEX_COMMON_H = true

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

# --- Publics

# Build directory to do all the work.
MKLATEX_BUILD_DIR := build

# Output directory for final file(s).
MKLATEX_OUT_DIR := out

# Source files directory (LaTeX, BibTeX, Graphics, Plots, etc.).
MKLATEX_SRC_DIR := src

# Graphics path.
MKLATEX_GFX_PATH := $(MKLATEX_SRC_DIR)/gfx

# Delete all out-of-tree build and output directories. 
MKLATEX_DISTCLEAN_DIRS += $(MKLATEX_BUILD_DIR) $(MKLATEX_OUT_DIR)

# --- Private

# Binaries and script directory.
_MKLATEX_BIN_DIR := bin

# Configuration files.
_MKLATEX_ETC_DIR := etc

# Targets
# ==============================================================================

# Create out directory.
$(MKLATEX_OUT_DIR):
	@mkdir -p $(MKLATEX_OUT_DIR)

# Create build directory.
$(MKLATEX_BUILD_DIR):
	@mkdir -p $(MKLATEX_BUILD_DIR)

endif
