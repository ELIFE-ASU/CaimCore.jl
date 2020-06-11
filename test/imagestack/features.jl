using CaimCore.ImageStack

@testset "Box" begin
    let box = Box([0, 0], [0, 0])
        @test box.tl == [0, 0]
        @test box.br == [0, 0]
        @test width(box) == 1
        @test height(box) == 1
        @test area(box) == 1
        @test Set(box) == Set([[0, 0]])
    end

    let box = Box([0, 0], [0, 1])
        @test box.tl == [0, 0]
        @test box.br == [0, 1]
        @test width(box) == 1
        @test height(box) == 2
        @test area(box) == 2
        @test Set(box) == Set([[0, 0], [0, 1]])
    end

    let box = Box([0, 0], [1, 0])
        @test box.tl == [0, 0]
        @test box.br == [1, 0]
        @test width(box) == 2
        @test height(box) == 1
        @test area(box) == 2
        @test Set(box) == Set([[0, 0], [1, 0]])
    end

    let box = Box([0, 1], [-1, 3])
        @test box.tl == [-1, 1]
        @test box.br == [0, 3]
        @test width(box) == 2
        @test height(box) == 3
        @test area(box) == 6
        @test Set(box) == Set([[-1, 1], [0, 1],
                               [-1, 2], [0, 2],
                               [-1, 3], [0, 3]])
    end

    let box = Box([-1, -1], [3, 3])
        @test [-1,-1] in box
        @test [ 0,-1] in box
        @test [ 3,-1] in box
        @test [-1, 0] in box
        @test [-1, 3] in box
        @test [ 1, 1] in box

        @test !([-2, 0] in box)
        @test !([ 4, 0] in box)
        @test !([ 0,-2] in box)
        @test !([ 0, 4] in box)
    end
end

@testset "Circle" begin
    @test_throws ArgumentError Circle([0], 2.)
    @test_throws ArgumentError Circle([ 0, 0, 0], 2.)

    let circle = Circle([ 0, 0], [ 0, 0])
        @test circle.center == [ 0, 0]
        @test circle.radius ≈ 0.
        @test circle.radius² ≈ 0.
        @test box(circle) == Box([ 0, 0], [ 0, 0])
        @test Set(circle) == Set([[ 0, 0]])
    end

    let circle = Circle([ 0, 0], [ 1, 0])
        @test circle.center == [ 0, 0]
        @test circle.radius ≈ 1.
        @test circle.radius² ≈ 1.
        @test box(circle) == Box([-1,-1], [ 1, 1])
        @test Set(circle) == Set([[ 0,-1],
                                  [-1, 0], [ 0, 0], [ 1, 0],
                                  [ 0, 1]])
    end

    let circle = Circle([ 0, 0], [ 2, 0])
        @test circle.center == [ 0, 0]
        @test circle.radius ≈ 2.
        @test circle.radius² ≈ 4.
        @test box(circle) == Box([-2,-2], [ 2, 2])
        @test Set(circle) == Set([[ 0,-2],
                                  [-1,-1], [ 0,-1], [ 1,-1],
                                  [-2, 0], [-1, 0], [ 0, 0], [ 1, 0], [ 2, 0],
                                  [-1, 1], [ 0, 1], [ 1, 1],
                                  [ 0, 2]])
    end

    let circle = Circle([ 0, 0], 0)
        @test circle.center == [ 0, 0]
        @test circle.radius ≈ 0.
        @test circle.radius² ≈ 0.
        @test box(circle) == Box([ 0, 0], [ 0, 0])
        @test Set(circle) == Set([[ 0, 0]])
    end

    let circle = Circle([ 1, 1], 1.)
        @test circle.center == [ 1, 1]
        @test circle.radius ≈ 1.
        @test circle.radius² ≈ 1.
        @test box(circle) == Box([ 0, 0], [ 2, 2])
        @test Set(circle) == Set([[ 1, 0],
                                  [ 0, 1], [ 1, 1], [ 2, 1],
                                  [ 1, 2]])
    end

    let circle = Circle([ 0, 0], 1)
        @test [ 0,-1] in circle
        @test [-1, 0] in circle
        @test [ 0, 0] in circle
        @test [ 1, 0] in circle
        @test [ 0, 1] in circle

        @test !([-1,-1] in circle)
        @test !([ 1,-1] in circle)
        @test !([-1, 1] in circle)
        @test !([ 1, 1] in circle)
    end
end

@testset "FreeForm" begin
    @test_throws ArgumentError FreeForm(Point[])
    @test_throws ArgumentError FreeForm([[0, 1, 2]])
    @test_throws ArgumentError FreeForm([[0, 1], [1, 2, 3]])

    let ff = FreeForm([[ 0, 0], [ 1, 0], [ 1, 1], [ 0, 1]])
        @test ff.boundary == [[ 0, 0], [ 1, 0], [ 1, 1], [ 0, 1]]
        @test box(ff) == Box([ 0, 0], [ 1, 1])
        @test Set(ff) == Set(box(ff))
    end

    let ff = FreeForm([[ 0, 0], [ 2, 0], [ 2, 2], [ 0, 2]])
        @test ff.boundary == [[ 0, 0], [ 2, 0], [ 2, 2], [ 0, 2]]
        @test box(ff) == Box([ 0, 0], [ 2, 2])
        @test Set(ff) == Set(box(ff))
    end

    let ff = FreeForm([[ 0, 0], [ 4, 0], [ 0, 4], [ 4, 4]])
        @test ff.boundary == [[ 0, 0], [ 4, 0], [ 0, 4], [ 4, 4]]
        @test box(ff) == Box([ 0, 0], [ 4, 4])
        @test Set(ff) == Set([[ 0, 0], [ 1, 0], [ 2, 0], [ 3, 0], [ 4, 0],
                              [ 1, 1], [ 2, 1], [ 3, 1],
                              [ 2, 2],
                              [ 1, 3], [ 2, 3], [ 3, 3],
                              [ 0, 4], [ 1, 4], [ 2, 4], [ 3, 4], [ 4, 4]])
    end

    let ff = FreeForm([[ 0, 0], [ 0, 4], [ 4, 0], [ 4, 4]])
        @test ff.boundary == [[ 0, 0], [ 0, 4], [ 4, 0], [ 4, 4]]
        @test box(ff) == Box([ 0, 0], [ 4, 4])
        @test Set(ff) == Set([[ 0, 0], [ 0, 1], [ 0, 2], [ 0, 3], [ 0, 4],
                              [ 1, 1], [ 1, 2], [ 1, 3],
                              [ 2, 2],
                              [ 3, 1], [ 3, 2], [ 3, 3],
                              [ 4, 0], [ 4, 1], [ 4, 2], [ 4, 3], [4, 4]])
    end

    let ff = FreeForm([[ 0, 0], [ 2, 0], [ 2, 2], [ 0, 2]])
        @testset for p in ff.boundary
            @test p in ff
        end

        @testset for p in [[ 0, 1], [ 1, 0], [ 2, 1], [ 1, 2]]
            @test p in ff
        end

        @test !([-1, 0] in ff)
        @test !([ 0,-1] in ff)
        @test !([ 3, 3] in ff)
    end

    let ff = FreeForm([[ 0, 0], [ 4, 0], [ 0, 4], [ 4, 4]])
        @testset for p in ff.boundary
            @test p in ff
        end

        @test [ 1, 0] in ff
        @test [ 2, 0] in ff
        @test [ 3, 0] in ff
        @test [ 1, 1] in ff
        @test [ 2, 1] in ff
        @test [ 3, 1] in ff
        @test [ 2, 2] in ff
        @test [ 1, 3] in ff
        @test [ 2, 3] in ff
        @test [ 3, 3] in ff
        @test [ 1, 4] in ff
        @test [ 2, 4] in ff
        @test [ 3, 4] in ff
    end
end
