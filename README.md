# About

Modular self-contained LaTeX build system.

Optionally supports:

| Type         | Software                                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------------------- |
| Editor       | [Vim](https://www.vim.org/) & [NeoVim](https://neovim.io/)'s [compiler](https://vimhelp.org/quickfix.txt.html#%3Acompiler) |
| Editor       | [Vim](https://www.vim.org/) & [NeoVim](https://neovim.io/)'s [VimTeX](https://github.com/lervag/vimtex)                    |
| Drawing      | [DrawIO](https://www.drawio.com/)                                                                                          |
| Drawing      | [Inkscape](https://inkscape.org/)                                                                                          |
| Log parsing  | [PPLaTeX](https://github.com/stefanhepp/pplatex)                                                                           |
| Slides       | [Beamer](https://ctan.org/pkg/beamer)                                                                                      |
| Compiler     | [pdfTeX](https://www.tug.org/applications/pdftex/) & [LuaTeX](https://www.luatex.org/)                                     |
| Bibliography | [biblatex](https://ctan.org/pkg/biblatex) + [biber](https://biblatex-biber.sourceforge.net/)                               |
| Glossary     | [glossaries](https://ctan.org/pkg/glossaries) & [glossaries-extra](https://ctan.org/pkg/glossaries-extra)                  |
| Index        | [makeindex](https://ctan.org/pkg/makeindex)                                                                                |

# Installation

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
