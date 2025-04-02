# Directory where source files are stored.
DRAWIO_SRC_DIR := $(GFX_PATH)/drawio

# Source files.
DRAWIO_SRC_FILES := $(shell find $(DRAWIO_SRC_DIR) -type f -name '*.drawio')

# Directory where exported files will be stored.
export DRAWIO_BUILD_DIR := $(DRAWIO_SRC_DIR:$(SRC_DIR)/%=$(BUILD_DIR)/%)

# Exported files.
DRAWIO_BUILD_FILES := $(patsubst $(DRAWIO_SRC_DIR)/%.drawio,$(DRAWIO_BUILD_DIR)/%.pdf,$(DRAWIO_SRC_FILES))

# Custom exporter script.
DRAWIO_SCRIPT_PATH = $(MKLATEX_PATH)/$(BIN_DIR)/drawio2pdf

# Never delete the built PDFs (even if the subsequent target fail).
.PRECIOUS: $(DRAWIO_BUILD_DIR)/%.pdf

# Interface with other modules:
# - Add exported figures as dependency for LaTeX document.
# - Add exported figures as viewable build files to clean.
LATEX_ADDITIONAL_DEPS += $(DRAWIO_BUILD_FILES)
MRPROPER_DIRS         += $(DRAWIO_BUILD_DIR)

# Default target for this module. 
.PHONY: drawio
drawio: drawio-build

# Export all figures.
.PHONY: drawio-build
drawio-build: $(DRAWIO_BUILD_FILES)
	@echo -e "$(_COL_OK)[+] mklatex:$(_COL_RES) DrawIO build done!"

# Clean exported figures.
.PHONY: drawio-clean
drawio-clean:
	rm -f $(DRAWIO_BUILD_FILES)

# Print module variables.
drawio-debug:
	@echo DRAWIO_SRC_DIR=$(DRAWIO_SRC_DIR)
	@echo DRAWIO_SRC_FILES=$(DRAWIO_SRC_FILES)
	@echo DRAWIO_BUILD_DIR=$(DRAWIO_BUILD_DIR)
	@echo DRAWIO_BUILD_FILES=$(DRAWIO_BUILD_FILES)

# Create build directory.
$(DRAWIO_BUILD_DIR):
	@mkdir -p $(DRAWIO_BUILD_DIR)

# .drawio -> .pdf
$(DRAWIO_BUILD_DIR)/%.pdf: $(DRAWIO_SRC_DIR)/%.drawio | $(DRAWIO_BUILD_DIR)
	$(DRAWIO_SCRIPT_PATH) $< $@
