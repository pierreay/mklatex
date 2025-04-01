# Common default
# ==============================================================================

include make/common.mk

# Variables
# ==============================================================================

# Build directory to do all the work.
BUILD_DIR := build

# Output directory for final file(s).
OUT_DIR := out

# Utilities script directory.
UTILS_DIR := utils

# Source files directory.
SRC_DIR := src

# Git modules directory.
MOD_DIR := modules

# Graphics path.
GFX_PATH := $(SRC_DIR)/gfx

# Delete all out-of-tree build and output directories. 
DISTCLEAN_DIRS += $(BUILD_DIR) $(OUT_DIR)

# Targets
# ==============================================================================

# Default target definition according to GNU guidelines.
.DEFAULT_GOAL := all

# Default target redirection to a specific module.
all: latex

# Create out directory.
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Create build directory.
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Modules
# ==============================================================================

include make/drawio.mk
include make/inkscape.mk
include make/biblio.mk
include make/import.mk
include make/latex.mk
include make/clean.mk

# Helper
# ==============================================================================

.PHONY: help
help:
	@echo -e "Usage: make [target] [variable]"
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\tlatex\t\t\t\tBuild the LaTeX final document."
	@echo -e "\tdrawio\t\t\t\tBuild DrawIO figures."
	@echo -e "\tinkscape\t\t\tBuild Inkscape figures."
	@echo -e "\tbiblio\t\t\t\tImport bibliography."
	@echo -e "\tclean\t\t\t\tDelete auxiliary build files."
	@echo -e "\tmrproper\t\t\tDelete viewable build files."
	@echo -e "\tdistclean\t\t\tDelete final files."
	@echo -e ""
	@echo -e "Modules:"
	@echo -e "\tlatex-*\t\t\t\tOperate on LaTeX documents."
	@echo -e "\tdrawio-*\t\t\tOperate DrawIO figures."
	@echo -e "\tinkscape-*\t\t\tOperate Inkscape figures."
	@echo -e "\tbiblio-*\t\t\tOperate on external bibliography."
	@echo -e ""
	@echo -e "Submake:"
	@echo -e "\tcd docker && make help\t\tOperate inside a Docker container."
	@echo -e ""
	@echo -e "Partial build:"
	@echo -e "\t$(LATEX_BUILD_DIR)/*.pdf\t\t\tBuild the PDF of the corresponding LaTeX source."
	@echo -e "\t$(DRAWIO_BUILD_DIR)/*.pdf\t\tBuild the PDF of the corresponding DrawIO figure."
	@echo -e "\t$(INKSCAPE_BUILD_DIR)/*.pdf\tBuild the PDF of the corresponding Inkscape figure."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tLATEX_ONESHOT\t\t\tPerform only one single compilation pass without glossary or bibliography if defined (may lead to a broken document)."
	@echo -e "\tLATEX_GS_PDFSETTINGS\t\tCompression level for document post-processing [screen | ebook | printer | prepress]. (Default: $(LATEX_GS_PDFSETTINGS))"
	@echo -e "\tNPROCS\t\t\t\tNumber of jobs to parallize the build. (Default: $(NPROCS))"
