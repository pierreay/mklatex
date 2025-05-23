include $(MKLATEX_PATH)/lib/common.mk

# Variables
# ==============================================================================

DOCKER_ETC_PATH := $(MKLATEX_PATH)/$(_MKLATEX_ETC_DIR)/docker

# Docker directory that will be use to find the Dockerfile.
DOCKER_NAME ?= ubuntu
# Docker tag that will be use to name the Docker image and the container.
DOCKER_TAG := mklatex-docker/$(DOCKER_NAME)

# Working directory for the Docker host.
# Use current working directory, since it is meant to be the full path of the
# top-level project root.
DOCKER_HWD = ${PWD}
# Working directory for the Docker guest.
DOCKER_GWD = /latex

# Targets
# ==============================================================================

$(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit:
	docker build $(MKLATEX_DOCKER_BUILD_OPTS) -t $(DOCKER_TAG) $$(dirname $@)
	touch $@
