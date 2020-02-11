@inline function anydifferent(xs::AbstractArray)
    length(xs) < 2 && return false
    el = xs[1]
    @inbounds for i in 2:length(xs)
        xs[i] == el || return true
    end
    false
end

@inline function scanl(f::Function, x::T, n::Int) where T
    result = Vector{T}(undef, n+1)
    result[1] = x
    @inbounds for i in 1:n
        result[i+1] = f(result[i])
    end
    result
end
