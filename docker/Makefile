# Docker tag and directory that will be use to find the Dockerfile.
DOCKER_NAME ?= ubuntu

# Working directory for the Docker host.
DOCKER_HWD = ${PWD}/..
# Working directory for the Docker guest.
DOCKER_GWD = /latex

.PHONY: init
init: $(DOCKER_NAME)/.dockerinit

.PHONY: test
test: $(DOCKER_NAME)/.dockerinit
	docker run --rm -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash -c "cd $(DOCKER_GWD) && ls -alh"

.PHONY: build
build: $(DOCKER_NAME)/.dockerinit
	docker run --rm -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash -c "cd $(DOCKER_GWD) && make"

.PHONY: shell
shell: $(DOCKER_NAME)/.dockerinit
	docker run -it -v $(DOCKER_HWD):$(DOCKER_GWD) $(DOCKER_NAME) /bin/bash

# Clean our Docker images and containers.
.PHONY: clean
clean:
	docker container ls --all | grep $(DOCKER_NAME) | awk '{print $$1}' | xargs -n1 -r docker container rm
	docker image rm $(DOCKER_NAME):latest
	rm $(DOCKER_NAME)/.dockerinit

$(DOCKER_NAME)/.dockerinit:
	docker build -t $(DOCKER_NAME) $(DOCKER_NAME) 
	touch $@

# Helper.
.PHONY: help
help:
	@echo -e "Usage: make [target] [variable]"
	@echo -e ""
	@echo -e "Targets:"
	@echo -e "\tinit:\tInitialize the Docker container."
	@echo -e "\ttest:\tTest such that Docker container is running and can access to our project."
	@echo -e "\tshell:\tDrop a shell into the Docker container."
	@echo -e "\tbuild:\tBuild the project by running 'make' inside the Docker container."
	@echo -e "\tclean:\tClean this Docker image and container."
	@echo -e ""
	@echo -e "Variables:"
	@echo -e "\tDOCKER_NAME:\tContainer to use. [ubuntu | archlinux] (default = $(DOCKER_NAME))"
