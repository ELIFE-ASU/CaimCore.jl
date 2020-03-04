using Colors, FixedPointNumbers

@testset "Loading ImageStack" begin
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "colormix"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "sizemix"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "unknown"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "unloadable"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "nonimage"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "fmtmix"))
    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "fmtmix"), ".jpg")

    @test_throws ErrorException load(ImageStack, joinpath(@__DIR__, "data", "withdots");
                                     ignoredots=false)

    @test_throws ErrorException load(ImageStack, String[])

    let baseframe = repeat([RGB{N0f8}(1., 0., 0.) RGB{N0f8}(0., 1., 0.);
                            RGB{N0f8}(0., 0., 0.) RGB{N0f8}(0., 0., 1)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        let stack = load(ImageStack, joinpath(@__DIR__, "data", "png"))
            @test size(stack) == size(frames)
            @test CaimCore.frames(stack) == frames
            @test string(stack) == "ImageStack{RGB{Normed{UInt8,8}}}\n  size: 20×20×5"
        end

        let stack = load(ImageStack, joinpath(@__DIR__, "data", "tiff"))
            @test size(stack) == size(frames)
            @test CaimCore.frames(stack) == frames
            @test string(stack) == "ImageStack{RGB{Normed{UInt8,8}}}\n  size: 20×20×5"
        end

        let stack = load(ImageStack, joinpath(@__DIR__, "data", "withdots"))
            @test size(stack) == size(frames)
            @test CaimCore.frames(stack) == frames
            @test string(stack) == "ImageStack{RGB{Normed{UInt8,8}}}\n  size: 20×20×5"
        end

        let stack = load(ImageStack, joinpath(@__DIR__, "data", "withdots"), ".tiff";
                         ignoredots=false)
            @test size(stack) == size(frames)
            @test CaimCore.frames(stack) == frames
            @test string(stack) == "ImageStack{RGB{Normed{UInt8,8}}}\n  size: 20×20×5"
        end
    end

    let baseframe = repeat([RGB{N0f8}(1., 0., 0.) RGB{N0f8}(0., 1., 0.);
                            RGB{N0f8}(0., 0., 0.) RGB{N0f8}(0., 0., 1)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rot180, baseframe, 1)...; dims=3)

        stack = load(ImageStack, joinpath(@__DIR__, "data", "fmtmix"), ".png")
        @test size(stack) == size(frames)
        @test CaimCore.frames(stack) == frames
        @test string(stack) == "ImageStack{RGB{Normed{UInt8,8}}}\n  size: 20×20×2"
    end

    let baseframe = repeat([Gray{N0f8}(0.) Gray{N0f8}(0.33); Gray{N0f8}(1.) Gray{N0f8}(0.66)];
                           inner=(10,10))
        frames = cat(CaimCore.scanl(rotr90, baseframe, 4)...; dims=3)

        stack = load(ImageStack, joinpath(@__DIR__, "data", "grayscale"))
        @test size(stack) == size(frames)
        @test CaimCore.frames(stack) == frames
        @test string(stack) == "ImageStack{Gray{Normed{UInt8,8}}}\n  size: 20×20×5"
    end
end
