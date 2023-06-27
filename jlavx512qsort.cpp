#include "x86-simd-sort/src/avx512-64bit-qsort.hpp"
#include "x86-simd-sort/src/avx512-32bit-qsort.hpp"
#include "x86-simd-sort/src/avx512-16bit-qsort.hpp"

extern "C" void inplace_avx512_qsort_double(double *arr, int64_t arrsize) {
        avx512_qsort<double>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_single(float *arr, int64_t arrsize) {
        avx512_qsort<float>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_half(uint16_t *arr, int64_t arrsize) {
        avx512_qsort_fp16(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_int64(int64_t *arr, int64_t arrsize) {
        avx512_qsort<int64_t>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_int32(int32_t *arr, int64_t arrsize) {
        avx512_qsort<int32_t>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_int16(int16_t *arr, int64_t arrsize) {
        avx512_qsort<int16_t>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_uint64(uint64_t *arr, int64_t arrsize) {
        avx512_qsort<uint64_t>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_uint32(uint32_t *arr, int64_t arrsize) {
        avx512_qsort<uint32_t>(arr, arrsize);
}

extern "C" void inplace_avx512_qsort_uint16(uint16_t *arr, int64_t arrsize) {
        avx512_qsort<uint16_t>(arr, arrsize);
}

extern "C" void inplace_avx512_partialqsort_double(int64_t k, double *arr, int64_t arrsize) {
        avx512_qselect<double>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_single(int64_t k, float *arr, int64_t arrsize) {
        avx512_qselect<float>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_half(int64_t k, uint16_t *arr, int64_t arrsize) {
        avx512_qselect_fp16(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_int64(int64_t k, int64_t *arr, int64_t arrsize) {
        avx512_qselect<int64_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_int32(int64_t k, int32_t *arr, int64_t arrsize) {
        avx512_qselect<int32_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_int16(int64_t k, int16_t *arr, int64_t arrsize) {
        avx512_qselect<int16_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_uint64(int64_t k, uint64_t *arr, int64_t arrsize) {
        avx512_qselect<uint64_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_uint32(int64_t k, uint32_t *arr, int64_t arrsize) {
        avx512_qselect<uint32_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialqsort_uint16(int64_t k, uint16_t *arr, int64_t arrsize) {
        avx512_qselect<uint16_t>(arr, k-1, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_double(int64_t kfrom, int64_t kto, double *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<double>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<double>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<double>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_single(int64_t kfrom, int64_t kto, float *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<float>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<float>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<float>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_half(int64_t kfrom, int64_t kto, uint16_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect_fp16(arr, kfrom-1, arrsize);
                avx512_partial_qsort_fp16(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort_fp16(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_int64(int64_t kfrom, int64_t kto, int64_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<int64_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<int64_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<int64_t>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_int32(int64_t kfrom, int64_t kto, int32_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<int32_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<int32_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<int32_t>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_int16(int64_t kfrom, int64_t kto, int16_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<int16_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<int16_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<int16_t>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_uint64(int64_t kfrom, int64_t kto, uint64_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<uint64_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<uint64_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<uint64_t>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_uint32(int64_t kfrom, int64_t kto, uint32_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<uint32_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<uint32_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<uint32_t>(arr, kto, arrsize);
}

extern "C" void inplace_avx512_partialrangeqsort_uint16(int64_t kfrom, int64_t kto, uint16_t *arr, int64_t arrsize) {
        if (kfrom > 1)
        {
                avx512_qselect<uint16_t>(arr, kfrom-1, arrsize);
                avx512_partial_qsort<uint16_t>(arr+kfrom, kto-kfrom, arrsize-kfrom);
        } else
                avx512_partial_qsort<uint16_t>(arr, kto, arrsize);
}
