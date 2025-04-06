#!/bin/bash

set -e

# ---------------- CONFIG ----------------
REPO_URL="https://github.com/Praful-Joshi/Fluid-Simulation.git"
CLONE_DIR="$HOME/Fluid-Simulation"
EXECUTABLE_NAME="main"
# ---------------------------------------

echo "Installing dependencies..."
# Update package lists
sudo apt update

# Install build essentials and cmake
sudo apt install -y build-essential cmake

# Install OpenGL development libraries
sudo apt install -y libgl1-mesa-dev libglu1-mesa-dev

# Install FreeGLUT (OpenGL utility toolkit)
sudo apt install -y freeglut3-dev

# Install GLEW (OpenGL Extension Wrangler Library)
sudo apt install -y libglew-dev

# Install CUDA (ensure you have the correct NVIDIA driver and CUDA version installed for your GPU)
# The following command installs the CUDA toolkit if it’s not installed. You may want to install the version compatible with your GPU.
# Uncomment the following line if CUDA is not installed.
sudo apt install -y nvidia-cuda-toolkit

# Install the CUDA GL interop library (for CUDA/OpenGL interoperability)
sudo apt install -y libcuda-dev

# Install additional NVIDIA libraries (if required for CUDA interop)
sudo apt install -y nvidia-opencl-dev

# Ensure the NVIDIA driver is installed (if using GPU)
# sudo apt install -y nvidia-driver-XXX   # Replace XXX with the version number compatible with your GPU

# Install Git (to pull code from a repository, if needed)
sudo apt install -y git

# Install libX11-dev (dependency for GLUT/FreeGLUT)
sudo apt install -y libx11-dev

# Clean up
sudo apt autoremove -y

# Confirm installation
echo "Dependencies installed successfully!"

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
