ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/lib/biblio.mk

.DEFAULT_GOAL := help
.PHONY: all ugrade printenv printexport help

all: $(BIB_SRC_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Bibliography is up-to-date!"

printenv:
	@echo BIB_REMOTE_PATH=$(BIB_REMOTE_PATH)
	@echo BIB_REMOTE_CMD=$(BIB_REMOTE_CMD)
	@echo BIB_SRC_DIR=$(BIB_SRC_DIR)
	@echo BIB_SRC_FILES=$(BIB_SRC_FILES)

printexport:
	@bash -c "printenv | grep BIB_ || true"

help:
	@echo -e "Usage: mklatex-biblio [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tUpdate bibliography."
	@echo -e "\tprintenv\t\tPrint mklatex-biblio variables."
	@echo -e "\tprintexport\t\tPrint exported mklatex-biblio variables."
