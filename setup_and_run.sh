#!/bin/bash

set -e

# ---------------- CONFIG ----------------
REPO_URL="https://github.com/Praful-Joshi/Fluid-Simulation.git"
CLONE_DIR="$HOME/Fluid-Simulation"
EXECUTABLE_NAME="main"
# ---------------------------------------

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    cmake \
    git \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    libx11-dev \
    libxi-dev \
    libxmu-dev \
    libglew-dev \
    libglfw3-dev \
    software-properties-common \
    wget

# ---------------- INSTALL CUDA (Repo Method) ----------------
echo "Installing CUDA via NVIDIA network repo..."

# Remove any previous installs
sudo apt-get remove --purge -y "*cublas*" "*cufft*" "*curand*" "*cusolver*" "*cusparse*" "*npp*" "*nvjpeg*" "cuda*" "nsight*" || true

# Add NVIDIA CUDA repo
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda

# Set up CUDA paths for current session
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Optional: persist to .bashrc
if ! grep -q "/usr/local/cuda/bin" ~/.bashrc; then
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
fi

# ---------------- CLONE & BUILD ----------------
if [ ! -d "$CLONE_DIR" ]; then
    echo "Cloning project repository..."
    git clone "$REPO_URL" "$CLONE_DIR"
else
    echo "Repository already exists. Pulling latest changes..."
    cd "$CLONE_DIR"
    git pull
    cd ..
fi

echo "Building the project..."
cd "$CLONE_DIR"
mkdir -p build
cd build
cmake ..
make -j$(nproc)

echo "Running $EXECUTABLE_NAME..."
./$EXECUTABLE_NAME
