ifndef MKLATEX_PATH
$(error Error: MKLATEX_PATH is not set!)
endif

include $(MKLATEX_PATH)/common.mk
include $(MKLATEX_PATH)/mkrules.d/docker.mk

.DEFAULT_GOAL := help
.PHONY: init test build shell clean printenv printexport help

.PHONY: init
init: $(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit

.PHONY: test
test: $(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit
	docker run --rm -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash -c "cd $(DOCKER_GWD) && ls -alh"

.PHONY: build
build: $(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit
	docker run --rm -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash -c "cd $(DOCKER_GWD) && make all"

.PHONY: shell
shell: $(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit
	docker run -it -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash

# Clean our Docker images and containers.
.PHONY: clean
clean:
	docker container ls --all | grep $(DOCKER_NAME) | awk '{print $$1}' | xargs -n1 -r docker container rm
	docker image rm $(DOCKER_NAME):latest
	rm $(DOCKER_ETC_DIR)/$(DOCKER_NAME)/.dockerinit

printenv:
	@echo DOCKER_ETC_PATH=$(DOCKER_ETC_PATH)
	@echo DOCKER_NAME=$(DOCKER_NAME)
	@echo DOCKER_HWD=$(DOCKER_HWD)
	@echo DOCKER_GWD=$(DOCKER_GWD)

printexport:
	@bash -c "printenv | grep DOCKER_"

# Helper.
.PHONY: help
help:
	@echo -e "Usage: mklatex-docker [target | goal] [variable...]"
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\tinit:\tInitialize the Docker container."
	@echo -e "\ttest:\tTest such that Docker container is running and can access to our project."
	@echo -e "\tshell:\tDrop a shell into the Docker container."
	@echo -e "\tbuild:\tBuild the project by running 'make' inside the Docker container."
	@echo -e "\tclean:\tClean this Docker image and container."
	@echo -e "\tprintenv\t\tPrint mklatex-docker variables."
	@echo -e "\tprintexport\t\tPrint exported mklatex-docker variables."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tDOCKER_NAME:\tContainer to use. [ubuntu | archlinux] (default = $(DOCKER_NAME))"
