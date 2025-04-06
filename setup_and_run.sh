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

echo "Installing CUDA Toolkit..."

# Add NVIDIA package repository and install CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-ubuntu2204-12-3-local_12.3.2-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-3-local_12.3.2-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

# Add to PATH and LD_LIBRARY_PATH for current shell session
export PATH=/usr/local/cuda-12.3/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Persist this in ~/.bashrc for future sessions
echo 'export PATH=/usr/local/cuda-12.3/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc


echo "Building the project..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

echo "Running $EXECUTABLE_NAME..."
./$EXECUTABLE_NAME
