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
    SessionStorage([version])

Persistent storage component of a CaimCore [`Session`](@ref). This data will be
saved and read from disk via calls to [`save`](@ref) and [`load`](@ref).

```jldoctest
julia> SessionStorage()
SessionStorage(v"0.1.0")
```
"""
mutable struct SessionStorage
    version::VersionNumber
    datasets::Vector{Dataset}
end
SessionStorage(v::VersionNumber) = SessionStorage(v, Dataset[])
SessionStorage() = SessionStorage(version())

"""
    Session()

A structure for storing session information for a CaimCore analysis.
"""
mutable struct Session
    storage::SessionStorage
end
Session() = Session(SessionStorage())

"""
    save(filename, session)

Save the persistent component of a [`Session`](@ref) to a file.
"""
function save(filename::AbstractString, session::Session)
    bson(filename, Dict(:storage => session.storage))
end

"""
    load(::Type{Session}, filename)

Load a [`Session`](@ref) from disc.
"""
function load(::Type{Session}, filename::AbstractString)
    @unpack storage = BSON.load(filename)
    Session(storage)
end

"""
    dataset!(session, dataset)

Add a dataset to the session, returning the session.
"""
function dataset!(session::Session, dataset::Dataset)
    push!(session.storage.datasets, dataset)
    session
end

"""
    dataset!(session, T, args...; kwargs...)

Load a dataset and add it to the session, returning the session.
"""
function dataset!(session::Session, T::Type{<:Dataset}, args...; kwargs...)
    dataset!(session, load(T, args...; kwargs...))
end
