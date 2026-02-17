include $(MKLATEX_PATH)/lib/common.mk

# Environment
# ==============================================================================

# Allows sub-makes to find `biber`.
export PATH = $(shell echo /usr/bin/vendor_perl:$$PATH)

# Add current working directory to be used by LaTeX to search for files.
# It is meant to be the full path of the top-level project root.
# It works when:
# - Specifying a `.tex` file to a compiler.
# - Including subfiles `\include`, `\input`, `\subfile`.
# - Packages assuming files in current directory (e.g., `makeindex`).
export TEXINPUTS = ${PWD}//:

# Increase maximum column number from 80 to 1000 for `pdflatex` or `lualatex` logging file
# This will makes the parsing of errors easier
export max_print_line = 1000

# Variables
# ==============================================================================

# Paths 
# ------------------------------------------------------------------------------

# Name of our main source file.
LATEX_SRC_NAME = main

# Directory where source files are stored.
export LATEX_SRC_DIR := $(MKLATEX_SRC_DIR)/tex

# Directory where configuration files are stored.
export LATEX_ETC_DIR := $(MKLATEX_ETC_DIR)/tex

# Source files (including configuration files for automatic rebuild).
LATEX_SRC_FILES := $(shell [ -d $(LATEX_SRC_DIR) ] && find $(LATEX_SRC_DIR) -type f -name '*.tex' || true)
LATEX_SRC_FILES += $(shell [ -d $(LATEX_ETC_DIR) ] && find $(LATEX_ETC_DIR) -type f -name '*.sty' || true)

# Directory where built files will be stored.
LATEX_BUILD_DIR := $(LATEX_SRC_DIR:$(MKLATEX_SRC_DIR)/%=$(MKLATEX_BUILD_DIR)/%)

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
# -file-line-error
#		Prints error messages in the form `file:line:error`.
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
LATEX_CC_ARGS_DRAFT = -file-line-error -shell-escape -interaction=batchmode --halt-on-error --draftmode
LATEX_CC_ARGS_FINAL = -file-line-error -shell-escape -interaction=batchmode --halt-on-error --synctex=1

# Bibliography processor.
# [biber | bibtex]
ifeq (${MKLATEX_BIB_PKG},natbib)
LATEX_BIB_CC_BIN = bibtex
else
LATEX_BIB_CC_BIN = biber
endif

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
# Beware that long file names contained in an error message can make this one
# end up on a newline.
LATEX_CHECKERR_REGEX := 'Emergency stop|Runaway argument|[!:] LaTeX Error: |[!:] Package.*Error|Missing.*inserted|[!:] \(Inkscape\).*|[!:] Undefined control.*|LaTeX Warning: '

# Post-processing 
# ------------------------------------------------------------------------------

# Compression level using GhostScript (gs).
LATEX_GS_PDFSETTINGS = prepress

# Should we compress using GhostScript?
LATEX_GS_ENABLE = false

# Passed to LaTeX
# ------------------------------------------------------------------------------

# --- Generic

ifdef MKLATEX_LATEX_VERSION_NAME
LATEX_CC_FIRSTLINE += \def\mklatexLatexVersionName{$(MKLATEX_LATEX_VERSION_NAME)}
endif

# --- Beamer

# Handling handout setting.
ifdef MKLATEX_LATEX_BEAMER_HANDOUT
LATEX_CC_FIRSTLINE += \def\mklatexLatexBeamerHandout{}
endif

# Handling notes setting.
ifdef MKLATEX_LATEX_BEAMER_NOTE2ND
export MKLATEX_LATEX_BEAMER_NOTE_OPT := show notes on second screen
else
export MKLATEX_LATEX_BEAMER_NOTE_OPT := hide notes
endif

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

# Never delete the built PDFs (even if the subsequent target fail).
.PRECIOUS: $(LATEX_BUILD_DIR)/%.pdf

# Empty target used in some prerequisite to force a target to re-run.
# Useful force pattern rules that cannot be set directly into `.PHONY`.
.PHONY: .FORCE_RERUN
.FORCE_RERUN:

# Targets
# ==============================================================================

# Create build directory. 
$(LATEX_BUILD_DIR):
	@mkdir -p $(LATEX_BUILD_DIR)

# %.tex -> %.pdf
$(LATEX_BUILD_DIR)/%.pdf: $(LATEX_SRC_FILES) $(LATEX_ADDITIONAL_DEPS) | $(LATEX_BUILD_DIR) $(LATEX_ADDITIONAL_REQS)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Build $@..."
ifndef LATEX_ONESHOT
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Run 1/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_DRAFT) "$(LATEX_CC_FIRSTLINE)\input{$(patsubst $(LATEX_BUILD_DIR)/%.pdf,$(LATEX_SRC_DIR)/%,$@)}"
	@grep -E -q $(LATEX_RERUNGLOSSARY_REGEX) $(patsubst %.pdf,%.log,$@) && $(MAKE) $(patsubst %.pdf,%.glg,$@) || true
	@grep -E -q $(LATEX_RERUNBIB_REGEX)      $(patsubst %.pdf,%.log,$@) && $(MAKE) $(patsubst %.pdf,%.bbl,$@) || true
endif
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Run 3/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_FINAL) "$(LATEX_CC_FIRSTLINE)\input{$(patsubst $(LATEX_BUILD_DIR)/%.pdf,$(LATEX_SRC_DIR)/%,$@)}"
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Build $@ end!"

# Glossary build.
# Running condition is detected using LaTeX logs by caller, so it has to be forced run.
$(LATEX_BUILD_DIR)/%.glg: .FORCE_RERUN
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Glossary and index build..."
	$(LATEX_GLOSSARY_CC_BIN) -d $$(dirname $@) $$(basename $(patsubst $(LATEX_BUILD_DIR)/%.glg,%,$@))
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Run 2/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_DRAFT) "$(LATEX_CC_FIRSTLINE)\input{$(patsubst $(LATEX_BUILD_DIR)/%.glg,$(LATEX_SRC_DIR)/%,$@)}"

# Bibliography build.
# Running condition is detected using LaTeX logs by caller, so it has to be forced run.
# NOTE: BibTeX needs one more run than Biber, therefore, run it there
$(LATEX_BUILD_DIR)/%.bbl: .FORCE_RERUN
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Bibliography build..."
ifeq ($(LATEX_BIB_CC_BIN),biber)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Use Biber backend"
	$(LATEX_BIB_CC_BIN) --output-directory=$$(dirname $@) $(patsubst %.bbl,%.bcf,$@)
else
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Use BibTeX backend"
	cd $$(dirname $@) && $(LATEX_BIB_CC_BIN) $$(basename $(patsubst %.bbl,%.aux,$@))
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Run 2/3:"
	cd $$(dirname $@) && $(LATEX_CC_BIN) $(LATEX_CC_ARGS_DRAFT) "$(LATEX_CC_FIRSTLINE)\input{$(patsubst $(LATEX_BUILD_DIR)/%.bbl,$(LATEX_SRC_DIR)/%,$@)}"
endif

# Post-processing (mainly compression).
$(MKLATEX_BUILD_DIR)/%.pdf: $(LATEX_BUILD_DIR)/%.pdf | $(MKLATEX_BUILD_DIR)
ifeq ($(LATEX_GS_ENABLE),false)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Copy $< to $@..."
	@cp $< $@
else
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Compress $< to $@..."
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/$(LATEX_GS_PDFSETTINGS) -dDetectDuplicateImages -sOutputFile=$@ $<
endif

# Special target for our final file.
$(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE): $(MKLATEX_BUILD_DIR)/$(LATEX_SRC_NAME).pdf | $(MKLATEX_OUT_DIR)
	cp $< $@
