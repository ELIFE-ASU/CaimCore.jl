using Colors

"""
    Dataset

A supertype for all loadable datasets
"""
abstract type Dataset end


"""
    VideoGraphicDataset{C <: Color} <: Dataset

A supertype for all videographic datasets
"""
abstract type VideoGraphicDataset{C <: Color} <: Dataset end
