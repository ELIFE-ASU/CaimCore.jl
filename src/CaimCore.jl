module CaimCore

using FileIO, Images

export Dataset
export VideoGraphicDataset, ImageStack
export SessionStorage, Session
export save, load

include("util.jl")
include("dataset.jl")
include("session.jl")

end
