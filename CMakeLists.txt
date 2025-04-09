cmake_minimum_required(VERSION 3.18)
project(FluidSim LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(GLFW REQUIRED glfw3)

include_directories(
    ${OPENGL_INCLUDE_DIRS}
    ${GLEW_INCLUDE_DIRS}
    ${GLFW_INCLUDE_DIRS}
    ${CMAKE_SOURCE_DIR}
    ./include
)

add_executable(FluidSim
    src/fluidobj3d.cpp
    src/fluidsolver3d.cpp
    src/grids3d.cpp
    src/main.cpp
    src/rendercontext3d.cpp
    src/renderobj3d.cpp 
)

target_link_libraries(FluidSim
    ${OPENGL_LIBRARIES}
    ${GLEW_LIBRARIES}
    ${GLFW_LIBRARIES}
    cuda
    cudart
)