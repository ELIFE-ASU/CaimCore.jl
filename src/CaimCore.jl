module CaimCore

export Dataset
export VideoGraphicDataset, ImageStack, frames
export SessionStorage, Session
export save, load, dataset!

include("util.jl")
include("dataset.jl")
include("session.jl")

include("imagestack.jl")

end
