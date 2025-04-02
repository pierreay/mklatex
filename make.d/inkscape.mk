# Variables
# ==============================================================================

# Directory where source files are stored.
INKSCAPE_SRC_DIR := $(GFX_PATH)/inkscape

# Source files.
INKSCAPE_SRC_FILES := $(shell find $(INKSCAPE_SRC_DIR) -type f -name '*.svg')

# Output filetype [pdf | eps].
INKSCAPE_BUILD_FT := pdf

# Directory where exported files will be stored.
export INKSCAPE_BUILD_DIR := $(INKSCAPE_SRC_DIR:$(SRC_DIR)/%=$(BUILD_DIR)/%)

# Exported files (do not contains layered exportation).
INKSCAPE_BUILD_FILES := $(patsubst $(INKSCAPE_SRC_DIR)/%.svg,$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT),$(INKSCAPE_SRC_FILES))

# Custom exporter script.
# TODO: As of now, must be cloned by top-level project as a separate submodule.
# - May be included as a submodule of mklatex directly.
# - Or may be indicated inside usage guide.
# INKSCAPE_SCRIPT_PATH := inkscape2latex/bin/inkscape2latex

# Custom layers definitions.
# TODO: Must be set by top-level project. Indicate it inside an usage guide.
# INKSCAPE_LAYERS_PATH := inkscape2latex/examples/inkscape-layers.json

# Never delete the built files (even if the subsequent target fail).
.PRECIOUS: $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT) $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT)_tex

# Interface with other modules:
# - Add exported figures as dependency for LaTeX document.
# - Add exported figures as viewable build files to clean.
LATEX_ADDITIONAL_DEPS += $(INKSCAPE_BUILD_FILES)
MRPROPER_DIRS         += $(INKSCAPE_BUILD_DIR)

# Targets
# ==============================================================================

# Default target for this module. 
.PHONY: inkscape
inkscape: inkscape-build

# Export all figures.
.PHONY: inkscape-build
inkscape-build: $(INKSCAPE_BUILD_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) Inkscape build done!"

# Clean exported figures.
.PHONY: inkscape-clean
inkscape-clean:
	rm -fr $(INKSCAPE_BUILD_DIR)

# Print module variables.
inkscape-debug:
	@echo INKSCAPE_SRC_DIR=$(INKSCAPE_SRC_DIR)
	@echo INKSCAPE_SRC_FILES=$(INKSCAPE_SRC_FILES)
	@echo INKSCAPE_BUILD_DIR=$(INKSCAPE_BUILD_DIR)
	@echo INKSCAPE_BUILD_FILES=$(INKSCAPE_BUILD_FILES)

# Create build directory.
$(INKSCAPE_BUILD_DIR):
	@mkdir -p $(INKSCAPE_BUILD_DIR)

# .svg -> {.pdf, .pdf_tex}
$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT): $(INKSCAPE_SRC_DIR)/%.svg | $(INKSCAPE_BUILD_DIR)
	@[ -z "$(INKSCAPE_SCRIPT_PATH)" ] && \
		{ echo -e "$(_COL_ERR)[x] mklatex:$(_COL_RES) INKSCAPE_SCRIPT_PATH variable not defined!"; exit 1; } || true
ifndef INKSCAPE_LAYERS_PATH
		$(INKSCAPE_SCRIPT_PATH) $< $@
else
		$(INKSCAPE_SCRIPT_PATH) -l $(INKSCAPE_LAYERS_PATH) $< $@
endif
