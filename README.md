# About

Modular self-contained LaTeX build system.

## Features

- Automatized:
  - Reproducible and containerized build
  - Continuous integration pipeline
- Keep organized:
  - Out-of-tree build
  - Multiple source file handling
  - Multiple document version handling (see [1])
- Fast to use:
  - Parallel
  - Autocompletion
- Post-processing for optimal files:
  - Compression
- Modular:
  - System or project-wide installation
  - Hackable to suite any project
- Suited for:
  - Articles
  - Thesis
  - Slides (animated through LaTeX & Inkscape)

[1] Examples are 1) lecturer/student versions for classes 2) animated/handout/notes version for slides 3) 20/30 minutes versions for talks.

## Support

Provides support for the following external software:

| Type                        | Software                                                                                                                   |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Editor                      | [Vim](https://www.vim.org/) & [NeoVim](https://neovim.io/)'s [compiler](https://vimhelp.org/quickfix.txt.html#%3Acompiler) |
| Editor                      | [Vim](https://www.vim.org/) & [NeoVim](https://neovim.io/)'s [VimTeX](https://github.com/lervag/vimtex)                    |
| Container                   | [Docker](https://www.docker.com/)                                                                                          |
| Drawing                     | [DrawIO](https://www.drawio.com/)                                                                                          |
| Drawing                     | [Inkscape](https://inkscape.org/) + [ScapeX](https://github.com/pierreay/scapex)                                           |
| Bibliography                | [Papis](https://github.com/papis/papis)                                                                                    |
| Post-processing             | [GhostScript](https://www.ghostscript.com/)                                                                                |
| Continuous Integration (CI) | [GitLab](https://gitlab.com/)                                                                                              |

Provides support for the following LaTeX packages or addons:

| Type            | Software                                                                                                  |
| --------------- | --------------------------------------------------------------------------------------------------------- |
| Compiler        | [pdfTeX](https://www.tug.org/applications/pdftex/) & [LuaTeX](https://www.luatex.org/)                    |
| Slides          | [Beamer](https://ctan.org/pkg/beamer)                                                                     |
| Modularity      | [Subfiles](https://ctan.org/pkg/subfiles)                                                                 |
| Bibliography    | [biblatex](https://ctan.org/pkg/biblatex) + [biber](https://biblatex-biber.sourceforge.net/)              |
| Bibliography    | [natbib](https://ctan.org/pkg/natbib)     + [bibtex](https://ctan.org/pkg/bibtex)                         |
| Glossary        | [glossaries](https://ctan.org/pkg/glossaries) & [glossaries-extra](https://ctan.org/pkg/glossaries-extra) |
| Index           | [makeindex](https://ctan.org/pkg/makeindex)                                                               |
| Log parsing     | [PPLaTeX](https://github.com/stefanhepp/pplatex)                                                          |
| Synchronization | [SyncTeX](https://github.com/jlaurens/synctex)                                                            |

# Installation

## From GitHub

1. Change directory into your LaTeX repository

2. Run the following:

```bash
curl https://github.com/pierreay/mklatex/utils/install.sh | bash
```

3. This script will automatically:
    1. Add the `mklatex` repository as a submodule (without committing, you will be free to move it)
    2. Setup the minimal working environment from `./etc/example`
    3. Install the Python dependencies using `pipx`

## As a `git` submodule for a self-contained project

```bash
mkdir -p ext && git submodule add https://github.com/pierreay/mklatex ext/mklatex
git submodule update --init --recursive
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
