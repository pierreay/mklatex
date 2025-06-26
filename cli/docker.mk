# Makefile inspired from:
# Template: 4a045d95-227b-46ca-80b9-f279ce7ff162

ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/lib/common.mk
include $(MKLATEX_PATH)/lib/docker.mk

.DEFAULT_GOAL := help
.PHONY: all init test shell clean printenv printexport help

# FIX: Disable parallelization since an "old" GNU Make version on Ubuntu 24.04
# does not handle it well. A better way would be to have a script that run the
# appropriate command between Arch and Ubuntu.
all: $(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit
	docker run $(MKLATEX_DOCKER_RUN_OPTS) -v $(DOCKER_HWD):$(DOCKER_GWD) -it $(DOCKER_IMAGE_NAME) /bin/bash -c "cd $(DOCKER_GWD) && source .env && make -j1 all"

init: $(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit

test: $(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit
	docker run $(MKLATEX_DOCKER_RUN_OPTS) -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_IMAGE_NAME) /bin/bash -c "cd $(DOCKER_GWD) && ls -alh"

shell: $(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit
	docker start -ai $(DOCKER_CONTAINER_NAME) 2>/dev/null || \
		docker run $(MKLATEX_DOCKER_RUN_OPTS) -it \
			--name $(DOCKER_CONTAINER_NAME) \
			--env=DISPLAY --net=host \
			-v $(DOCKER_HWD):$(DOCKER_GWD) \
			$(DOCKER_IMAGE_NAME) /bin/bash

# Clean our Docker images and containers.
clean:
	docker container ls --all | grep $(DOCKER_CONTAINER_NAME) | awk '{print $$1}' | xargs -n1 -r docker container rm

distclean: clean
	docker image rm $(DOCKER_IMAGE_NAME):latest
	rm $(DOCKER_ETC_PATH)/$(DOCKER_NAME)/.dockerinit

printenv:
	@echo DOCKER_ETC_PATH=$(DOCKER_ETC_PATH)
	@echo DOCKER_NAME=$(DOCKER_NAME)
	@echo DOCKER_IMAGE_NAME=$(DOCKER_IMAGE_NAME)
	@echo DOCKER_CONTAINER_NAME=$(DOCKER_CONTAINER_NAME)
	@echo DOCKER_HWD=$(DOCKER_HWD)
	@echo DOCKER_GWD=$(DOCKER_GWD)
	@echo MKLATEX_DOCKER_BUILD_OPTS=$(MKLATEX_DOCKER_BUILD_OPTS)
	@echo MKLATEX_DOCKER_RUN_OPTS=$(MKLATEX_DOCKER_RUN_OPTS)

printexport:
	@bash -c "printenv | grep DOCKER_ || true"

help:
	@echo -e "Usage: mklatex-docker [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\tall:\t\t\tBuild the project by running 'make all' inside a new Docker container."
	@echo -e "\tinit:\t\t\tInitialize a permanent Docker container."
	@echo -e "\ttest:\t\t\tTest such that the permanent Docker container is running and can access to our project."
	@echo -e "\tshell:\t\t\tDrop a shell into the permanent Docker container."
	@echo -e "\tclean:\t\t\tClean our Docker containers."
	@echo -e "\tdistclean\tClean our Docker containers and images."
	@echo -e "\tprintenv\t\tPrint mklatex-docker variables."
	@echo -e "\tprintexport\t\tPrint exported mklatex-docker variables."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tDOCKER_NAME:\t\t\tContainer to use. [ubuntu | archlinux] (default = $(DOCKER_NAME))"
	@echo -e "\tMKLATEX_DOCKER_BUILD_OPTS:\tAdditional options for Docker build."
	@echo -e "\tMKLATEX_DOCKER_RUN_OPTS:\tAdditional options for Docker run."
