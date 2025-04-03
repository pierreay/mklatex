MKLATEX_PATH ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/..
include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/biblio.mk

.DEFAULT_GOAL := help
.PHONY: all ugrade printenv help

all: $(BIB_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Bibliography is up-to-date!"

printenv:
	@echo BIB_REMOTE_PATH=$(BIB_REMOTE_PATH)
	@echo BIB_REMOTE_CMD=$(BIB_REMOTE_CMD)
	@echo BIB_DIR=$(BIB_DIR)
	@echo BIB_FILES=$(BIB_FILES)

help:
	@echo -e "Usage: mklatex-biblio [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\tUpdate bibliography."
	@echo -e "\tprintenv\t\tPrint mklatex/biblio variables."
