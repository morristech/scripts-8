#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

# Prints a formatted header; used for outlining
function echoText() {
    RED="\033[01;31m"
    RST="\033[0m"

    echo -e "${RED}"
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "==  ${1}  =="
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "${RST}"
}

# Creates a new line
function newLine() {
    echo -e ""
}

# Function for installing debian packages
function debian_pkgs() {
    echoText "Setting up build environment for Debian"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install openjdk-8-jdk git-core gnupg flex bison gperf lib32ncurses5-dev libx11-dev \
    build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 x11proto-core-dev \
    lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip make bc schedtool repo imagemagick
}

# Function for installing arch packages
function arch_pkgs() {
    echoText "Setting up build environment for Arch"
    sudo pacman -Syyu
    sudo pacman -S base-devel git wget multilib-devel cmake svn clang

# Install ncurses5-compat-libs, lib32-ncurses5-compat-libs, aosp-devel, xml2, and lineageos-devel
    for p in ncurses5-compat-libs lib32-ncurses5-compat-libs aosp-devel xml2 lineageos-devel; do
    git clone https://aur.archlinux.org/$p
    cd $p
    makepkg -si --skippgpcheck
    cd -
    rm -rf $p
    done
    
    echo "Don't forget to run these commands before building, or make sure the python in your PATH is 
    python2 and not python3"
    echo "
    virtualenv2 venv
    source venv/bin/activate"
}

# Function for installing fedora packages
function fedora_pkgs() {
    echoText "Setting up build environment for fedora"
    sudo dnf -y update
    sudo dnf install autoconf213 bison bzip2 ccache curl flex gawk gcc-c++ git glibc-devel \
    glibc-static libstdc++-static libX11-devel make mesa-libGL-devel ncurses-devel patch zlib-devel \
    ncurses-devel.i686 readline-devel.i686 zlib-devel.i686 libX11-devel.i686 mesa-libGL-devel.i686 \
    glibc-devel.i686 libstdc++.i686 libXrandr.i686 zip perl-Digest-SHA wget lzop openssl-devel \
    java-1.8.0-openjdk-devel ImageMagick ncurses-compat-libs
}

# Parameters
while [[ $# -gt 0 ]]
do
param="$1"

case $param in
     -a|--arch)
     ARCH="arch"
     ;;
     -d|--debian)
     DEBIAN="debian"
     ;;
     -f|--fedora)
     FEDORA="fedora"
     ;;
     -h|--help)
     newLine; echo "Usage: bash distro-setup.sh -a, -d or -f [For arch/debian/fedora]"; newLine
     exit
     ;;
esac
shift
done

# Print this if no parameters provided
if [[ "${ARCH}" != '1' ]]; then
     newLine; echo "Invalid input: Please provide a parameter! It is mandatory."; newLine

elif [[ "${DEBIAN}" != '1' ]]; then
     newLine; echo "Invalid input: Please provide a parameter! It is mandatory."; newLine

elif [[ "${FEDORA}" != '1' ]]; then
     newLine; echo "Invalid input: Please provide a parameter! It is mandatory."; newLine
fi

# Define actions on parameters
if [[ "${ARCH}" == "arch" ]]; then
    arch_pkgs;
    echoText "Script succeeded"

elif [[ "${DEBIAN}" == "debian" ]]; then
    debian_pkgs;
    echoText "Script succeeded"

elif [[ "${FEDORA}" == "fedora" ]]; then
    fedora_pkgs;
    echoText "Script succeeded"

fi
