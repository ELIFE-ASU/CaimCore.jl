module CaimCore

using Defer, FileIO, Images, VideoIO

export Dataset
export VideoGraphicDataset, ImageStack, frames
export SessionStorage, Session
export save, load, dataset!

include("util.jl")
include("dataset.jl")
include("session.jl")

end
