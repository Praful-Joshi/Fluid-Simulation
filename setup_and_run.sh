#!/bin/bash
set -e  # Exit if any command fails

# Define the project directory
PROJECT_DIR=~/fluid_simulation

# Function to install dependencies (only run the first time)
install_dependencies() {
    echo "Installing required dependencies..."
    sudo apt install -y build-essential cmake git freeglut3-dev \
        libglew-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev
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
