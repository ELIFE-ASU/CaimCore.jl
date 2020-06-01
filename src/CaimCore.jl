module CaimCore

export Dataset
export VideoGraphicDataset, ImageStack, frames
export SessionStorage, Session
export save, load, dataset!
export Feature

include("util.jl")
include("dataset.jl")
include("session.jl")
include("feature.jl")

include("imagestack.jl")

end
