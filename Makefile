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
include $(MKLATEX_PATH)/mkrules.d/latex.mk

# Goals
# ==============================================================================

.PHONY: clean mrproper distclean help

clean:
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning auxiliary build files..."
ifdef CLEAN_FILES
	rm -f $(CLEAN_FILES)
endif
ifdef CLEAN_DIRS
	rm -fr $(CLEAN_DIRS)
endif

mrproper: clean
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning viewable build files..."
ifdef MRPROPER_FILES
	rm -f $(MRPROPER_FILES)
endif
ifdef MRPROPER_DIRS
	rm -fr $(MRPROPER_DIRS)
endif

distclean: mrproper
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning final files..."
ifdef DISTCLEAN_FILES
	rm -f $(DISTCLEAN_FILES)
endif
ifdef MKLATEX_DISTCLEAN_DIRS
	rm -fr $(MKLATEX_DISTCLEAN_DIRS)
endif

help:
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
	@echo -e "Variables:"
	@echo -e "\tNPROCS\t\t\t\tNumber of jobs to parallize the build. (Default: $(NPROCS))"
