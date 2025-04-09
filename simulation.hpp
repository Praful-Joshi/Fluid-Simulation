#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void add_source_cuda(float* x, float* s, float dt, int N);

#ifdef __cplusplus
}
#endif
