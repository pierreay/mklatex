include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/drawio.mk

.DEFAULT_GOAL := help
.PHONY: all clean printenv help

# Export all figures.
all: $(DRAWIO_BUILD_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) DrawIO build done!"

# Clean exported figures.
clean:
	rm -f $(DRAWIO_BUILD_FILES)

# Print module variables.
printenv:
	@echo DRAWIO_SRC_DIR=$(DRAWIO_SRC_DIR)
	@echo DRAWIO_SRC_FILES=$(DRAWIO_SRC_FILES)
	@echo DRAWIO_BUILD_DIR=$(DRAWIO_BUILD_DIR)
	@echo DRAWIO_BUILD_FILES=$(DRAWIO_BUILD_FILES)

help:
	@echo -e "Usage: mklatex-drawio [target] [variable]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tBuild all DrawIO figures."
	@echo -e "\tclean\t\t\tRemove all DrawIO figures."
	@echo -e "\tprintenv\t\tPrint DrawIO variables."
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\t$(DRAWIO_BUILD_DIR)/*.pdf\tBuild the PDF of the corresponding DrawIO figure."
