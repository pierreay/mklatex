include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/latex.mk

.DEFAULT_GOAL := help
.PHONY: all clean debug showerrs help

# Build main document.
all: $(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE)
	$(MAKE) -f $(MKLATEX_PATH)/mkgoals.d/latex.mk showerrs

# Clean build files.
clean:
	rm -fr $(LATEX_BUILD_DIR)
	rm -f $(MKLATEX_BUILD_DIR)/*.pdf
	rm -f $(MKLATEX_OUT_DIR)/$(LATEX_OUT_FILE)

debug:
	@echo LATEX_OUT_FILE=$(LATEX_OUT_FILE)

# Show detected errors from log files.
showerrs:
ifeq ($(shell test -d $(LATEX_BUILD_DIR) && test ! -z $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') && echo true),true)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Grep for errors..."
	@$(LATEX_GREP_CMD) $(LATEX_RERUNBIB_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_RERUNGLOSSARY_REGEX) $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
	@$(LATEX_GREP_CMD) $(LATEX_CHECKERR_REGEX)      $$(find $(LATEX_BUILD_DIR) -type f -name '*.log') || true
endif

help:
	@echo -e "Usage: mklatex-latex [target] [variable]"
	@echo -e ""
	@echo -e "Goals:"
	@echo -e "\tall\t\t\t\tBuild LaTeX document (without other modules dependencies)."
	@echo -e "\tclean\t\t\t\tRemove build files."
	@echo -e "\tdebug\t\t\t\tPrint LaTeX variables."
	@echo -e "\tshowerrs\t\t\tGrep errors from log files."
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\t$(LATEX_BUILD_DIR)/*.pdf\t\t\tBuild the PDF of the corresponding LaTeX source."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tLATEX_ONESHOT\t\t\tPerform only one single compilation pass without glossary or bibliography if defined (may lead to a broken document)."
	@echo -e "\tLATEX_GS_PDFSETTINGS\t\tCompression level for document post-processing [screen | ebook | printer | prepress]. (Default: $(LATEX_GS_PDFSETTINGS))"
