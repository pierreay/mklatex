include $(MKLATEX_PATH)/common.mk

# Variables
# ==============================================================================

# Path to an external bibliography project.
# TODO : To fix
# BIB_REMOTE_FP = 

BIB_REMOTE_CMD = $(MAKE) all

# Test to find external bibliography [1 = found ; 0 = not found].
BIB_REMOTE_FOUND := $(if $(shell test -d $(BIB_REMOTE_FP) && echo true),1,0)

# Directory storing the local bibliographic files.
# NOTE: Exported for `os.getenv` in `\directlua`.
export BIB_DIR = $(MKLATEX_SRC_DIR)/bib

# Files located in the external bibliography that we want to import.
BIB_FILES = $(BIB_DIR)/references.bib $(BIB_DIR)/references-ownpubs.bib

# Interface with other modules:
# - Add bibliographic files as dependency for LaTeX document.
# - Add update of external bibliography as order-only requirement for LaTeX document.
LATEX_ADDITIONAL_DEPS += $(BIB_FILES)
# TODO: bilio-make does not exists anymore (upgrade target)
LATEX_ADDITIONAL_REQS += biblio-make

# Targets
# ==============================================================================

# Remote .bib -> Local .bib
# - cp -p: preserve timestamps.
# - sed: remove field(s) that we don't want in our project.
$(BIB_DIR)/%.bib: $(BIB_REMOTE_FP)/%.bib
ifeq ($(BIB_REMOTE_FOUND), 1)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Import bibliographic file from external project..."
	cp -p $< $@
	sed -i '/note.*=.*{.*}/d' $@
	sed -i '/abstract.*=.*{.*}/d' $@
else
	$(warning [!] External bibliography not found!)
endif
