# Installation

## As a `git` submodule for a self-contained project

```bash
mkdir -p modules && git submodule add https://github.com/pierreay/mklatex modules/mklatex
```

# Usage

## As an included Makefile

```make
MKLATEX_PATH := modules/mklatex
include $(MKLATEX_PATH)/Makefile
```

## As a standalone Makefile

```make
mklatex:
	$(MAKE) -f modules/mklatex/Makefile all
```
