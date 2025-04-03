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

# Tips

## Excluding Makefile section from Docker build

```make
ifndef MKLATEX_DOCKER_GUEST
[MAKE CODE]
endif
```

## Makefile variables inside LaTeX

Working for variables that are exported inside `Makefile`. For example:

```make
export MY_MODULE_PATH = /opt/mymodule
```

Using LuaLaTeX compiler:

```latex
\newcommand{\myModulePath}{\directlua{tex.write(os.getenv("MY_MODULE_PATH"))}}
```
