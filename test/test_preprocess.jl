using Test
include("../src/Preprocess.jl")
using .Preprocess

str = "First sentence. Second sentence."
@test length(preprocess(str)) == 2

str = "First sentence. Second sentence about USA. And a third sentence."
@test length(preprocess(str)) == 3
