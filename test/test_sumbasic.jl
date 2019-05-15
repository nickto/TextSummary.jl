using Test
using TextSummary
using TextSummary.SumBasic
import TextSummary.SumBasic: get_scores, compute_p_word, pick_best

str = """
Julia is a high-level general-purpose[14] dynamic programming language designed for high-performance numerical analysis and computational science.[15][16][17][18] It is also useful for low-level systems programming,[19] as a specification language,[20] with work being done on client[21] and server web use.[22]
Distinctive aspects of Julia's design include a type system with parametric polymorphism and types in a fully dynamic programming language and multiple dispatch as its core programming paradigm. It allows concurrent, parallel and distributed computing, and direct calling of C and Fortran libraries without glue code. A just-in-time compiler that is referred to as "just-ahead-of-time"[23] in the Julia community is used.
Julia is garbage-collected,[24] uses eager evaluation, and includes efficient libraries for floating-point calculations, linear algebra, random number generation, and regular expression matching. Many libraries are available, including some (e.g., for fast Fourier transforms) that were previously bundled with Julia and are now separate.[25]
Tools available for Julia include IDEs; with integrated tools, e.g. a linter,[26] debugger,[27] and the Rebugger.jl package "supports repeated-execution debugging"[a] and more.[29]
"""

@testset "SumBasic" begin
    @testset "get_scores" begin
        m = [[0 1 0 1 0]; [0 3 4 0 1]]
        p_word = sum(m, dims=1) / sum(m)
        @test size(get_scores(m, p_word), 1) == 2
        @test get_scores(m, p_word) ≈ [0.5 / 2, 2.9 / 8]
    end

    @testset "compute_p_word" begin
        # Not used sentences
        m = [[0 1 0 1 0]; [0 3 4 0 1]]
        used_sentences = []
        p_word = vec(sum(m, dims=1) / sum(m))
        @test compute_p_word(m, used_sentences) == p_word

        used_sentences = [1]
        @test compute_p_word(m, used_sentences) ≠ p_word
        p_word[2] = p_word[2]^2
        p_word[4] = p_word[4]^2
        @test compute_p_word(m, used_sentences) == p_word
    end

    @testset "pick_best" begin
        m = [[0 1 0 1 0]; [0 3 4 0 1]]
        used_sentences = []
        p_word = compute_p_word(m, used_sentences)
        scores = get_scores(m, p_word)

        @test pick_best(scores, p_word, m, used_sentences) == 2

        used_sentences = [2]
        @test pick_best(scores, p_word, m, used_sentences) == 1

        # All sentences are already used
        used_sentences = [1 2]
        @test_throws ErrorException pick_best(scores, p_word, m, used_sentences)
    end

    @testset "summarize" begin
        sentences = preprocess(str)
        @test length(summarize(sentences, 2)) == 2
        @test length(summarize(sentences, 5)) == 5
        @test length(summarize(sentences, 999)) == 7
    end

end
