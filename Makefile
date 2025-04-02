# Common default
# ==============================================================================

# If not defined, use the path of the main mklatex Makefile. It allows to use
# this Makefile with `make -f` without defining this variable. However, it must
# be defined when used with `include` directive.
MKLATEX_PATH ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

include $(MKLATEX_PATH)/common.mk

# Targets
# ==============================================================================

# Default target definition according to GNU guidelines.
.DEFAULT_GOAL := mklatex

# Default target redirection to a specific module.
mklatex: mklatex-latex

# Modules
# ==============================================================================

include $(MKLATEX_PATH)/mkrules.d/drawio.mk
include $(MKLATEX_PATH)/mkrules.d/inkscape.mk
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
	@echo -e "\tbiblio\t\t\t\tImport bibliography."
	@echo -e "\tclean\t\t\t\tDelete auxiliary build files."
	@echo -e "\tmrproper\t\t\tDelete viewable build files."
	@echo -e "\tdistclean\t\t\tDelete final files."
	@echo -e ""
	@echo -e "Modules:"
	@echo -e "\tlatex-*\t\t\t\tOperate on LaTeX documents."
	@echo -e "\tbiblio-*\t\t\tOperate on external bibliography."
	@echo -e ""
	@echo -e "Submake:"
	@echo -e "\tcd docker && make help\t\tOperate inside a Docker container."
	@echo -e ""
	@echo -e "Partial build:"
	@echo -e "\t$(LATEX_BUILD_DIR)/*.pdf\t\t\tBuild the PDF of the corresponding LaTeX source."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tLATEX_ONESHOT\t\t\tPerform only one single compilation pass without glossary or bibliography if defined (may lead to a broken document)."
	@echo -e "\tLATEX_GS_PDFSETTINGS\t\tCompression level for document post-processing [screen | ebook | printer | prepress]. (Default: $(LATEX_GS_PDFSETTINGS))"
	@echo -e "\tNPROCS\t\t\t\tNumber of jobs to parallize the build. (Default: $(NPROCS))"
