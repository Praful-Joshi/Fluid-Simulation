#!/bin/bash

set -e

# ---- CONFIG ----
REPO_URL="https://github.com/Praful-Joshi/Fluid-Simulation.git"
PROJECT_DIR="Fluid-Simulation"

# ---- FETCH PROJECT ----
if [ -d "$PROJECT_DIR" ]; then
    echo "[INFO] Project already exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull
    cd ..
else
    echo "[INFO] Cloning project..."
    git clone "$REPO_URL"
fi

# ---- INSTALL DEPENDENCIES ----
sudo apt update
sudo apt install -y build-essential cmake git \
    libgl1-mesa-dev libglu1-mesa-dev \
    libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
    libglew-dev libglfw3-dev

# CUDA (only if nvcc not already available)
if ! command -v nvcc &> /dev/null; then
    echo "[INFO] Installing CUDA toolkit..."
    sudo apt install -y nvidia-cuda-toolkit
else
    echo "[INFO] CUDA already installed (nvcc found)"
fi
