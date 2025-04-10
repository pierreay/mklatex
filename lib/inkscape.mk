include $(MKLATEX_PATH)/lib/common.mk

# Variables
# ==============================================================================

# Directory where source files are stored.
INKSCAPE_SRC_DIR := $(MKLATEX_GFX_PATH)/inkscape

# Source files.
INKSCAPE_SRC_FILES := $(shell [ -d $(INKSCAPE_SRC_DIR) ] && find $(INKSCAPE_SRC_DIR) -type f -name '*.svg' || true)

# Output filetype [pdf | eps].
INKSCAPE_BUILD_FT := pdf

# Suffix for files rendered using Inkscape fonts.
INKSCAPE_FONTS_SUFFIX := _inkscape-fonts

# Directory where exported files will be stored.
# NOTE: Exported for `os.getenv` in `\directlua`.
export INKSCAPE_BUILD_DIR := $(INKSCAPE_SRC_DIR:$(MKLATEX_SRC_DIR)/%=$(MKLATEX_BUILD_DIR)/%)

# Exported files (do not contains layered exportation).
INKSCAPE_BUILD_FILES := $(patsubst $(INKSCAPE_SRC_DIR)/%.svg,$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT),$(INKSCAPE_SRC_FILES))

# Custom exporter script path.
INKSCAPE_SCRIPT_PATH := $(MKLATEX_PATH)/$(_MKLATEX_EXT_DIR)/inkscape2latex/bin/inkscape2latex

# Custom layers definitions.
# TODO: Must be set by top-level project. Indicate it inside an usage guide.
# INKSCAPE_LAYERS_PATH := inkscape2latex/examples/inkscape-layers.json

# Custom exporter script arguments.
ifdef INKSCAPE_LAYERS_PATH
INKSCAPE_SCRIPT_ARGS += -l $(INKSCAPE_LAYERS_PATH)
endif

# Never delete the built files (even if the subsequent target fail).
.PRECIOUS: $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT) $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT)_tex

# Interface with other modules:
# - Add exported figures as dependency for LaTeX document.
# - Add exported figures as viewable build files to clean.
LATEX_ADDITIONAL_DEPS += $(INKSCAPE_BUILD_FILES)
MRPROPER_DIRS         += $(INKSCAPE_BUILD_DIR)

# Targets
# ==============================================================================

# Create build directory.
$(INKSCAPE_BUILD_DIR):
	@mkdir -p $(INKSCAPE_BUILD_DIR)

# .svg -> {INKSCAPE_FONTS_SUFFIX.pdf, .pdf, .pdf_tex}
# TODO: Implement a proper feature for Inkscape font rendering. Maybe
# specifying into the inkcape2latex JSON options for each files?
$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT): $(INKSCAPE_SRC_DIR)/%.svg | $(INKSCAPE_BUILD_DIR)
	@[ -z "$(INKSCAPE_SCRIPT_PATH)" ] && \
		{ echo -e "$(_COL_ERR)[x] mklatex:$(_COL_RES) INKSCAPE_SCRIPT_PATH variable not defined!"; exit 1; } || true
	$(INKSCAPE_SCRIPT_PATH) $(INKSCAPE_SCRIPT_ARGS) $< $@
	$(INKSCAPE_SCRIPT_PATH) $(INKSCAPE_SCRIPT_ARGS) --inkscape-fonts $< $(patsubst %.$(INKSCAPE_BUILD_FT),%$(INKSCAPE_FONTS_SUFFIX).$(INKSCAPE_BUILD_FT),$@)
