module TextSummary
include("SumBasic.jl")
include("Preprocess.jl")
using .SumBasic
using .Preprocess

export preprocess, Sentence

struct Sentence
    weight::AbstractFloat
    original::String
    processed::Preprocess.StringDocument
end


end
