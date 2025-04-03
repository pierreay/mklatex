ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/lib/inkscape.mk

.DEFAULT_GOAL := help
.PHONY: all clean printenv printexport help

# Export all figures.
all: $(INKSCAPE_BUILD_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Inkscape build done!"

# Clean exported figures.
clean:
	rm -fr $(INKSCAPE_BUILD_DIR)

# Print module variables.
printenv:
	@echo INKSCAPE_SRC_DIR=$(INKSCAPE_SRC_DIR)
	@echo INKSCAPE_SRC_FILES=$(INKSCAPE_SRC_FILES)
	@echo INKSCAPE_BUILD_DIR=$(INKSCAPE_BUILD_DIR)
	@echo INKSCAPE_BUILD_FILES=$(INKSCAPE_BUILD_FILES)

printexport:
	@bash -c "printenv | grep INKSCAPE_"

help:
	@echo -e "Usage: mklatex-inkscape [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tBuild all Inkscape figures."
	@echo -e "\tclean\t\t\tRemove all Inkscape figures."
	@echo -e "\tprintenv\t\tPrint mklatex-inkscape variables."
	@echo -e "\tprintexport\t\tPrint exported mklatex-inkscape variables."
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\t$(INKSCAPE_BUILD_DIR)/*.pdf\tBuild the PDF of the corresponding Inkscape figure."
