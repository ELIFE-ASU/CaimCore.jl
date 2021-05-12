using CaimCore
using CaimCore.ImageStack
using Colors, FixedPointNumbers

const STACKS_DIR = joinpath(@__DIR__, "data", "stacks")
const VIDEOS_DIR = joinpath(@__DIR__, "data", "videos")

@testset "Series" begin
    let stack = load(Frames, joinpath(STACKS_DIR, "png"))
        box = Box([1,1], [1,1])
        ts = series(stack, box)
        @test ts ≈ [RGB{N0f8}(1.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 1.0),
                    RGB{N0f8}(0.0, 1.0, 0.0),
                    RGB{N0f8}(1.0, 0.0, 0.0)]

        box = Box([1,1], [10,10])
        ts = series(stack, box)
        @test ts ≈ [RGB{N0f8}(1.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 1.0),
                    RGB{N0f8}(0.0, 1.0, 0.0),
                    RGB{N0f8}(1.0, 0.0, 0.0)]

		box = Box([5,5], [15,15])
		ts = series(stack, box)
		@test ts ≈ [RGB{N0f8}(6/11, sqrt(30)/11, 5/11),
		            RGB{N0f8}(sqrt(30)/11, 5/11, sqrt(30)/11),
					RGB{N0f8}(5/11, sqrt(30)/11, 6/11),
					RGB{N0f8}(sqrt(30)/11, 6/11, sqrt(30)/11),
					RGB{N0f8}(6/11, sqrt(30)/11, 5/11)]
		
		ff = FreeForm([[10,1], [10,10], [1,10]])
		ts = series(stack, ff)
		@test ts ≈ [RGB{N0f8}(1.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 0.0),
                    RGB{N0f8}(0.0, 0.0, 1.0),
                    RGB{N0f8}(0.0, 1.0, 0.0),
                    RGB{N0f8}(1.0, 0.0, 0.0)]
    end
end
