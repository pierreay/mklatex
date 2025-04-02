include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/inkscape.mk

.DEFAULT_GOAL := help

# Export all figures.
.PHONY: all
all: $(INKSCAPE_BUILD_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Inkscape build done!"

# Clean exported figures.
.PHONY: clean
clean:
	rm -fr $(INKSCAPE_BUILD_DIR)

# Print module variables.
.PHONY: clean
debug:
	@echo INKSCAPE_SRC_DIR=$(INKSCAPE_SRC_DIR)
	@echo INKSCAPE_SRC_FILES=$(INKSCAPE_SRC_FILES)
	@echo INKSCAPE_BUILD_DIR=$(INKSCAPE_BUILD_DIR)
	@echo INKSCAPE_BUILD_FILES=$(INKSCAPE_BUILD_FILES)

.PHONY: help
help:
	@echo -e "Usage: mklatex-inkscape [target] [variable]"
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\tall\t\t\tBuild all Inkscape figures."
	@echo -e "\tclean\t\t\tRemove all Inkscape figures."
	@echo -e "\tdebug\t\t\tPrint Inkscape variables."
	@echo -e ""
	@echo -e "Rules:"
	@echo -e "\t$(INKSCAPE_BUILD_DIR)/*.pdf\tBuild the PDF of the corresponding Inkscape figure."
