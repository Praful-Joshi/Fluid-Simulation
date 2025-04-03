cmake_minimum_required(VERSION 3.10)
project(FluidSimulation LANGUAGES CUDA CXX)

# Enable CUDA
enable_language(CUDA)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 17)

# Find OpenGL and GLUT
find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)

# Add the executable
add_executable(fluid_simulation simulation.cu)

# Link OpenGL, GLUT, and CUDA
target_link_libraries(fluid_simulation 
    OpenGL::GL 
    GLUT::GLUT 
    cuda
)
