#include <cuda_runtime.h>
#include <cuda_gl_interop.h>
#include <device_launch_parameters.h>
#include <math.h>

struct Particle {
    float x, y;
};

static cudaGraphicsResource* cudaVBO = nullptr;

__global__ void updateParticlesKernel(Particle* particles, int count, float time) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < count) {
        particles[i].x = ((i % 1000) / 500.0f) - 1.0f;
        particles[i].y = ((i / 1000) / 500.0f) - 1.0f;
    }
}

extern "C" void registerVBOWithCUDA(unsigned int vbo) {
    cudaGraphicsGLRegisterBuffer(&cudaVBO, vbo, cudaGraphicsMapFlagsWriteDiscard);
}

extern "C" void updateParticlesCUDAInterop(int count, float time) {
    Particle* devPtr;
    size_t size;

    cudaGraphicsMapResources(1, &cudaVBO, 0);
    cudaGraphicsResourceGetMappedPointer((void**)&devPtr, &size, cudaVBO);

    int threads = 256;
    int blocks = (count + threads - 1) / threads;
    updateParticlesKernel<<<blocks, threads>>>(devPtr, count, time);

    cudaGraphicsUnmapResources(1, &cudaVBO, 0);
}
