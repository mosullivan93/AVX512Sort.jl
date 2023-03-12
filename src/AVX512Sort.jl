module AVX512Sort
export qsort!, pqsort!

import Base: sort!, ForwardOrdering
import Base.Sort: QuickSortAlg, defalg
import Base.Sort.Float: fpsort!

defalg(v::AbstractVector{<:Real}) = QuickSortAlg()
fpsort!(v::AbstractVector{<:Real}, ::QuickSortAlg, ::ForwardOrdering) = sort!(v, -1, -1, QuickSortAlg(), ForwardOrdering())
function sort!(x::AbstractVector{<:Real}, ::Integer, ::Integer, ::QuickSortAlg, ::ForwardOrdering)
    qsort!(x);
    return x;
end
function sort!(x::AbstractVector{<:Real}, ::Integer, ::Integer, p::PartialQuickSort, ::ForwardOrdering)
    pqsort!(p.k, x);
    return x;
end

const librarypath = joinpath(@__DIR__, "..", "libjlavx512qsort.so")

qsort!(x::AbstractVector{Float64}) = ccall((:inplace_avx512_qsort_double, librarypath), Cvoid, (Ptr{Cdouble}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float32}) = ccall((:inplace_avx512_qsort_single, librarypath), Cvoid, (Ptr{Cfloat}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float16}) = ccall((:inplace_avx512_qsort_half, librarypath), Cvoid, (Ptr{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialqsort_double, librarypath), Cvoid, (Clonglong, Ptr{Cdouble}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialqsort_single, librarypath), Cvoid, (Clonglong, Ptr{Cfloat}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialqsort_half, librarypath), Cvoid, (Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialrangeqsort_double, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cdouble}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialrangeqsort_single, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cfloat}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialrangeqsort_half, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{Int64}) = ccall((:inplace_avx512_qsort_int64, librarypath), Cvoid, (Ptr{Clonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int32}) = ccall((:inplace_avx512_qsort_int32, librarypath), Cvoid, (Ptr{Cint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int16}) = ccall((:inplace_avx512_qsort_int16, librarypath), Cvoid, (Ptr{Cshort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialqsort_int64, librarypath), Cvoid, (Clonglong, Ptr{Clonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialqsort_int32, librarypath), Cvoid, (Clonglong, Ptr{Cint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialqsort_int16, librarypath), Cvoid, (Clonglong, Ptr{Cshort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialrangeqsort_int64, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Clonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialrangeqsort_int32, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialrangeqsort_int16, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cshort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{UInt64}) = ccall((:inplace_avx512_qsort_uint64, librarypath), Cvoid, (Ptr{Culonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt32}) = ccall((:inplace_avx512_qsort_uint32, librarypath), Cvoid, (Ptr{Cuint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt16}) = ccall((:inplace_avx512_qsort_uint16, librarypath), Cvoid, (Ptr{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialqsort_uint64, librarypath), Cvoid, (Clonglong, Ptr{Culonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialqsort_uint32, librarypath), Cvoid, (Clonglong, Ptr{Cuint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialqsort_uint16, librarypath), Cvoid, (Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialrangeqsort_uint64, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Culonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialrangeqsort_uint32, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cuint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialrangeqsort_uint16, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

end # module AVX512Sort
