include $(MKLATEX_PATH)/common.mk

# Variables
# ==============================================================================

DOCKER_ETC_PATH := $(MKLATEX_PATH)/$(_MKLATEX_ETC_DIR)/docker

# Docker tag and directory that will be use to find the Dockerfile.
DOCKER_NAME ?= ubuntu

# Working directory for the Docker host.
# Use current working directory, since it is meant to be the full path of the
# top-level project root.
DOCKER_HWD = ${PWD}
# Working directory for the Docker guest.
DOCKER_GWD = /latex

# Targets
# ==============================================================================

$(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit:
	docker build -t $(DOCKER_NAME) $(DOCKER_NAME) 
	touch $@
