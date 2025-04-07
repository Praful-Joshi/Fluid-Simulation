#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <math.h>

struct Particle {
    float x, y;
};

__global__ void updateParticlesKernel(Particle* particles, int count, float time) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < count) {
        particles[i].y = 0.5f * sinf(time + i * 0.0001f);
    }
}

extern "C" void updateParticlesOnGPU(Particle* hostParticles, int count, float time) {
    Particle* devParticles;
    size_t size = count * sizeof(Particle);

    cudaMalloc(&devParticles, size);
    cudaMemcpy(devParticles, hostParticles, size, cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (count + threads - 1) / threads;
    updateParticlesKernel<<<blocks, threads>>>(devParticles, count, time);

    cudaMemcpy(hostParticles, devParticles, size, cudaMemcpyDeviceToHost);
    cudaFree(devParticles);
}
