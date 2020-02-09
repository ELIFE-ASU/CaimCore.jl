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
end
SessionStorage() = SessionStorage(version())

"""
    Session(path[, storage])

A structure for storing session information for a CaimCore analysis.
"""
mutable struct Session
    path::AbstractString
    storage::SessionStorage
end
Session(filename::AbstractString) = Session(filename, SessionStorage())

"""
    save(filename, session)

Save the persistent component of a [`Session`](@ref) to a disc.
"""
function save(filename::AbstractString, session::Session)
    bson(session.path, Dict(:storage => session.storage))
end

"""
    load(::Type{Session}, filename)

Load a [`Session`](@ref) from disc.
"""
function load(::Type{Session}, filename::AbstractString)
    @unpack storage = BSON.load(filename)
    Session(filename, storage)
end
