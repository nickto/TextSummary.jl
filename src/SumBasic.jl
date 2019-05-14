module SumBasic
using TextAnalysis
import ..Sentence

export score!, score

"Compute scores of each sentence, using SumBasic algorithm."
function score!(sentences::Array{Sentence,1}, tfidf::Bool=false)
    crps = Corpus([s.processed for s in sentences])
    update_lexicon!(crps)
    m = DocumentTermMatrix(crps)
    m = dtm(m, :dense)

    for i in 1:size(m, 1)
        sentences[i].weight = sum(m[i, :])
    end
    return nothing
end

"Not in-place version of score."
function score(sentences::Array{Sentence,1}, tfidf::Bool=false)
    sentences = deepcopy(sentences)
    score!(sentences, tfidf)
    return sentences
end


end
