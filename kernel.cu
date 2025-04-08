#include <cuda_runtime.h>

__global__ void fluidKernel(float* field, int size) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= size || y >= size) return;

    int idx = y * size + x;

    // Create a simple wave simulation
    float value = sinf(x * 0.05f + clock() * 0.0001f) * cosf(y * 0.05f + clock() * 0.0001f);
    field[idx] = 0.5f + 0.5f * value;
}

extern "C" void launch_cuda_kernel(float* dev_field, int size) {
    dim3 threads(16, 16);
    dim3 blocks((size + threads.x - 1) / threads.x,
                (size + threads.y - 1) / threads.y);

    fluidKernel<<<blocks, threads>>>(dev_field, size);
    cudaDeviceSynchronize();
}
