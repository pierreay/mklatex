ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/lib/common.mk
include $(MKLATEX_PATH)/lib/drawio.mk

.DEFAULT_GOAL := help
.PHONY: all clean printenv printexport help

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

printexport:
	@bash -c "printenv | grep DRAWIO_ || true"

help:
	@echo -e "Usage: mklatex-drawio [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tBuild all DrawIO figures."
	@echo -e "\tclean\t\t\tRemove all DrawIO figures."
	@echo -e "\tprintenv\t\tPrint mklatex-drawio variables."
	@echo -e "\tprintexport\t\tPrint exported mklatex-drawio variables."
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\t$(DRAWIO_BUILD_DIR)/*.pdf\tBuild the PDF of the corresponding DrawIO figure."
