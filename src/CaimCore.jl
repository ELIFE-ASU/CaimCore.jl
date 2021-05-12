module CaimCore

export Dataset
export VideoGraphicDataset, ImageStack, frames
export SessionStorage, Session
export save, load, dataset!
export Accumulator, SimpleAccumulator
export intype, outtype, add!, reset!, summarize
export Feature
export series

include("util.jl")
include("dataset.jl")
include("session.jl")
include("accumulator.jl")
include("feature.jl")

include("imagestack.jl")

end
