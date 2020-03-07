"""
    VIDEO_EXTS

Supported video extensions.
"""
const VIDEO_EXTS = begin
    raw = split.(VideoIO.FFMPEG.exe("-formats", collect=true)[5:end], " ")
    fields = filter.(!isempty, raw)
    map(f -> f[2], fields)
end

"""
    ImageStack <: VideoGraphicDataset
    ImageStack(frames::Array{C,3}) where {C <: Colorant}
    ImageStack(frames::AbstractVector{Matrix{C}} where {C <: Colorant}

An image stack consists of a collection of 2-D images, running in time.
"""
mutable struct ImageStack{C <: Colorant} <: VideoGraphicDataset
    frames::Array{C,3}
end

function ImageStack(frames::AbstractVector{Matrix{C}}) where {C <: Colorant}
    if anydifferent(size.(frames))
        error("frames must all have the same dimension")
    end
    ImageStack{C}(cat(frames...; dims=3))
end

function Base.show(io::IO, stack::ImageStack)
    println(io, typeof(stack))
    print(io, "  size: ", join(string.(size(stack)), "×"))
end

frames(stack::ImageStack) = stack.frames
Base.size(stack::ImageStack) = size(frames(stack))

"""
    load(::Type{ImageStack}, path; ext=nothing, ignoredots=true)

Load all frames from a video or image files from a directory into an
`ImageStack`.  If a directory is provided, only files with extention `ext` will
be loaded. If `isnothing(ext)`, all files will be load. Files whose name begins
with a `.` will be ignored if `ignoredots` is `true`.

When loading from image files, the filenames are sorted lexicographically. The
files must all have the same size, file extention and color space, e.g.
`RGB{N0f8}`, `Gray{N0f8}`, etc..

```julia
julia> load(ImageStack, "fromtiffs.avi")
ImageStack{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}}}
  size: 20×20×5
```

```julia
julia> readdir()
6-element Array{String,1}:
 ".DS_Store"
 "000001.tiff"
 "000002.tiff"
 "000003.tiff"
 "000004.tiff"
 "000005.tiff"

julia> load(ImageStack, ".")
ImageStack{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}}}
  size: 20×20×5

julia> load(ImageStack, "."; ignoredots=false)
ERROR: files must all have the same extension; got ["", ".tiff"]
[...]
```

You can filter files by extension.
```julia
julia> load(ImageStack, ".")
ERROR: files must all have the same extension; got [".png", ".tiff"]
[...]

julia> load(ImageStack, ".", ".tiff")
ImageStack{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}}}
  size: 20×20×2
```
"""
function load(::Type{ImageStack}, path::AbstractString; ext::Union{Nothing,AbstractString}=nothing,
              ignoredots=true)
    if isdir(path)
        files = readdir(path)
        ignoredots && filter!(f -> f[1] != '.', files)
        !isnothing(ext) && filter!(f -> last(splitext(f)) == ext, files)
        if isempty(files)
            error("no files$(isnothing(ext) ? " " : "with extension \"$ext\" ")found in \"$path\"")
        end
        load(ImageStack, sort!(joinpath.(path, files)))
    elseif isfile(path)
        if lowercase(replace(last(splitext(path)), "." => "")) ∉ VIDEO_EXTS
            error("file extension is not a supported video extension, see CaimCore.VIDEO_EXTS")
        end
        ImageStack(loadvideo(path))
    else
        error("path is neither a directory nor a file")
    end
end

"""
    load(::Type{ImageStack}, files)

Load image files into an image stack in the order they are provided.

The files must all have the same size, file extention and color space, e.g.
`RGB{N0f8}`, `Gray{N0f8}`, etc..

```julia
julia> load(ImageStack, ["000001.tiff", "000002.tiff"])
ImageStack{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}}}
  size: 20×20×2
```
"""
function load(::Type{ImageStack}, files::AbstractVector{<:AbstractString})
    if isempty(files)
        error("no files provided")
    end

    exts = unique(map(last ∘ splitext, files))
    if length(exts) != 1
        error("files must all have the same extension; got ", exts)
    end

    frames = loadstack(files)
    if anydifferent(typeof.(frames))
        error("files must all have the same color space")
    end

    try
        ImageStack(frames)
    catch e
        if isa(e, MethodError)
            error("files must all be images")
        else
            rethrow(e)
        end
    end
end

function loadstack(files::AbstractVector{<:AbstractString})
    try
        FileIO.load.(files)
    catch e
        if isa(e, FileIO.UnknownFormat)
            error("unrecognized file format found")
        else
            rethrow(e)
        end
    end
end

function loadvideo(path::AbstractString)
    video = try
        VideoIO.openvideo(path)
    catch
        error("file does not appear to be a properly formatted video")
    end
    @defer close(video)
    frames = [Array(read(video))]
    while !eof(video)
        push!(frames, Array(read(video)))
    end
    frames
end

Base.:(==)(a::ImageStack, b::ImageStack) = frames(a) == frames(b)
