using Test
using TextSummary
using TextSummary.SumBasic

@testset "SumBasic" begin
    str = """
    Julia is a high-level general-purpose[14] dynamic programming language designed for high-performance numerical analysis and computational science.[15][16][17][18] It is also useful for low-level systems programming,[19] as a specification language,[20] with work being done on client[21] and server web use.[22]
    Distinctive aspects of Julia's design include a type system with parametric polymorphism and types in a fully dynamic programming language and multiple dispatch as its core programming paradigm. It allows concurrent, parallel and distributed computing, and direct calling of C and Fortran libraries without glue code. A just-in-time compiler that is referred to as "just-ahead-of-time"[23] in the Julia community is used.
    Julia is garbage-collected,[24] uses eager evaluation, and includes efficient libraries for floating-point calculations, linear algebra, random number generation, and regular expression matching. Many libraries are available, including some (e.g., for fast Fourier transforms) that were previously bundled with Julia and are now separate.[25]
    Tools available for Julia include IDEs; with integrated tools, e.g. a linter,[26] debugger,[27] and the Rebugger.jl package "supports repeated-execution debugging"[a] and more.[29]
    """

    @testset "Non-zero weights" begin
        sentences = preprocess(str)

        @test all([s.weight > 0.0 for s in score(sentences)])
        @test all([s.weight > 0.0 for s in score(sentences)])
    end

    @testset "Side effects" begin
        sentences = preprocess(str)

        # Not in-place version should not affect the passes parameter
        scored_sentences = score(sentences)
        @test scored_sentences != sentences

        scored_sentences_inplace = score!(sentences)
        # Inplace version should return nothing
        @test scored_sentences_inplace == nothing
        # Sentences modified in-place should be the same as not in-place
        @test scored_sentences == sentences
    end
end
