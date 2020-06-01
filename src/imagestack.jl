module ImageStack

using Defer, FileIO, Images, LinearAlgebra, VideoIO

export Frames, frames, load
export Point, Box, Circle
export width, height, area, box

include("imagestack/dataset.jl")
include("imagestack/features.jl")

end
