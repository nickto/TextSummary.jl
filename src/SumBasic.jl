module SumBasic
include("Preprocess.jl")
using .Preprocess: ProcessedSentence

export sentence_weights


"Compute weights of each sentence."
function sentence_weights(sentences::Array{ProcessedSentence,1}, tfidf::Bool=true)
    println("Hi!")
    if tfidf

    end

end

end
