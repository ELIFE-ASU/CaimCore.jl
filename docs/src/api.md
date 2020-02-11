# CaimCore API

```@meta
CurrentModule = CaimCore
```

## Core

```@docs
version
```

## Sessions

Sessions provide the core organizational structure of CaimCore, connecting the various phases of
analysis, and providing persistent storage.

```@docs
Session
SessionStorage
save(::AbstractString, ::Session)
load(::Type{Session}, ::AbstractString)
```

## Datasets

```@docs
Dataset
VideoGraphicDataset
```

### Image Stacks

```@docs
ImageStack
load(::Type{ImageStack}, ::AbstractString)
load(::Type{ImageStack}, ::AbstractArray{<:AbstractString,1})
```
