abstract type Accumulator{A,B} end

intype(::Type{Accumulator{A}}) where A = A
intype(acc::Accumulator) = intype(typeof(acc))

outtype(::Type{Accumulator{A,B}}) where {A,B} = B
outtype(acc::Accumulator) = outtype(typeof(acc))

"""
"""
add!(::Accumulator{A}, ::A) where A = nothing

"""
"""
summarize(::Accumulator) = nothing

"""
"""
reset!(::Accumulator) = nothing

abstract type SimpleAccumulator{A} <: Accumulator{A,A} end
