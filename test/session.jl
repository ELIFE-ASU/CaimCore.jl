@testset "Session" begin
    SESSION_DIR = joinpath(@__DIR__, "tmp")
    mkpath(SESSION_DIR)

    try
        let s = Session("/foo/bar", SessionStorage(v"1.2.3"))
            @test s.path == "/foo/bar"
            @test s.storage.version == v"1.2.3"
            @test s.storage.datasets == Dataset[]
        end

        let path = joinpath(SESSION_DIR, tempname())
            s = Session(path, SessionStorage(v"1.2.3"))
            save(path, s)

            try
                t = load(Session, path)
                @test t.path == path
                @test t.storage.version == v"1.2.3"
                @test s.storage.datasets == Dataset[]
            finally
                rm(path; force=true)
            end
        end

        let path = joinpath(SESSION_DIR, tempname())
            s = Session(path)
            save(path, s)

            try
                t = load(Session, path)
                @test t.path == path
                @test t.storage.version == v"0.1.0"
                @test s.storage.datasets == Dataset[]
            finally
                rm(path; force=true)
            end
        end

        let path = joinpath(SESSION_DIR, tempname())
            data = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, data)

            s = Session(path)
            t = dataset!(s, stack)
            @test s === t
            @test s.storage.datasets == [stack]
        end

        let path = joinpath(SESSION_DIR, tempname())
            data = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, data)

            s = Session(path)
            t = dataset!(s, ImageStack, data)
            @test s === t
            @test s.storage.datasets == [stack]
        end
        let path = joinpath(SESSION_DIR, tempname())
            data = joinpath(@__DIR__, "dataset", "data", "tiff")
            stack = load(ImageStack, data)

            s = Session(path)
            dataset!(s, ImageStack, data)
            save(path, s)

            try
                t = load(Session, path)
                @test t.storage.datasets == t.storage.datasets
            finally
                rm(path; force=true)
            end
        end
    finally
        rm(SESSION_DIR; recursive=true, force=true)
    end
end
