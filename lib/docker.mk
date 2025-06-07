# Makefile inspired from:
# Template: 4a045d95-227b-46ca-80b9-f279ce7ff162

include $(MKLATEX_PATH)/lib/common.mk

# Variables
# ==============================================================================

DOCKER_ETC_PATH := $(MKLATEX_PATH)/$(_MKLATEX_ETC_DIR)/docker

# Docker directory that will be use to find the Dockerfile.
DOCKER_NAME ?= ubuntu
# Name that will be use to name the Docker image.
DOCKER_IMAGE_NAME := mklatex-docker/$(DOCKER_NAME)
# Name that will be use to name the Docker the container (`/` are forbidden).
DOCKER_CONTAINER_NAME := mklatex-docker.$(DOCKER_NAME)

# Working directory for the Docker host.
# Use current working directory, since it is meant to be the full path of the
# top-level project root.
DOCKER_HWD = ${PWD}
# Working directory for the Docker guest.
DOCKER_GWD = /latex

# Targets
# ==============================================================================

$(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit:
	docker buildx build $(MKLATEX_DOCKER_BUILD_OPTS) -t $(DOCKER_IMAGE_NAME) $$(dirname $@)
	touch $@
