module TextSummary
include("types.jl")
include("SumBasic.jl")
include("Preprocess.jl")
import .SumBasic
using .Preprocess

export preprocess, Sentence, summarize
export SumBasic

function summarize(sentences::Array{Sentence, 1}, k, scorer::Function=SumBasic.score)
    sorted = sort(scorer(sentences), by=s -> s.weight, rev=true)
    return([s.original for s in sentences[1:min(length(sentences), k)]])
end


end
