FROM ubuntu:24.04

# For easy check about being inside Docker or not.
ENV MKLATEX_DOCKER_GUEST=true
# Automatically answer yes for APT questions.
ENV DEBIAN_FRONTEND=noninteractive
# Update `PATH` with local binaries installed by the `root` user
ENV PATH="$PATH:/root/.local/bin"

# Base tools:
RUN apt-get update && apt-get install -yq git vim python3-pip sudo wget unzip apt-file

# TeX Live distribution:
RUN apt-get update && apt-get install -yq texlive texlive-lang-french texlive-latex-extra texlive-fonts-extra texlive-luatex texlive-science biber bibtool

# ScapeX:
RUN apt-get update && apt-get install -yq pipx && pipx install scapex

# Dependencies for our Makefile processing:
RUN apt-get update && apt-get install -yq ghostscript imagemagick

# Inkscape
# ==============================================================================
# - Inkscape may be installed from official Ubuntu repos, but its version is
#   outdated for 2 years and may give segmentation fault on some recent SVGs.
# - As a result, use the official Inkscape PPA for the latest stable version.
RUN apt-get update && apt install -yq software-properties-common
RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:inkscape.dev/stable
RUN apt-get update && apt-get install -yq inkscape

# DrawIO
# ==============================================================================
# See: https://github.com/jgraph/drawio-desktop/issues/146

# Install its X dependency.
RUN apt-get update && apt-get install -yq curl xvfb nano libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libappindicator3-1 libsecret-1-0 libgbm1

# Download and extract the official AppImage.
RUN curl -LJO https://github.com/jgraph/drawio-desktop/releases/download/v24.4.8/drawio-x86_64-24.4.8.AppImage
RUN chmod +x drawio-x86_64-24.4.8.AppImage && ./drawio-x86_64-24.4.8.AppImage --appimage-extract
# Deploy it inside our root filesystem.
RUN cp -r ./squashfs-root /drawio
RUN chmod -R og+rX  /drawio
RUN ln -sfT /drawio/drawio /usr/bin/drawio 
