# AVX512Sort.jl

This is an experimental package for Julia that provides a wrapper to the AVX512 accelerated sorting methods published by Intel ([x86-simd-sort](https://github.com/intel/x86-simd-sort)). The submodule contained here is from [my own fork](https://github.com/mosullivan93/x86-simd-sort) as I will occasionally contribute something that I want to try out sooner than it will be upstreamed. I'll make sure to do this on another branch, but I can't promise any other users won't have issues.

## API

There are a few ways to utilise this package.
- It exports `qsort!` and `pqsort!` methods that can sort a vector in place (`pqsort!` accepts either a single index or an ordinal range).
- It exports `AVX512QuickSort <: Base.Sort.Algorithm` that can be used to construct the algorithm argument to many existing sorting methods in `Base`.
- It has (but doesn't export) the `AVX512Sort.@override_builtin_sort` macro so that you can automatically have existing code use these methods without changing anything. This has been non-exhaustively tested on Julia v1.8 and v1.9 and it _looks_ like it works, but, there are also some other limitations to this package that are outlined below and you may encounter issues with such a blanket approach.

## Limitations

The wrapper does not currently support sorting in reverse order... You can emulate this if you don't mind multiplying by -1 before and after. I'm pretty sure it's been coded in such a way that the method will not be findable instead of silently corrupting your results. There is also no support currently for performing an argsort/sortperm. This has recently been released upstream but I haven't had a reason to code it in here yet. Also, at least one of the AVX instrinsics used by this library is known to perform poorly on AMD Zen4 processors. This was discussed on the upstream repository, where one poster seems to have been able to mitigate this by emulating the instruction ([more here](https://github.com/intel/x86-simd-sort/issues/6#issuecomment-1433687405)).

## Building

Obviously the system you expect to run this code on needs a CPU that supports AVX512 instructions; I think most functions require only AVX512F/BW/DQ/VL, while the float16 (_NOT_ AVX512FP16) function also requires AVX512VBMI2. There is no built in logic in the wrapper to filter out calls that your CPU does not support (which I believe will crash your Julia). I'm leaving it up to you to build the library yourself so you will hopefully discover any issues if there's errors in compilation (also I haven't had the time to figure out how to package it robustly using Binary Builder).

You will need at least GCC 8. You may also need to initialise and download the submodules (`git submodule update --init --recursive`). Then you can just run `make`. Once compiled you have a little flexibility in relocating the library. The package adds `pwd()`, `dirname(Base.active_project())`, and original location in the package to the libdirs in `Libdl.find_library` while running its `__init__()` method.
