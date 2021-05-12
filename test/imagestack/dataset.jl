using CaimCore.ImageStack
using Colors, FixedPointNumbers

const STACKS_DIR = joinpath(@__DIR__, "data", "stacks")
const VIDEOS_DIR = joinpath(@__DIR__, "data", "videos")

@testset "Loading Frames Fails" begin
    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "colormix"))
    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "sizemix"))
    #  @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "unknown"))
    #  @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "unloadable"))
    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "nonimage"))
    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "fmtmix"))
    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "fmtmix"); ext=".jpg")

    @test_throws ErrorException load(Frames, joinpath(STACKS_DIR, "withdots");
                                     ignoredots=false)

    @test_throws ErrorException load(Frames, String[])

    @test_throws ErrorException load(Frames, joinpath(VIDEOS_DIR, "empty.avi"))
    @test_throws ErrorException load(Frames, joinpath(VIDEOS_DIR, "garbage.avi"))
    @test_throws ErrorException load(Frames, joinpath(VIDEOS_DIR, "nonvideo.txt"))
end

@testset "Loading Frames from a Directory" begin
    let baseframe = repeat([RGB{N0f8}(1., 0., 0.) RGB{N0f8}(0., 1., 0.);
                            RGB{N0f8}(0., 0., 0.) RGB{N0f8}(0., 0., 1)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        let stack = load(Frames, joinpath(STACKS_DIR, "png"))
            @test size(stack) == size(frames)
            @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(STACKS_DIR, "tiff"))
            @test size(stack) == size(frames)
            @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(STACKS_DIR, "withdots"))
            @test size(stack) == size(frames)
            @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(STACKS_DIR, "withdots"); ext=".tiff",
                         ignoredots=false)
            @test size(stack) == size(frames)
            @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end
    end

    let baseframe = repeat([RGB{N0f8}(1., 0., 0.) RGB{N0f8}(0., 1., 0.);
                            RGB{N0f8}(0., 0., 0.) RGB{N0f8}(0., 0., 1)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rot180, baseframe, 1)...; dims=3)

        stack = load(Frames, joinpath(STACKS_DIR, "fmtmix"); ext=".png")
        @test size(stack) == size(frames)
        @test ImageStack.frames(stack) == frames
        @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×2"
    end

    let baseframe = repeat([Gray{N0f8}(0.) Gray{N0f8}(0.33); Gray{N0f8}(1.) Gray{N0f8}(0.66)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        stack = load(Frames, joinpath(STACKS_DIR, "grayscale"))
        @test size(stack) == size(frames)
        @test ImageStack.frames(stack) == frames
        @test string(stack) == "Frames{Gray{N0f8}}\n  size: 20×20×5"
    end
end
#
@testset "Loading Frames from Video File" begin
    let baseframe = repeat([RGB{N0f8}(1., 0., 0.) RGB{N0f8}(0., 1., 0.);
                            RGB{N0f8}(0., 0., 0.) RGB{N0f8}(0., 0., 1)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        let stack = load(Frames, joinpath(VIDEOS_DIR, "png.avi"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "png.mov"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "png.mp4"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "tiff.avi"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "tiff.mov"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "tiff.mp4"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end
    end

    let baseframe = repeat([Gray{N0f8}(0.) Gray{N0f8}(0.33); Gray{N0f8}(1.) Gray{N0f8}(0.66)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        let stack = load(Frames, joinpath(VIDEOS_DIR, "grayscale.avi"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "grayscale.mov"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end

        let stack = load(Frames, joinpath(VIDEOS_DIR, "grayscale.mp4"))
            @test size(stack) == size(frames)
            #  @test ImageStack.frames(stack) == frames
            @test string(stack) == "Frames{RGB{N0f8}}\n  size: 20×20×5"
        end
    end
end
