using Documenter
using CaimCore

DocMeta.setdocmeta!(CaimCore, :DocTestSetup, :(using CaimCore); recursive=true)
makedocs(
    sitename = "CaimCore",
    format = Documenter.HTML(),
    modules = [CaimCore],
    authors = "Douglas G. Moore",
    pages = Any[
        "Home" => "index.md",
        "API Reference" => "api.md",
    ]
)

deploydocs(
    repo = "github.com/dglmoore/CaimCore.jl.git"
)
