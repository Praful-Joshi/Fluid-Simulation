#!/bin/bash

# -------- Config --------
REPO_URL="https://github.com/Praful-Joshi/Fluid-Simulation.git"
PROJECT_DIR="$HOME/your-repo"
EXECUTABLE_NAME="fluid_sim"  # or whatever you name your binary

# -------- Update & Install Dependencies --------
sudo apt update && sudo apt install -y \
    git \
    build-essential \
    cmake \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    libx11-dev \
    libxi-dev \
    libxmu-dev

# -------- Clone or Pull Repo --------
if [ -d "$PROJECT_DIR" ]; then
    echo "Repo already exists. Pulling latest changes..."
    cd "$PROJECT_DIR"
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi

# -------- Build the Project --------
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# -------- Run the Executable --------
echo "Running $EXECUTABLE_NAME..."
./$EXECUTABLE_NAME
