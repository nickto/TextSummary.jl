module TextSummary
include("types.jl")
include("SumBasic.jl")
include("Preprocess.jl")
using .SumBasic
using .Preprocess

export preprocess, Sentence, sumbasic_weights!, summarize

function summarize(sentences::Array{Sentence, 1}, n::Int=5)
    sorted = sort(sentences, by=s -> s.weight, rev=true)

    return([s.original for s in sentences[1:min(length(sentences), n)]])
end


end
