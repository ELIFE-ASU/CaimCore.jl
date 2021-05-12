using ..CaimCore

abstract type Feature <: CaimCore.Feature end

function Base.iterate(f::Feature)
    b = box(f)
    next = iterate(b)
    while !isnothing(next)
        p, state = next
        if p in f
            return p, (b, state)
        end
        next = iterate(b, state)
    end
    nothing
end

function Base.iterate(f::Feature, (b, state))
    next = iterate(b, state)
    while !isnothing(next)
        p, state = next
        if p in f
            return p, (b, state)
        end
        next = iterate(b, state)
    end
    nothing
end

function CaimCore.series(d::VideoGraphicDataset{C}, f::Feature;
						 Acc::Type{A}=SqrtColorAccumulator{C},
						 kwargs...) where {C, D, A <: ColorAccumulator{C,D}}
    width, height, duration = size(d)
    series = Array{D}(undef, duration)
    acc = Acc()
    for t in 1:duration
        for p in f
            if all([1,1] .<= p .<= [width,height])
            	add!(acc, d.frames[p[1], p[2], t])
            end
        end
        series[t] = color(acc)
        reset!(acc)
    end
    series
end

const Point = AbstractVector{<:Integer}

macro ensure2d(ps...)
    Expr(:block, map(ps) do p
        :(length($(esc(p))) == 2 || throw(ArgumentError("point must have length 2")))
    end...)
end

struct Box{P <: Point} <: Feature
    tl::P
    br::P
    function Box(a::P, b::P) where {P <: Point}
        @ensure2d a b
        new{P}(min.(a, b), max.(a, b))
    end
end
width(b::Box) = 1 + b.br[1] - b.tl[1]
height(b::Box) = 1 + b.br[2] - b.tl[2]
area(b::Box) = width(b) * height(b)

Base.iterate(b::Box) = (b.tl, (b.tl, 1))
function Base.iterate(b::Box, state)
    p, i = state
    if i >= area(b)
        nothing
    else
        q = (p[1] < b.br[1]) ? [p[1] + 1, p[2]] : [b.tl[1], p[2] + 1]
        q, (q, i + 1)
    end
end
Base.length(b::Box) = area(b)
Base.eltype(b::Box{P}) where P = P

Base.:(==)(b::Box{P}, c::Box{P}) where P = b.tl == c.tl && b.br == c.br
Base.:(==)(b::Box{P}, c::Box{Q}) where {P, Q} = false

Base.in(p::P, b::Box{P}) where {P <: Point} = all(b.tl .<= p .<= b.br)
Base.in(p, b::Box) = false

struct Circle{P <: Point} <: Feature
    center::P
    radius::Float64
    radius²::Float64
    function Circle(c::Point, r::Real)
        @ensure2d c
        new{typeof(c)}(c, abs(r), r^2)
    end
end

function Circle(c::Point, b::Point)
    @ensure2d c b
    r = norm(b - c)
    Circle(c, r)
end

function box(c::Circle)
    tl = round.(Int, c.center .- c.radius)
    br = round.(Int, c.center .+ c.radius)

    Box(tl, br)
end

function Base.in(p::P, c::Circle{P}) where {P <: Point}
    if length(p) != 2
        false
    else
        rx, ry = p .- c.center
        rx^2 + ry^2 ≤ c.radius²
    end
end
Base.in(p, c::Circle) = false
Base.IteratorSize(::Circle) = Base.SizeUnknown()

struct FreeForm{P <: Point} <: Feature
    boundary::Vector{P}
    function FreeForm(b::Vector{P}) where {P <: Point}
        if isempty(b)
            throw(ArgumentError("boundary must be non-empty"))
        end
        for p in b
            @ensure2d p
        end
        new{P}(b)
    end
end

function box(f::FreeForm)
    tl = f.boundary[1]
    br = f.boundary[1]
    for p in f.boundary
        tl = min.(tl, p)
        br = max.(br, p)
    end
    Box(tl, br)
end

function Base.in(p::P, f::FreeForm{P}) where {P <: Point}
    if length(p) != 2
        false
    else
        windingnumber = 0
        len = length(f.boundary)
        for i in 1:len
            r, s = f.boundary[i], f.boundary[(i + 1 <= len) ? i + 1 : 1]
            isleft = (s[1] - r[1]) * (p[2] - r[2])  - (p[1] -  r[1]) * (s[2] - r[2])

            if all(((r .<= p) .& (p .<= s)) .| ((s .<= p) .& (p .<= r)))
                if isleft == 0
                    windingnumber = 1
                    break
                end
            end

            if r[2] <= p[2]
                if s[2] > p[2] && isleft > 0
                    windingnumber += 1
                else
                end
            elseif s[2] <= p[2] && isleft < 0
                windingnumber -= 1
            end
        end

        windingnumber != 0
    end
end
Base.in(p, f::FreeForm) = false
Base.IteratorSize(::FreeForm) = Base.SizeUnknown()
