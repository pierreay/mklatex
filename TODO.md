# Organization

- [ ] Merge inkscape2latex into this repository and rename it to inkscape2pdf
  - [ ] Use sidecar file instead of shared file for layer definition.
  - [ ] Use YAML or TOML instead of JSON? 

# Design

- [ ] Refactor CLI by using dedicated scripts in `bin/` (to be added in
  `$PATH`) and providing autocompletion.
- [ ] Add an install script [inspired from this one](https://github.com/tomups/worktrees-scripts/blob/main/install.sh).

# Tooling Support

- [ ] Add support of `tikzplotlib`? See:
  - [Create publication ready figures with Matplotlib and TikZ - Martin’s blog](https://blog.martisak.se/2019/09/29/publication_ready_figures/).
- [ ] Add support of `svg`? LaTeX package provides an `includeinkscape` option.
  Better integration? See:
  - [svg](https://mirrors.ircam.fr/pub/CTAN/graphics/svg/doc/svg.pdf)
- [ ] Add support of `svg-inkscape`? LaTeX package handle automatic Inkscape
  export and dependency management. The only missing option is layered
  export. See:
  - [svg-inkscape](https://www.ctan.org/pkg/svg-inkscape) 
