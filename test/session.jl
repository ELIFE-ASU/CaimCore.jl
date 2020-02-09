@testset "Session" begin
    SESSION_DIR = joinpath(@__DIR__, "tmp")
    mkpath(SESSION_DIR)

    try
        let s = Session("/foo/bar", SessionStorage(v"1.2.3"))
            @test s.path == "/foo/bar"
            @test s.storage.version == v"1.2.3"
        end

        let path = joinpath(SESSION_DIR, tempname())
            s = Session(path, SessionStorage(v"1.2.3"))
            save(path, s)

            try
                t = load(Session, path)
                @test t.path == path
                @test t.storage.version == v"1.2.3"
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
            finally
                rm(path; force=true)
            end
        end
    finally
        rm(SESSION_DIR; recursive=true, force=true)
    end
end
