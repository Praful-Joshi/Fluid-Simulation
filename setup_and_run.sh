#!/bin/bash

set -e

# ---------------- CONFIG ----------------
REPO_URL="https://github.com/Praful-Joshi/Fluid-Simulation.git"
CLONE_DIR="$HOME/cuda-opengl-test"
EXECUTABLE_NAME="cuda_opengl_test"
# ---------------------------------------

echo "Installing dependencies..."
sudo apt update && sudo apt install -y \
    git \
    build-essential \
    cmake \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    libglew-dev \
    libx11-dev \
    libxi-dev \
    libxmu-dev \
    libglfw3-dev

echo "Cloning or updating repo..."
if [ -d "$CLONE_DIR" ]; then
    cd "$CLONE_DIR"
    git pull
else
    git clone "$REPO_URL" "$CLONE_DIR"
    cd "$CLONE_DIR"
fi

echo "Building the project..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

echo "Running $EXECUTABLE_NAME..."
./$EXECUTABLE_NAME
