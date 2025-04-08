#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cuda_runtime.h>

const int WIDTH = 800;
const int HEIGHT = 800;
const int GRID_SIZE = 256;

extern void launch_cuda_kernel(float* dev_field, int size);

float* field = nullptr;
float* dev_field = nullptr;

void drawField() {
    glBegin(GL_POINTS);
    for (int i = 0; i < GRID_SIZE * GRID_SIZE; ++i) {
        float intensity = field[i];
        glColor3f(intensity, intensity, intensity);
        int x = i % GRID_SIZE;
        int y = i / GRID_SIZE;
        glVertex2f(x / float(GRID_SIZE), y / float(GRID_SIZE));
    }
    glEnd();
}

void checkCUDA(cudaError_t result) {
    if (result != cudaSuccess) {
        std::cerr << "CUDA Runtime Error: " << cudaGetErrorString(result) << std::endl;
        exit(-1);
    }
}

int main() {
    if (!glfwInit()) return -1;
    GLFWwindow* window = glfwCreateWindow(WIDTH, HEIGHT, "CUDA + OpenGL Fluid Sim", NULL, NULL);
    if (!window) return -1;
    glfwMakeContextCurrent(window);
    glewInit();

    field = new float[GRID_SIZE * GRID_SIZE];
    std::fill(field, field + GRID_SIZE * GRID_SIZE, 0.0f);

    checkCUDA(cudaMalloc(&dev_field, GRID_SIZE * GRID_SIZE * sizeof(float)));
    checkCUDA(cudaMemcpy(dev_field, field, GRID_SIZE * GRID_SIZE * sizeof(float), cudaMemcpyHostToDevice));

    while (!glfwWindowShouldClose(window)) {
        glClear(GL_COLOR_BUFFER_BIT);

        launch_cuda_kernel(dev_field, GRID_SIZE);
        checkCUDA(cudaMemcpy(field, dev_field, GRID_SIZE * GRID_SIZE * sizeof(float), cudaMemcpyDeviceToHost));

        drawField();
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    delete[] field;
    cudaFree(dev_field);
    glfwTerminate();
    return 0;
}
