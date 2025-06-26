ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/lib/common.mk
include $(MKLATEX_PATH)/lib/latex.mk

.DEFAULT_GOAL := help
.PHONY: all clean printenv printexport showerrs help

# Build main document.
all: $(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE)
	$(MAKE) -f $(MKLATEX_PATH)/cli/latex.mk showerrs

# Clean build files.
clean:
	rm -fr $(LATEX_BUILD_DIR)
	rm -f $(MKLATEX_BUILD_DIR)/*.pdf
	rm -f $(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE)

printenv:
	@echo TEXINPUTS=$(TEXINPUTS)
	@echo LATEX_SRC_NAME=$(LATEX_SRC_NAME)
	@echo LATEX_SRC_DIR=$(LATEX_SRC_DIR)
	@echo LATEX_ETC_DIR=$(LATEX_ETC_DIR)
	@echo LATEX_SRC_FILES=$(LATEX_SRC_FILES)
	@echo LATEX_BUILD_DIR=$(LATEX_BUILD_DIR)
	@echo LATEX_OUT_FILE=$(LATEX_OUT_FILE)
	@echo LATEX_GS_PDFSETTINGS=$(LATEX_GS_PDFSETTINGS)
	@echo LATEX_GS_ENABLE=$(LATEX_GS_ENABLE)
	@echo LATEX_ADDITIONAL_REQS=$(LATEX_ADDITIONAL_REQS)
	@echo LATEX_ADDITIONAL_DEPS=$(LATEX_ADDITIONAL_DEPS)
	@echo LATEX_CC_FIRSTLINE=$(LATEX_CC_FIRSTLINE)
	@echo MKLATEX_LATEX_VERSION_NAME=$(MKLATEX_LATEX_VERSION_NAME)
	@echo MKLATEX_LATEX_BEAMER_HANDOUT=$(MKLATEX_LATEX_BEAMER_HANDOUT)
	@echo MKLATEX_LATEX_BEAMER_NOTE2ND=$(MKLATEX_LATEX_BEAMER_NOTE2ND)
	@echo MKLATEX_LATEX_BEAMER_NOTE_OPT=$(MKLATEX_LATEX_BEAMER_NOTE_OPT)

printexport:
	@bash -c "printenv | grep LATEX_ || true"

# Show detected errors from log files.
showerrs:
ifeq ($(shell test -d $(LATEX_BUILD_DIR) && test ! -z "$$(find $(LATEX_BUILD_DIR) -type f -name '*.log')" && echo true),true)
# ifeq (, $(shell which pplatex))
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Grep for errors..."
	@$(LATEX_GREP_CMD) $(LATEX_RERUNBIB_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_RERUNGLOSSARY_REGEX) $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_CHECKERR_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
# else
	# FIX: pplatex requires that -file-line-error is NOT passed to LaTeX compiler.
	# @echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Run pplatex..."
	# pplatex -i $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
# endif
endif

help:
	@echo -e "Usage: mklatex-latex [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\t\tBuild LaTeX document (without other modules dependencies)."
	@echo -e "\tclean\t\t\t\tRemove build files."
	@echo -e "\tprintenv\t\t\tPrint mklatex-latex variables."
	@echo -e "\tprintexport\t\t\tPrint exported mklatex-latex variables."
	@echo -e "\tshowerrs\t\t\tGrep errors from log files."
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\t$(LATEX_BUILD_DIR)/*.pdf\t\t\tBuild the PDF of the corresponding LaTeX source."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tLATEX_ONESHOT\t\t\tPerform only one single compilation pass without glossary or bibliography if defined (may lead to a broken document)."
	@echo -e "\tLATEX_GS_PDFSETTINGS\t\tCompression level for document post-processing [screen | ebook | printer | prepress]. (Default: $(LATEX_GS_PDFSETTINGS))"
	@echo -e "\tLATEX_GS_ENABLE\t\t\tEnable or disable compression post-processing using GhostScript [true | false]. (Default: $(LATEX_GS_ENABLE))"
	@echo -e "\tLATEX_CC_FIRSTLINE\t\tString used as the first TeX line passed to the compiler before having the \input command with the compiled file."
	@echo -e "\tMKLATEX_LATEX_VERSION_NAME\tName of a specific document version. If defined, set the mklatexLatexVersionName TeX variable."
	@echo -e "\tMKLATEX_LATEX_BEAMER_HANDOUT\tIf defined, set the mklatexLatexBeamerHandout TeX variable to compile a Beamer presentation in handout mode (see mklatex.sty)."
	@echo -e "\tMKLATEX_LATEX_BEAMER_NOTE_OPT\tString that set the mklatexLatexBeamerNoteOpt TeX variable to configure note mode [ hide notes | show notes on second screen ]. (Default: $(MKLATEX_LATEX_BEAMER_NOTE_OPT))"
	@echo -e "\tMKLATEX_LATEX_BEAMER_NOTE2ND\tIf defined, set the MKLATEX_LATEX_BEAMER_NOTE_OPT variable to show notes on second screen."
