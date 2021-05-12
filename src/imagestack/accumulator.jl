using ..CaimCore

abstract type ColorAccumulator{C <: Color, D <: Color} <: CaimCore.Accumulator{C,D} end
abstract type SimpleColorAccumulator{C <: Color} <: ColorAccumulator{C,C} end

color(acc::ColorAccumulator) = CaimCore.summarize(acc)

mutable struct SqrtColorAccumulator{C} <: SimpleColorAccumulator{C}
	n::Int
	components::Vector{Float64}
	SqrtColorAccumulator{C}() where {C <: Color} = new(0, zeros(length(C)))
end

function CaimCore.add!(a::SqrtColorAccumulator{C}, c::C) where {T, C <: Color{T,1}}
	a.components[1] += comp1(c)^2
	a.n += 1
	a
end

function CaimCore.add!(a::SqrtColorAccumulator{C}, c::C) where {T, C <: Color{T,2}}
	a.components[1] += comp1(c)^2
	a.components[2] += comp2(c)^2
	a.n += 1
	a
end

function CaimCore.add!(a::SqrtColorAccumulator{C}, c::C) where {T, C <: Color{T,3}}
	a.components[1] += comp1(c)^2
	a.components[2] += comp2(c)^2
	a.components[3] += comp3(c)^2
	a.n += 1
	a
end

function CaimCore.summarize(a::SqrtColorAccumulator{C}) where {C <: Color}
	if a.n == zero(a.n)
		C(a.components...)
	end
	C(sqrt.(a.components ./ a.n)...)
end

CaimCore.reset!(a::SqrtColorAccumulator) = (a.n = 0; a.components .= 0; a)
