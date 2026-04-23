# Changelog

## [Unreleased]

### Changed

- `latex.mk`: Allows to have TeX source files used as `subfiles` inside subdirectories of the source directory (`src/tex`)
- `inkscape.mk`: Allows to have Inkscape source files inside subdirectories of the source directory (`src/gfx/inkscape`)

## [0.0.3] - 2026-04-10

### Added

- Rudimentary but functional installation script under `utils/install.sh`
- New Docker image based on TeXLive Docker image instead of Ubuntu
- Add support for Natbib
  - With a new `MKLATEX_BIB_PKG` variable in `.env` allowing to change the bibliography backend between BibLaTeX and NatBib

### Changed

- Improve logging messages format
- Improve X11 support inside Docker images (viewers)
- Improve font supports inside Docker images

### Fixed

- Add missing ScapeX installation inside Docker images
- Use proper Gitlab variables for cloning Git submodules inside `.gitlab-ci.yml`

## [0.0.2] - 2025-12-05

### Added

- `bin`: Add `--open` option to quickly open the compiled result
- `mklatex.sty`: Add support for `svg` LaTeX package through the `\svgpath` setting

### Fixed

- `inkscape`: Do not remove TOML files when a build fail
