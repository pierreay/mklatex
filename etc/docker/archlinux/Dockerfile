FROM archlinux:latest

# For easy check about being inside Docker or not.
ENV MKLATEX_DOCKER_GUEST=true

# Base tools:
RUN pacman -Syyu --noconfirm base-devel python-pip git

# TeX Live distribution:
RUN pacman -Syyu --noconfirm texlive texlive-langfrench biber bibtool

# Drawing tools:
RUN pacman -Syyu --noconfirm inkscape drawio-desktop

# Dependency for our Inkscape exporter script:
RUN pacman -Syyu --noconfirm jq bc

# Dependency for our DrawIO exporter script:
RUN pacman -Syyu --noconfirm xorg-server-xvfb

# Dependencies for our Makefile processing:
RUN pacman -Syyu --noconfirm ghostscript imagemagick
