module SumBasic
using TextAnalysis
import ..Sentence

export sumbasic_weights!

"Compute weights of each sentence, using SumBasic algorithm."
function sumbasic_weights!(sentences::Array{Sentence,1}, tfidf::Bool=true)
    crps = Corpus([s.processed for s in sentences])
    update_lexicon!(crps)
    m = DocumentTermMatrix(crps)

    if tfidf
        m = tf_idf(m)
    else
        m = dtm(m, :dense)
    end

    m = tf_idf(m)
    for i in 1:size(m, 1)
        sentences[i].weight = sum(m[i, :])
    end
    return sentences
end

end
