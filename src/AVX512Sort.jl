module AVX512Sort

export qsort!, pqsort!

qsort!(x::Vector{Float64}) = ccall((:inplace_avx512_qsort_double, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cdouble}, Clonglong), x, length(x))
qsort!(x::Vector{Float32}) = ccall((:inplace_avx512_qsort_single, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cfloat}, Clonglong), x, length(x))
qsort!(x::Vector{Float16}) = ccall((:inplace_avx512_qsort_half, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::Vector{Float64}) = ccall((:inplace_avx512_partialqsort_double, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cdouble}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{Float32}) = ccall((:inplace_avx512_partialqsort_single, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cfloat}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{Float16}) = ccall((:inplace_avx512_partialqsort_half, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Float64}) = ccall((:inplace_avx512_partialrangeqsort_double, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cdouble}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Float32}) = ccall((:inplace_avx512_partialrangeqsort_single, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cfloat}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Float16}) = ccall((:inplace_avx512_partialrangeqsort_half, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::Vector{Int64}) = ccall((:inplace_avx512_qsort_int64, "../libjlavx512qsort.so"), Cvoid, (Ptr{Clonglong}, Clonglong), x, length(x))
qsort!(x::Vector{Int32}) = ccall((:inplace_avx512_qsort_int32, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cint}, Clonglong), x, length(x))
qsort!(x::Vector{Int16}) = ccall((:inplace_avx512_qsort_int16, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cshort}, Clonglong), x, length(x))
pqsort!(k::Int, x::Vector{Int64}) = ccall((:inplace_avx512_partialqsort_int64, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Clonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{Int32}) = ccall((:inplace_avx512_partialqsort_int32, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{Int16}) = ccall((:inplace_avx512_partialqsort_int16, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cshort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Int64}) = ccall((:inplace_avx512_partialrangeqsort_int64, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Clonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Int32}) = ccall((:inplace_avx512_partialrangeqsort_int32, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{Int16}) = ccall((:inplace_avx512_partialrangeqsort_int16, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cshort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::Vector{UInt64}) = ccall((:inplace_avx512_qsort_uint64, "../libjlavx512qsort.so"), Cvoid, (Ptr{Culonglong}, Clonglong), x, length(x))
qsort!(x::Vector{UInt32}) = ccall((:inplace_avx512_qsort_uint32, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cuint}, Clonglong), x, length(x))
qsort!(x::Vector{UInt16}) = ccall((:inplace_avx512_qsort_uint16, "../libjlavx512qsort.so"), Cvoid, (Ptr{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::Vector{UInt64}) = ccall((:inplace_avx512_partialqsort_uint64, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Culonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{UInt32}) = ccall((:inplace_avx512_partialqsort_uint32, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cuint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::Vector{UInt16}) = ccall((:inplace_avx512_partialqsort_uint16, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{UInt64}) = ccall((:inplace_avx512_partialrangeqsort_uint64, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Culonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{UInt32}) = ccall((:inplace_avx512_partialrangeqsort_uint32, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cuint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::Vector{UInt16}) = ccall((:inplace_avx512_partialrangeqsort_uint16, "../libjlavx512qsort.so"), Cvoid, (Clonglong, Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

end # module AVX512Sort
