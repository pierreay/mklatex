# Documentation
# ==============================================================================

# The following variables may be populated by previously loaded modules:
# - CLEAN_FILES
# - CLEAN_DIRS
# - MRPROPER_FILES
# - MRPROPER_DIRS
# - DISTCLEAN_FILES
# - DISTCLEAN_DIRS

# Targets
# ==============================================================================

clean:
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning auxiliary build files..."
ifdef CLEAN_FILES
	rm -f $(CLEAN_FILES)
endif
ifdef CLEAN_DIRS
	rm -fr $(CLEAN_DIRS)
endif

mrproper: clean
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning viewable build files..."
ifdef MRPROPER_FILES
	rm -f $(MRPROPER_FILES)
endif
ifdef MRPROPER_DIRS
	rm -fr $(MRPROPER_DIRS)
endif

distclean: mrproper
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Cleaning final files..."
ifdef DISTCLEAN_FILES
	rm -f $(DISTCLEAN_FILES)
endif
ifdef DISTCLEAN_DIRS
	rm -fr $(DISTCLEAN_DIRS)
endif
