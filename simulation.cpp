#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <cuda_runtime.h>
#include <iostream>
#include <vector>

#include "simulation.hpp"
#include "input.hpp"

const int WIN_WIDTH = 800;
const int WIN_HEIGHT = 800;
const int N = 128;

float *density, *source;
float *dev_density, *dev_source;

void checkCUDA(cudaError_t result) {
    if (result != cudaSuccess) {
        std::cerr << "CUDA Runtime Error: " << cudaGetErrorString(result) << std::endl;
        exit(-1);
    }
}

void draw_density() {
    glBegin(GL_POINTS);
    for (int j = 0; j < N; ++j) {
        for (int i = 0; i < N; ++i) {
            int index = j * N + i;
            float d = density[index];
            glColor3f(d, d, d);
            glVertex2f(i / float(N), j / float(N));
        }
    }
    glEnd();
}

int main() {
    if (!glfwInit()) return -1;
    GLFWwindow* window = glfwCreateWindow(WIN_WIDTH, WIN_HEIGHT, "CUDA Fluid Sim", NULL, NULL);
    if (!window) return -1;
    glfwMakeContextCurrent(window);
    glewInit();

    setup_input_callbacks(window);

    density = new float[N * N]{};
    source = new float[N * N]{};
    checkCUDA(cudaMalloc(&dev_density, N * N * sizeof(float)));
    checkCUDA(cudaMalloc(&dev_source, N * N * sizeof(float)));

    while (!glfwWindowShouldClose(window)) {
        glClear(GL_COLOR_BUFFER_BIT);

        // Inject density at mouse
        double mx, my;
        get_mouse_pos(mx, my);
        if (is_mouse_down()) {
            int i = int(mx / WIN_WIDTH * N);
            int j = int((WIN_HEIGHT - my) / WIN_HEIGHT * N);
            if (i >= 1 && i < N - 1 && j >= 1 && j < N - 1)
                source[j * N + i] = 100.0f;
        }

        checkCUDA(cudaMemcpy(dev_source, source, N * N * sizeof(float), cudaMemcpyHostToDevice));
        add_source_cuda(dev_density, dev_source, 0.1f, N);
        checkCUDA(cudaMemcpy(density, dev_density, N * N * sizeof(float), cudaMemcpyDeviceToHost));

        draw_density();
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    delete[] density;
    delete[] source;
    cudaFree(dev_density);
    cudaFree(dev_source);
    glfwTerminate();
    return 0;
}
