FROM texlive/texlive:latest

# For easy check about being inside Docker or not.
ENV MKLATEX_DOCKER_GUEST=true

# Automatically answer yes for APT questions.
ENV DEBIAN_FRONTEND=noninteractive

# Defines default PDF viewer for `mklatex`
ENV PDFVIEWER="zathura"

# Root execution
# ===============================================================================

# Basic sysadmin and development tools
RUN apt-get update && apt-get install -yq git vim python3-pip pipx sudo wget unzip apt-file x11-apps

# Code processors
RUN apt-get update && apt-get install -yq python3-pygments

# Fonts
RUN apt-get update && apt-get install -yq fonts-linuxlibertine

# Image processing
RUN apt-get update && apt-get install -yq ghostscript imagemagick inkscape

# Document viewers
RUN apt-get update && apt-get install -yq zathura

# DrawIO
# ------------------------------------------------------------------------------
# See: https://github.com/jgraph/drawio-desktop/issues/146

# Install its X dependencies
RUN apt-get update && apt-get install -yq curl xvfb nano libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libappindicator3-1 libsecret-1-0 libgbm1

# Download and extract the official AppImage
RUN curl -LJO https://github.com/jgraph/drawio-desktop/releases/download/v24.4.8/drawio-x86_64-24.4.8.AppImage
RUN chmod +x drawio-x86_64-24.4.8.AppImage && ./drawio-x86_64-24.4.8.AppImage --appimage-extract
# Deploy it inside our root filesystem
RUN cp -r ./squashfs-root /drawio
RUN chmod -R og+rX  /drawio
RUN ln -sfT /drawio/drawio /usr/bin/drawio

# User execution
# ===============================================================================

# Log into `\texlive` user provided by upstream image
USER texlive

# Update `PATH` with local binaries installed by the `texlive` user
ENV PATH="$PATH:/home/texlive/.local/bin"

# Move into project directory
WORKDIR /latex

# Install ScapeX in user home
RUN pipx install scapex
