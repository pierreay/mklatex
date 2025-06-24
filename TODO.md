# Design

- [ ] Refactor CLI by using dedicated scripts in `bin/` (to be added in
  `$PATH`) and providing autocompletion.

# Build System

- [ ] Create a continuous integration on GitHub using one of the Docker image
  for building document. See:
  - [How to annoy your co-authors_ a Gitlab CI pipeline for LaTeX - Martin’s blog](https://blog.martisak.se/2020/05/11/gitlab-ci-latex-pipeline/)
  - [Continuous Integration of LaTeX projects with GitLab Pages · Vipin Ajayakumar](https://www.vipinajayakumar.com/continuous-integration-of-latex-projects-with-gitlab-pages.html).

# Tooling Support

- [ ] Create a Python script that will reformat LaTeX logs into good paragraph
  without line breaking due to column width.
- [ ] Add support of `tikzplotlib`? See:
  - [Create publication ready figures with Matplotlib and TikZ - Martin’s blog](https://blog.martisak.se/2019/09/29/publication_ready_figures/).
- [ ] Add support of `svg`? LaTeX package provides an `includeinkscape` option.
  Better integration? See:
  - [svg](https://mirrors.ircam.fr/pub/CTAN/graphics/svg/doc/svg.pdf)
- [ ] Add support of `svg-inkscape`? LaTeX package handle automatic Inkscape
  export and dependency management. The only missing option is layered
  export. See:
  - [svg-inkscape](https://www.ctan.org/pkg/svg-inkscape) 
