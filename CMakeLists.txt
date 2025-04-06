cmake_minimum_required(VERSION 3.10)
project(cuda_opengl_test LANGUAGES C CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 11)

find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)

include_directories(${OPENGL_INCLUDE_DIRS} ${GLUT_INCLUDE_DIRS})
include_directories(/usr/include /usr/local/include)

add_executable(cuda_opengl_test src/main.cu)
target_link_libraries(cuda_opengl_test
    ${OPENGL_LIBRARIES}
    ${GLUT_LIBRARIES}
    GL
    GLEW
    cuda
    cudart
)
