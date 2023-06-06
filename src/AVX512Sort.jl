module AVX512Sort

export qsort!, pqsort!, AVX512QuickSort

global libpath::String
function __init__()
    # We'll try searching a few places for this file..
    local libdirs = String[]

    # Prioritise the working directory of Julia
    push!(libdirs, pwd())
    # Also include the folder containing the current project
    push!(libdirs, dirname(Base.active_project()))
    # Finally, check for the compiled library in the module folder
    push!(libdirs, normpath(@__DIR__, ".."))

    # Check where it was found (hopefully) log the path
    global libpath = Base.Libc.Libdl.find_library("libjlavx512qsort", libdirs)
    isempty(libpath) && error("Could not locate libjlavx512qsort.$(Base.Libc.Libdl.dlext). Have you compiled it?")
    @info "Using AVX512 sorting library at:\n$(libpath).$(Base.Libc.Libdl.dlext)"
end

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

qsort!(x::AbstractVector{Float64}) = ccall((:inplace_avx512_qsort_double, libpath), Cvoid, (Ref{Cdouble}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float32}) = ccall((:inplace_avx512_qsort_single, libpath), Cvoid, (Ref{Cfloat}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Float16}) = ccall((:inplace_avx512_qsort_half, libpath), Cvoid, (Ptr{Cvoid}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialqsort_double, libpath), Cvoid, (Clonglong, Ref{Cdouble}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialqsort_single, libpath), Cvoid, (Clonglong, Ref{Cfloat}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialqsort_half, libpath), Cvoid, (Clonglong, Ptr{Cvoid}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float64}) = ccall((:inplace_avx512_partialrangeqsort_double, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cdouble}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float32}) = ccall((:inplace_avx512_partialrangeqsort_single, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cfloat}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Float16}) = ccall((:inplace_avx512_partialrangeqsort_half, libpath), Cvoid, (Clonglong, Clonglong, Ptr{Cvoid}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{Int64}) = ccall((:inplace_avx512_qsort_int64, libpath), Cvoid, (Ref{Clonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int32}) = ccall((:inplace_avx512_qsort_int32, libpath), Cvoid, (Ref{Cint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{Int16}) = ccall((:inplace_avx512_qsort_int16, libpath), Cvoid, (Ref{Cshort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialqsort_int64, libpath), Cvoid, (Clonglong, Ref{Clonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialqsort_int32, libpath), Cvoid, (Clonglong, Ref{Cint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialqsort_int16, libpath), Cvoid, (Clonglong, Ref{Cshort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int64}) = ccall((:inplace_avx512_partialrangeqsort_int64, libpath), Cvoid, (Clonglong, Clonglong, Ref{Clonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int32}) = ccall((:inplace_avx512_partialrangeqsort_int32, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{Int16}) = ccall((:inplace_avx512_partialrangeqsort_int16, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cshort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

qsort!(x::AbstractVector{UInt64}) = ccall((:inplace_avx512_qsort_uint64, libpath), Cvoid, (Ref{Culonglong}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt32}) = ccall((:inplace_avx512_qsort_uint32, libpath), Cvoid, (Ref{Cuint}, Clonglong), x, length(x))
qsort!(x::AbstractVector{UInt16}) = ccall((:inplace_avx512_qsort_uint16, libpath), Cvoid, (Ref{Cushort}, Clonglong), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialqsort_uint64, libpath), Cvoid, (Clonglong, Ref{Culonglong}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialqsort_uint32, libpath), Cvoid, (Clonglong, Ref{Cuint}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::Int, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialqsort_uint16, libpath), Cvoid, (Clonglong, Ref{Cushort}, Clonglong), convert(Int64, k), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt64}) = ccall((:inplace_avx512_partialrangeqsort_uint64, libpath), Cvoid, (Clonglong, Clonglong, Ref{Culonglong}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt32}) = ccall((:inplace_avx512_partialrangeqsort_uint32, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cuint}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))
pqsort!(k::OrdinalRange, x::AbstractVector{UInt16}) = ccall((:inplace_avx512_partialrangeqsort_uint16, libpath), Cvoid, (Clonglong, Clonglong, Ref{Cushort}, Clonglong), convert(Int64, first(k)), convert(Int64, last(k)), x, length(x))

end # module AVX512Sort
