using Test
using TextSummary: Preprocess

@testset "Sentence splitting" begin
    str = "This is a sentence about the famous writer A. A. Adamson."
    @test length(preprocess(str)) == 1

    str = "This is the first sentence. Second sentence."
    @test length(preprocess(str)) == 2

    str = "This is the first sentence. Second sentence about EU. And a third sentence."
    @test length(preprocess(str)) == 3
end
