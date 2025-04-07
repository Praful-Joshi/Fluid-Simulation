#!/bin/bash

set -e

sudo apt update
sudo apt install -y build-essential cmake git \
    libgl1-mesa-dev libglu1-mesa-dev \
    libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
    libglew-dev libglfw3-dev

sudo apt install -y nvidia-cuda-toolkit
