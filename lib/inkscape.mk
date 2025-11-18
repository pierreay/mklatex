include $(MKLATEX_PATH)/lib/common.mk

# Variables
# ==============================================================================

# Directory where source files are stored.
INKSCAPE_SRC_DIR := $(MKLATEX_GFX_PATH)/inkscape

# Source files.
INKSCAPE_SRC_FILES := $(shell [ -d $(INKSCAPE_SRC_DIR) ] && find $(INKSCAPE_SRC_DIR) -type f -name '*.svg' || true)

# Output filetype (PDF).
INKSCAPE_BUILD_FT := pdf

# Directory where exported files will be stored.
# NOTE: Exported for `os.getenv` in `\directlua`.
export INKSCAPE_BUILD_DIR := $(INKSCAPE_SRC_DIR:$(MKLATEX_SRC_DIR)/%=$(MKLATEX_BUILD_DIR)/%)

# Output files (do not contains fragments) (PDFs).
INKSCAPE_BUILD_FILES := $(patsubst $(INKSCAPE_SRC_DIR)/%.svg,$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT),$(INKSCAPE_SRC_FILES))

# Never delete the built files (even if the subsequent target fail).
# NOTE: [2025-11-18] I had to add "%.toml" without any leading directory. Why the others have leading directories?
.PRECIOUS: $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT) $(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT)_tex %.toml

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

# Convert a SVG into a PDF or a set of PDFs (potentially with `.pdf_tex` sidecars).
$(INKSCAPE_BUILD_DIR)/%.$(INKSCAPE_BUILD_FT): $(INKSCAPE_SRC_DIR)/%.svg $(INKSCAPE_SRC_DIR)/%.toml | $(INKSCAPE_BUILD_DIR)
	scapex -o $(INKSCAPE_BUILD_DIR) $<
	touch $@

# Generate a default configuration file.
%.toml:
	scapex --generate $(patsubst %.toml,%.svg,$@)
