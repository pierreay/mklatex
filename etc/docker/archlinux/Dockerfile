FROM archlinux:latest

# TODO: If needed, update PATH to find `scapex`. Refer to `ubuntu/Dockerfile`.

# For easy check about being inside Docker or not.
ENV MKLATEX_DOCKER_GUEST=true
# Defines default PDF viewer for `mklatex`
ENV PDFVIEWER="zathura"

# Base tools:
RUN pacman -Syyu --noconfirm base-devel python-pip git xclock-xorg zathura

# TeX Live distribution:
RUN pacman -Syyu --noconfirm texlive texlive-basic texlive-plaingeneric texlive-latex texlive-latexrecommended texlive-latexextra texlive-binextra texlive-bibtexextra texlive-fontsrecommended texlive-fontsextra texlive-publishers texlive-mathscience texlive-langfrench texlive-langgreek biber bibtool

# TeX Live dependencies:
RUN pacman -Syyu --noconfirm python-pygments

# Fonts:
RUN pacman -Syyu --noconfirm ttf-linux-libertine

# ScapeX:
RUN pacman -Syyu --noconfirm python-pipx && pipx install scapex

# Drawing tools:
RUN pacman -Syyu --noconfirm inkscape drawio-desktop

# Dependency for our DrawIO exporter script:
RUN pacman -Syyu --noconfirm xorg-server-xvfb

# Dependencies for our Makefile processing:
RUN pacman -Syyu --noconfirm ghostscript imagemagick
