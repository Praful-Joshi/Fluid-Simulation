#include "simulation.hpp"

__global__ void add_source(float* x, float* s, float dt, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= size) return;
    x[i] += dt * s[i];
}

extern "C" void add_source_cuda(float* x, float* s, float dt, int N) {
    int size = N * N;
    int threads = 256;
    int blocks = (size + threads - 1) / threads;
    add_source<<<blocks, threads>>>(x, s, dt, size);
    cudaDeviceSynchronize();
}
