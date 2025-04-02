include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/biblio.mk

.DEFAULT_GOAL := help
.PHONY: all ugrade printenv help

# Import all bibliographic files.
all: upgrade .WAIT $(BIB_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Bibliography importation done!"

# Run make inside external bibliography.
upgrade:
ifeq ($(BIB_REMOTE_FOUND), 1)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Ensure external bibliography is up-to-date..."
	cd $(BIB_REMOTE_FP) && $(BIB_REMOTE_CMD)
else
	$(warning [!] External bibliography not found!)
endif

# Print module variables.
printenv:
	@echo BIB_REMOTE_FP=$(BIB_REMOTE_FP)
	@echo BIB_REMOTE_FOUND=$(BIB_REMOTE_FOUND)
	@echo BIB_DIR=$(BIB_DIR)
	@echo BIB_FILES=$(BIB_FILES)

help:
	@echo -e "Usage: mklatex-biblio [target] [variable]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tImport up-to-date bibliography."
	@echo -e "\tupgrade\t\t\tUpdate external bibliography."
	@echo -e "\tprintenv\t\tPrint mklatex/biblio variables."
