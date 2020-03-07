@testset "Session" begin
    SESSION_DIR = joinpath(@__DIR__, "tmp")
    mkpath(SESSION_DIR)

    try
        let s = Session(v"1.2.3")
            @test s.version == v"1.2.3"
            @test s.datasets == Dataset[]
        end

        let path = joinpath(SESSION_DIR, tempname())
            s = Session(v"1.2.3")
            save(path, s)

            try
                t = load(Session, path)
                @test t.version == v"1.2.3"
                @test s.datasets == Dataset[]
            finally
                rm(path; force=true)
            end
        end

        let path = joinpath(SESSION_DIR, tempname())
            s = Session()
            save(path, s)

            try
                t = load(Session, path)
                @test t.version == v"0.1.0"
                @test t.datasets == Dataset[]
            finally
                rm(path; force=true)
            end
        end

        let path = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, path)

            s = Session()
            t = dataset!(s, stack)
            @test s === t
            @test s.datasets == [stack]
        end

        let path = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, path)

            s = Session()
            t = dataset!(s, ImageStack, path)
            @test s === t
            @test s.datasets == [stack]
        end

        let path = joinpath(SESSION_DIR, tempname())
            datapath = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, datapath)

            s = Session()
            dataset!(s, ImageStack, datapath)
            save(path, s)

            try
                t = load(Session, path)
                @test t.datasets == s.datasets
            finally
                rm(path; force=true)
            end
        end
    finally
        rm(SESSION_DIR; recursive=true, force=true)
    end
end
