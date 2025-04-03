#!/bin/bash
set -e  # Exit if any command fails

echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y build-essential cmake git freeglut3-dev \
    libglew-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev \
    nvidia-cuda-toolkit nvidia-driver-535

# Verify CUDA installation
nvcc --version

# Set CUDA environment variables
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Clone or update the project
PROJECT_DIR=~/fluid_simulation
if [ -d "$PROJECT_DIR" ]; then
    echo "Updating existing project..."
    cd $PROJECT_DIR
    git pull origin main
else
    echo "Cloning project repository..."
    git clone https://github.com/yourusername/yourfluidproject.git $PROJECT_DIR
    cd $PROJECT_DIR
fi

# Build the project
echo "Building project..."
mkdir -p build && cd build
cmake ..
make -j$(nproc)

# Run the simulation
echo "Running CUDA + OpenGL simulation..."
./fluid_simulation
