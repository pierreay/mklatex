include $(MKLATEX_PATH)/common.mk

# Variables
# ==============================================================================

# Directory where source files are stored.
DRAWIO_SRC_DIR := $(MKLATEX_GFX_PATH)/drawio

# Source files.
DRAWIO_SRC_FILES := $(shell [ -d $(DRAWIO_SRC_DIR) ] && find $(DRAWIO_SRC_DIR) -type f -name '*.drawio' || true)

# Directory where exported files will be stored.
export DRAWIO_BUILD_DIR := $(DRAWIO_SRC_DIR:$(MKLATEX_SRC_DIR)/%=$(MKLATEX_BUILD_DIR)/%)

# Exported files.
DRAWIO_BUILD_FILES := $(patsubst $(DRAWIO_SRC_DIR)/%.drawio,$(DRAWIO_BUILD_DIR)/%.pdf,$(DRAWIO_SRC_FILES))

# Custom exporter script.
DRAWIO_SCRIPT_PATH = $(MKLATEX_PATH)/$(_MKLATEX_BIN_DIR)/drawio2pdf

# Never delete the built PDFs (even if the subsequent target fail).
.PRECIOUS: $(DRAWIO_BUILD_DIR)/%.pdf

# Interface with other modules:
# - Add exported figures as dependency for LaTeX document.
# - Add exported figures as viewable build files to clean.
LATEX_ADDITIONAL_DEPS += $(DRAWIO_BUILD_FILES)
MRPROPER_DIRS         += $(DRAWIO_BUILD_DIR)

# Targets
# ==============================================================================

# Create build directory.
$(DRAWIO_BUILD_DIR):
	@mkdir -p $(DRAWIO_BUILD_DIR)

# .drawio -> .pdf
$(DRAWIO_BUILD_DIR)/%.pdf: $(DRAWIO_SRC_DIR)/%.drawio | $(DRAWIO_BUILD_DIR)
	$(DRAWIO_SCRIPT_PATH) $< $@
