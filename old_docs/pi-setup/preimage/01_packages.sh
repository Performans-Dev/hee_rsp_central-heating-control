#!/bin/bash

echo "Installing system packages..."
# Update package lists
apt update

# Install required packages
apt install -y \
  libsqlite3-0 \
  libsqlite3-dev \
  i2c-tools \
  wget \
  curl \
  zip \
  unzip \
  git \
  build-essential \
  python3-pip \
  jq \
  pcmanfm \
  arc-theme \
  papirus-icon-theme \
  unclutter \
  locales \
  dialog

# Configure locale
echo "Configuring locale..."
sed -i 's/# en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

echo "Package installation complete."
