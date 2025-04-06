#include <GL/glew.h>
#include <GL/freeglut.h>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>
#include <iostream>

// OpenGL display function
void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glFlush();
}

// CUDA kernel (just a dummy example)
__global__ void cudaKernel() {
    printf("CUDA Kernel Running on GPU!\n");
}

int main(int argc, char** argv) {
    // Initialize OpenGL
    glutInit(&argc, argv);
    glutCreateWindow("CUDA OpenGL Simulation");
    glewInit();
    glutDisplayFunc(display);

    // Launch CUDA kernel
    cudaKernel<<<1, 1>>>();
    cudaDeviceSynchronize();

    // Start OpenGL main loop
    glutMainLoop();
    return 0;
}
