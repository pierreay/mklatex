include $(MKLATEX_PATH)/common.mk

# Variables
# ==============================================================================

DOCKER_ETC_DIR := $(_MKLATEX_ETC_DIR)/docker

# Docker tag and directory that will be use to find the Dockerfile.
DOCKER_NAME ?= ubuntu

# Working directory for the Docker host.
DOCKER_HWD = ${PWD}/..
# Working directory for the Docker guest.
DOCKER_GWD = /latex

# Targets
# ==============================================================================

$(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit:
	docker build -t $(DOCKER_NAME) $(DOCKER_NAME) 
	touch $@
