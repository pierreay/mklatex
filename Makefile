# Variables
# ==============================================================================

# All variables are prefixed using:
# - `MKLATEX` for public variables.
# - `_MKLATEX` for private variables.

# Publics
# ------------------------------------------------------------------------------

# If not defined, use the path of top-level Makefile. It allows to use this
# Makefile with `make -f` without defining this variable. However, it must be
# defined when used with `include` directive.
MKLATEX_PATH ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

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

# Private
# ------------------------------------------------------------------------------

# Submakefiles to include.
_MKLATEX_MAKEFILES_DIR := make.d

# Binaries and script directory.
_MKLATEX_BIN_DIR := bin

# Common default
# ==============================================================================

include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/common.mk

# Targets
# ==============================================================================

# Default target definition according to GNU guidelines.
.DEFAULT_GOAL := mklatex

# Default target redirection to a specific module.
mklatex: mklatex-latex

# Create out directory.
$(MKLATEX_OUT_DIR):
	@mkdir -p $(MKLATEX_OUT_DIR)

# Create build directory.
$(MKLATEX_BUILD_DIR):
	@mkdir -p $(MKLATEX_BUILD_DIR)

# Modules
# ==============================================================================

include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/drawio.mk
include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/inkscape.mk
include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/biblio.mk
include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/latex.mk
include $(MKLATEX_PATH)/$(_MKLATEX_MAKEFILES_DIR)/clean.mk

# Helper
# ==============================================================================

.PHONY: mklatex-help
mklatex-help:
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
