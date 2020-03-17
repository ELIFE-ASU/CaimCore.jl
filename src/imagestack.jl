module ImageStack

using Defer, FileIO, Images, VideoIO

export Frames, frames, load

include("imagestack/dataset.jl")

end
