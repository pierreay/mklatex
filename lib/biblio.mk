include $(MKLATEX_PATH)/lib/common.mk

# Variables
# ==============================================================================

# Path to a remote bibliography project.
# BIB_REMOTE_PATH ?= /path/to/bibliograĥy

# Command used to export the remote bibliography to local bibliography.
BIB_REMOTE_CMD ?= $(MAKE) -C $(BIB_REMOTE_PATH)

# Local bibliography directory.
# NOTE: Exported for `os.getenv` in `\directlua`.
export BIB_SRC_DIR = $(MKLATEX_SRC_DIR)/bib

# Local bibliography files.
BIB_SRC_FILES ?= $(shell [ -d $(BIB_SRC_DIR) ] && find $(BIB_SRC_DIR) -type f -name '*.bib' || true)

# Interface with other modules:
# - Add local bibliography files as dependency for LaTeX document.
LATEX_ADDITIONAL_DEPS += $(BIB_SRC_FILES)

# Empty target used in some prerequisite to force a target to re-run.
# Useful force pattern rules that cannot be set directly into `.PHONY`.
.PHONY: .FORCE_RERUN
.FORCE_RERUN:

# Targets
# ==============================================================================

# bibliography -> .bib
# - Use `sed` to remove field(s) that we don't want in our project.
# - Running condition is detected using the build system of the external
#   bibliography, so it has to be forced run.
$(BIB_SRC_DIR)/%.bib: .FORCE_RERUN
ifdef BIB_REMOTE_PATH
	@[ ! -d "$(BIB_REMOTE_PATH)" ] && \
		{ echo -e "$(_COL_ERR)[x] mklatex:$(_COL_RES) Not an existing directory: $(BIB_REMOTE_PATH)"; exit 1; } || true
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Ensure up-to-date...: $@"
	$(BIB_REMOTE_CMD) $$(realpath -m $@)
endif
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Format bibliography...: $@"
	sed -i '/note.*=.*{.*}/d' $@
	sed -i '/abstract.*=.*{.*}/d' $@
