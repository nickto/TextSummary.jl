module SumBasic
using TextAnalysis
import ..Sentence

export score!, score

"Compute scores of each sentence, using SumBasic algorithm."
function score!(sentences::Array{Sentence,1})
    crps = Corpus([s.processed for s in sentences])
    update_lexicon!(crps)
    m = DocumentTermMatrix(crps)
    m = dtm(m, :dense)

    word_probabilities = sum(m, dims=1) / sum(m)
    for i in 1:size(m, 1)
        sentence_cardinality = sum(m[i, :])
        if sentence_cardinality > 0.0
            sentences[i].weight = sum(transpose(m[i, :]) .* word_probabilities) / sentence_cardinality
        else
            sentences[i].weight = 0.0
        end
    end
    return nothing
end

"Not in-place version of score."
function score(sentences::Array{Sentence,1})
    sentences = deepcopy(sentences)
    score!(sentences)
    return sentences
end


end
