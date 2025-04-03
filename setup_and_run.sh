#!/bin/bash
set -e  # Exit if any command fails

# Define the project directory
PROJECT_DIR=~/fluid_simulation

# Function to install dependencies (only run the first time)
install_dependencies() {
    echo "Installing required dependencies..."
    sudo apt install -y build-essential cmake git freeglut3-dev \
        libglew-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

    echo "Removing older CUDA versions if present..."
    sudo apt remove --purge -y nvidia-cuda-toolkit || true
    sudo apt autoremove -y

    echo "Downloading and installing CUDA 12.3..."
    wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda_12.3.2_545.23.08_linux.run -O cuda_12.3.run
    sudo sh cuda_12.3.run --silent --toolkit --verbose
    rm cuda_12.3.run

    # Set CUDA environment variables
    echo 'export PATH=/usr/local/cuda-12.3/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    source ~/.bashrc

    # Verify CUDA installation
    nvcc --version
}

# Check if the project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Project directory not found. Cloning repository..."
    # If not, clone the project and install dependencies
    git clone https://github.com/Praful-Joshi/Fluid-Simulation.git $PROJECT_DIR
    install_dependencies
else
    echo "Project directory exists. Skipping dependency installation."
    echo "Updating project repository..."
    # If the project exists, pull the latest changes from GitHub
    cd $PROJECT_DIR
    git pull origin main
fi

# Build the project
echo "Building the project..."
cd $PROJECT_DIR
mkdir -p build && cd build
cmake ..
make -j$(nproc)

# Run the simulation
echo "Running CUDA + OpenGL simulation..."
./fluid_simulation
