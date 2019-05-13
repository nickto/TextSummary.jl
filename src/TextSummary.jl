module TextSummary
include("types.jl")
include("SumBasic.jl")
include("Preprocess.jl")
using .SumBasic
using .Preprocess

export preprocess, Sentence, weight_sentences!, summarize

function summarize(Array{Sentence, 1})

end


end
