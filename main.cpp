#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <vector>
#include <iostream>
#include <chrono>
#include <cmath>

extern "C" void updateParticlesOnGPU(Particle* particles, int count, float time);

struct Particle {
    float x, y;
};

const int NUM_PARTICLES = 100000;
GLuint vbo;
GLuint vao;
std::vector<Particle> particles;


void initParticles() {
    particles.resize(NUM_PARTICLES);
    for (int i = 0; i < NUM_PARTICLES; ++i) {
        particles[i].x = (float(rand()) / RAND_MAX) * 2.0f - 1.0f;
        particles[i].y = (float(rand()) / RAND_MAX) * 2.0f - 1.0f;
    }
}

void updateParticlesCPU(float time) {
    for (int i = 0; i < NUM_PARTICLES; ++i) {
        particles[i].y = 0.5f * std::sin(time + i * 0.0001f);
    }
}

void setupVBO() {
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, NUM_PARTICLES * sizeof(Particle), nullptr, GL_DYNAMIC_DRAW);

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)0);
    glEnableVertexAttribArray(0);
}

void renderParticles() {
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
}

int main() {
    if (!glfwInit()) {
        std::cerr << "Failed to init GLFW\n";
        return -1;
    }

    GLFWwindow* window = glfwCreateWindow(800, 600, "CPU Renderer", nullptr, nullptr);
    if (!window) {
        std::cerr << "Failed to create window\n";
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    glewInit();

    initParticles();
    setupVBO();
    int frameCount = 0;
    float totalFrameTime = 0.0f;
    const int SAMPLE_INTERVAL = 120;
    while (!glfwWindowShouldClose(window)) {
        auto start = std::chrono::high_resolution_clock::now();

        float time = glfwGetTime();
        //updateParticlesCPU(time);
        updateParticlesOnGPU(particles.data(), NUM_PARTICLES, time);

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferSubData(GL_ARRAY_BUFFER, 0, NUM_PARTICLES * sizeof(Particle), particles.data());

        renderParticles();

        glfwSwapBuffers(window);
        glfwPollEvents();

        auto end = std::chrono::high_resolution_clock::now();
        float ms = std::chrono::duration<float, std::milli>(end - start).count();
        totalFrameTime += ms;
        frameCount++;

        if (frameCount == SAMPLE_INTERVAL) {
            float avg = totalFrameTime / SAMPLE_INTERVAL;
            std::cout << "[CUDA MODE - interop] Avg frame time over " << SAMPLE_INTERVAL << " frames: " << avg << "           ms\n";
            frameCount = 0;
            totalFrameTime = 0.0f;
        }
    }

    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}
