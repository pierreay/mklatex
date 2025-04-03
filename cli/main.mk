ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

# Common default
# ==============================================================================

include $(MKLATEX_PATH)/lib/common.mk

# Targets
# ==============================================================================

# Default target definition according to GNU guidelines.
.DEFAULT_GOAL = help

# Modules
# ==============================================================================

include $(MKLATEX_PATH)/lib/drawio.mk
include $(MKLATEX_PATH)/lib/inkscape.mk
include $(MKLATEX_PATH)/lib/biblio.mk
include $(MKLATEX_PATH)/lib/latex.mk

# Goals
# ==============================================================================

.PHONY: all clean mrproper distclean printenv printexport help

all: $(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE)
	$(MAKE) -f $(MKLATEX_PATH)/cli/latex.mk showerrs

clean:
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning auxiliary build files..."
ifneq ($(strip $(CLEAN_FILES)),)
	rm -f $(CLEAN_FILES)
endif
ifneq ($(strip $(CLEAN_DIRS)),)
	rm -fr $(CLEAN_DIRS)
endif

mrproper: clean
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning viewable build files..."
ifneq ($(strip $(MRPROPER_FILES)),)
	rm -f $(MRPROPER_FILES)
endif
ifneq ($(strip $(MRPROPER_DIRS)),)
	rm -fr $(MRPROPER_DIRS)
endif

distclean: mrproper
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning final files..."
ifneq ($(strip $(DISTCLEAN_FILES)),)
	rm -f $(DISTCLEAN_FILES)
endif
ifneq ($(strip $(MKLATEX_DISTCLEAN_DIRS)),)
	rm -fr $(MKLATEX_DISTCLEAN_DIRS)
endif

printenv:
	@echo MKLATEX_PATH=$(MKLATEX_PATH)
	@echo MAKEFLAGS=$(MAKEFLAGS)
	@echo NPROCS=$(NPROCS)

printexport:
	@bash -c "printenv | grep MKLATEX_ || true"

help:
	@echo -e "Usage: mklatex[-module] [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\t\tBuild main document."
	@echo -e "\tclean\t\t\t\tDelete auxiliary build files."
	@echo -e "\tmrproper\t\t\tDelete viewable build files."
	@echo -e "\tdistclean\t\t\tDelete final files."
	@echo -e "\tprintenv\t\tPrint common mklatex variables."
	@echo -e "\tprintexported\t\tPrint exported common mklatex variables."
	@echo -e ""
	@echo -e "Modules:"
	@echo -e "\tbiblio\t\t\t\tImport external bibliography."
	@echo -e "\tinkscape\t\t\tExport Inkscape figures."
	@echo -e "\tdrawio\t\t\t\tExport DrawIO figures."
	@echo -e "\tlatex\t\t\t\tBuild LaTeX document."
	@echo -e ""
	@echo -e "Submake:"
	@echo -e "\tcd docker && make help\t\tOperate inside a Docker container."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tNPROCS\t\t\t\tNumber of jobs to parallelize the build. (Default: $(NPROCS))"
