cmake_minimum_required(VERSION 3.10)
project(OpenGL_CUDA_Project)

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_path(GLM_INCLUDE_DIR glm/glm.hpp)
if (NOT GLM_INCLUDE_DIR)
    message(FATAL_ERROR "GLM not found")
endif()
include_directories(${GLM_INCLUDE_DIR})
find_package(GLUT REQUIRED)
find_package(glfw3 REQUIRED)

add_executable(main main.cpp)
target_link_libraries(main OpenGL::GL OpenGL::GLU GLEW::GLEW glfw GLUT::GLUT)
