using BSON, Parameters, Pkg

"""
    version()

Get the current version of CaimCore.

```jldoctest
julia> CaimCore.version()
v"0.1.0"
```
"""
function version()
    projectfile = joinpath(@__DIR__, "..", "Project.toml")
    @unpack version = Pkg.TOML.parsefile(projectfile)
    VersionNumber(version)
end

"""
    Session()

A structure for storing session information for a CaimCore analysis.
"""
mutable struct Session
    version::VersionNumber
    datasets::Vector{Dataset}
end
Session() = Session(version())
Session(v::VersionNumber) = Session(v, Dataset[])

"""
    save(filename, session)

Save the persistent component of a [`Session`](@ref) to a file.
"""
function save(filename::AbstractString, session::Session)
    bson(filename, Dict(:session => session))
end

"""
    load(::Type{Session}, filename)

Load a [`Session`](@ref) from disc.
"""
function load(::Type{Session}, filename::AbstractString)
    @unpack session = BSON.load(filename)
    return session
end

"""
    dataset!(session, dataset)

Add a dataset to the session, returning the session.
"""
function dataset!(session::Session, dataset::Dataset)
    push!(session.datasets, dataset)
    session
end

"""
    dataset!(session, T, args...; kwargs...)

Load a dataset and add it to the session, returning the session.
"""
function dataset!(session::Session, T::Type{<:Dataset}, args...; kwargs...)
    dataset!(session, load(T, args...; kwargs...))
end
