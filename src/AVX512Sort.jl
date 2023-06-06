module AVX512Sort
export qsort!, pqsort!, AVX512QuickSort

struct AVX512QuickSort <: Base.Sort.Algorithm; end
function Base.sort!(x::AbstractVector{<:Real}, ::Integer, ::Integer, ::AVX512QuickSort, ord::Base.Order.ForwardOrdering)
    qsort!(x);
    return x;
end
@static if VERSION < v"1.9-"
    # Before Julia 1.9 there was a Float submodule which also needs to be told about this algorithm
    Base.Sort.Float.fpsort!(v::AbstractVector{<:Real}, ::AVX512QuickSort, ::Base.Order.ForwardOrdering) = sort!(v, -1, -1, AVX512QuickSort(), Base.Order.ForwardOrdering())
end

macro override_builtin_sort()
    return esc(quote
        Base.Sort.defalg(v::AbstractVector{<:Real}) = AVX512QuickSort()
        # Need this to override the optimisations present in Julia v1.9
        function Base.Sort.partialsort!(x::AbstractVector{<:Real}, k::Union{Integer,OrdinalRange}, ::Base.Order.ForwardOrdering)
            pqsort!(k, x);
            return Base.Sort.maybeview(x, k);
        end
        function Base.sort!(x::AbstractVector{<:Real}, ::Integer, ::Integer, p::Base.Sort.PartialQuickSort, o::Base.Order.ForwardOrdering)
            pqsort!(p.k, x);
            return x;
        end
    end)
end

const librarypath = joinpath(@__DIR__, "..", "libjlavx512qsort.so")

qsort!(x::AbstractVector{Float64}) = ccall((:inplace_avx512_qsort_double, librarypath), Cvoid, (Ref{Cdouble}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float32}) = ccall((:inplace_avx512_qsort_single, librarypath), Cvoid, (Ref{Cfloat}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float16}) = ccall((:inplace_avx512_qsort_half, librarypath), Cvoid, (Ptr{Cvoid}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialqsort_double, librarypath), Cvoid, (Clonglong, Ref{Cdouble}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialqsort_single, librarypath), Cvoid, (Clonglong, Ref{Cfloat}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialqsort_half, librarypath), Cvoid, (Clonglong, Ptr{Cvoid}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialrangeqsort_double, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cdouble}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialrangeqsort_single, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cfloat}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialrangeqsort_half, librarypath), Cvoid, (Clonglong, Clonglong, Ptr{Cvoid}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{Int64}) = ccall((:inplace_avx512_qsort_int64, librarypath), Cvoid, (Ref{Clonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int32}) = ccall((:inplace_avx512_qsort_int32, librarypath), Cvoid, (Ref{Cint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int16}) = ccall((:inplace_avx512_qsort_int16, librarypath), Cvoid, (Ref{Cshort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialqsort_int64, librarypath), Cvoid, (Clonglong, Ref{Clonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialqsort_int32, librarypath), Cvoid, (Clonglong, Ref{Cint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialqsort_int16, librarypath), Cvoid, (Clonglong, Ref{Cshort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialrangeqsort_int64, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Clonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialrangeqsort_int32, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialrangeqsort_int16, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cshort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{UInt64}) = ccall((:inplace_avx512_qsort_uint64, librarypath), Cvoid, (Ref{Culonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt32}) = ccall((:inplace_avx512_qsort_uint32, librarypath), Cvoid, (Ref{Cuint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt16}) = ccall((:inplace_avx512_qsort_uint16, librarypath), Cvoid, (Ref{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialqsort_uint64, librarypath), Cvoid, (Clonglong, Ref{Culonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialqsort_uint32, librarypath), Cvoid, (Clonglong, Ref{Cuint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialqsort_uint16, librarypath), Cvoid, (Clonglong, Ref{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialrangeqsort_uint64, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Culonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialrangeqsort_uint32, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cuint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialrangeqsort_uint16, librarypath), Cvoid, (Clonglong, Clonglong, Ref{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

end # module AVX512Sort
