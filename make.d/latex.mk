# Environment
# ==============================================================================

# Allows sub-makes to find `biber`.
export PATH = $(shell echo /usr/bin/vendor_perl:$$PATH)

# Add project root full path to be used by LaTeX to search for files.
# It works when:
# - Specifying a `.tex` file to a compiler.
# - Including subfiles `\include`, `\input`, `\subfile`.
# - Packages assuming files in current directory (e.g., `makeindex`).
export TEXINPUTS = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))//:

# Variables
# ==============================================================================

# Paths 
# ------------------------------------------------------------------------------

# Name of our main source file.
LATEX_SRC_NAME = main

# Directory where source files are stored.
LATEX_SRC_DIR := $(SRC_DIR)/tex

# Source files.
LATEX_SRC_FILES := $(shell find $(LATEX_SRC_DIR) -type f -name '*.tex')

# Directory where built files will be stored.
LATEX_BUILD_DIR := $(LATEX_SRC_DIR:$(SRC_DIR)/%=$(BUILD_DIR)/%)

# Filename of our final output file.
LATEX_OUT_FILE = main.pdf

# Compilation 
# ------------------------------------------------------------------------------

# Compiler binary.
# - pdflatex : UTF-8 bad support, problems with line breaking.
# - xelatex  : UTF-8 support, problems with line breaking.
# - lualatex : UTF-8 support, Lua scripting for OS integration.
LATEX_CC_BIN = lualatex

# Compiler arguments for draft or final mode.
# -shell-escape
#		Enable system commands.
# -interaction=batchmode
#		Do not log to stdout.
# --halt-on-error
#		Stop at first error (to not bury the error in the log file).
# --draftmode
#		Do not produce an output PDF (faster).
# --synctex=1
#		Enable SyncTeX support (needs editor and viewer support too).
LATEX_CC_ARGS_DRAFT = -shell-escape -interaction=batchmode --halt-on-error --draftmode
LATEX_CC_ARGS_FINAL = -shell-escape -interaction=batchmode --halt-on-error --synctex=1

# Bibliography processor.
LATEX_BIB_CC_BIN = biber

# Glossary and index processor.
LATEX_GLOSSARY_CC_BIN = makeglossaries

# Regular expressions
# ------------------------------------------------------------------------------

# Command used to grep log files.
LATEX_GREP_CMD := grep -E -C 3 -H --color=always

# Regular expression matching a need to re-run the bibliography processor.
LATEX_RERUNBIB_REGEX := 'No file.*\.bbl|Citation.*undefined'

# Regular expression matching a need to re-run the glossary processor.
LATEX_RERUNGLOSSARY_REGEX := 'Glossary.*is missing'

# Regular expression matching a fatal error.
LATEX_CHECKERR_REGEX := 'Emergency stop|Runaway argument|File.*not found|! Package.*Error'

# Post-processing 
# ------------------------------------------------------------------------------

# Compression level using GhostScript (gs).
LATEX_GS_PDFSETTINGS = prepress

# Should we compress using GhostScript?
LATEX_GS_ENABLE = true

# Interfacing with other modules
# ------------------------------------------------------------------------------

# - Add auxiliary and viewable build files or directories to clean.
ifeq ($(shell test -d $(LATEX_BUILD_DIR) && echo true),true)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.acn\|.*.acr\|.*.alg\|.*.aux'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.bbl\|.*.bcf\|.*.blg'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.glg\|.*.glo\|.*.gls'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.idx\|.*.ilg\|.*.ind\|.*.ist'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.lof\|.*.lot'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.out'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.run.xml'; fi)
	CLEAN_FILES    += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.toc'; fi)
	MRPROPER_FILES += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.log'; fi)
	MRPROPER_FILES += $(shell if [[ -d $(LATEX_BUILD_DIR) ]]; then find $(LATEX_BUILD_DIR) -type f -regex '.*.synctex.gz'; fi)
	MRPROPER_DIRS  += $(LATEX_BUILD_DIR)
endif

# Targets
# ==============================================================================

# Never delete the built PDFs (even if the subsequent target fail).
.PRECIOUS: $(LATEX_BUILD_DIR)/%.pdf

# Empty target used in some prerequisite to force a target to re-run.
# Useful force pattern rules that cannot be set directly into `.PHONY`.
.PHONY: .FORCE_RERUN
.FORCE_RERUN:

# Default target for this module.
.PHONY: latex
latex: $(OUT_DIR)/$(LATEX_OUT_FILE)
	$(MAKE) latex-showerr 

# Clean build files.
.PHONY: latex-clean
latex-clean:
	rm -fr $(LATEX_BUILD_DIR)
	rm -f $(BUILD_DIR)/*.pdf
	rm -f $(OUT_DIR)/$(LATEX_OUT_FILE)

# Show detected errors from log files.
latex-showerr:
ifeq ($(shell test -d $(LATEX_BUILD_DIR) && test ! -z $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') && echo true),true)
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Search for errors..."
	@$(LATEX_GREP_CMD) $(LATEX_RERUNBIB_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_RERUNGLOSSARY_REGEX) $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_CHECKERR_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
endif

# Create build directory. 
$(LATEX_BUILD_DIR):
	@mkdir -p $(LATEX_BUILD_DIR)

# %.tex -> %.pdf
$(LATEX_BUILD_DIR)/%.pdf: $(LATEX_SRC_FILES) $(LATEX_ADDITIONAL_DEPS) | $(LATEX_BUILD_DIR) $(LATEX_ADDITIONAL_REQS)
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Build $@..."
ifndef LATEX_ONESHOT
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Run 1/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_DRAFT) $(patsubst $(LATEX_BUILD_DIR)/%.pdf, %, $@)
	@grep -E -q $(LATEX_RERUNGLOSSARY_REGEX) $(patsubst %.pdf, %.log, $@) && $(MAKE) $(patsubst %.pdf, %.glg, $@) || true
	@grep -E -q $(LATEX_RERUNBIB_REGEX)      $(patsubst %.pdf, %.log, $@) && $(MAKE) $(patsubst %.pdf, %.bbl, $@) || true
endif
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Run 3/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_FINAL) $(patsubst $(LATEX_BUILD_DIR)/%.pdf, %, $@)
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Build $@ end!"

# Glossary build.
# Running condition is detected using LaTeX logs by caller, so it has to be forced run.
$(LATEX_BUILD_DIR)/%.glg: .FORCE_RERUN
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Glossary and index build..."
	$(LATEX_GLOSSARY_CC_BIN) -d $$(dirname $@) $$(basename $(patsubst $(LATEX_BUILD_DIR)/%.glg, %, $@))
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Run 2/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_DRAFT) $(patsubst $(LATEX_BUILD_DIR)/%.glg, %, $@)

# Bibliography build.
# Running condition is detected using LaTeX logs by caller, so it has to be forced run.
$(LATEX_BUILD_DIR)/%.bbl: .FORCE_RERUN
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Bibliography build..."
	$(LATEX_BIB_CC_BIN) --output-directory=$$(dirname $@) $(patsubst %.bbl, %.bcf, $@)

# Post-processing (mainly compression).
$(BUILD_DIR)/%.pdf: $(LATEX_BUILD_DIR)/%.pdf | $(BUILD_DIR)
ifeq ($(LATEX_GS_ENABLE), false)
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Copy $< to $@..."
	@cp $< $@
else
	@echo -e "$(_COL_OK)[+] Makefile:$(_COL_RES) Compress $< to $@..."
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/$(LATEX_GS_PDFSETTINGS) -dDetectDuplicateImages -sOutputFile=$@ $<
endif

# Special target for our final file.
$(OUT_DIR)/$(LATEX_OUT_FILE): $(BUILD_DIR)/$(LATEX_SRC_NAME).pdf | $(OUT_DIR)
	cp $< $@
