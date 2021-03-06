using Test
using TextSummary

@testset "TextSummary" begin
    str = """
    Julia is a high-level general-purpose[14] dynamic programming language designed for high-performance numerical analysis and computational science.[15][16][17][18] It is also useful for low-level systems programming,[19] as a specification language,[20] with work being done on client[21] and server web use.[22]
    Distinctive aspects of Julia's design include a type system with parametric polymorphism and types in a fully dynamic programming language and multiple dispatch as its core programming paradigm. It allows concurrent, parallel and distributed computing, and direct calling of C and Fortran libraries without glue code. A just-in-time compiler that is referred to as "just-ahead-of-time"[23] in the Julia community is used.
    Julia is garbage-collected,[24] uses eager evaluation, and includes efficient libraries for floating-point calculations, linear algebra, random number generation, and regular expression matching. Many libraries are available, including some (e.g., for fast Fourier transforms) that were previously bundled with Julia and are now separate.[25]
    Tools available for Julia include IDEs; with integrated tools, e.g. a linter,[26] debugger,[27] and the Rebugger.jl package "supports repeated-execution debugging"[a] and more.[29]
    """
    sentences = preprocess(str)

    @testset "Summary length" begin
        @test length(SumBasic.summarize(sentences, 1)) == 1
        @test length(SumBasic.summarize(sentences, 5)) == 5
    end

    @testset "Sentence equality" begin
        a = preprocess(str)[1]
        b = deepcopy(preprocess(str))[1]
        @test a == b

        a = preprocess(str)
        b = deepcopy(preprocess(str))
        @test a == b

        a = preprocess(str)
        b = preprocess("_" * str)
        @test a != b
    end

    @testset "Large file" begin
        f = open("test/sample.txt")
        s = read(f, String)
        close(f)

        # This file jas "\r\n" breaks. Also, it has breaks within sentences
        s = replace(s, r"\r\n" => " ")
        # It appears that summarizer does not deal with mutiple spaces well
        s = replace(s, r"(\s){2,}" => " ")
        summary = SumBasic.summarize(preprocess(s), 5)
        @test typeof(summary) <: AbstractArray
    end
end
