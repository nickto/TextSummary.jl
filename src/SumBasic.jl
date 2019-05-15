module SumBasic
using TextAnalysis
import ..Sentence

export summarize

"Compute document term-matrix."
function compute_m(sentences::Array{Sentence,1})
    crps = Corpus([s.processed for s in sentences])
    update_lexicon!(crps)
    m = DocumentTermMatrix(crps)
    m = dtm(m, :dense)
    return m
end

"Compute probability distribution over words, given words that are already used."
function compute_p_word(m, used_sentences)
    p_word = vec(sum(m, dims=1) / sum(m))
    for sentence_idx in used_sentences
        p_word = p_word .^ (vec(m[sentence_idx, :]) .+ 1)
    end
    return p_word
end

"Summarize preprocessed senteces using k sentences."
function summarize(sentences::Array{Sentence,1}, k::Int=5)
    m = compute_m(sentences)

    used_sentences = []
    for i in 1:min(length(sentences), k)
        p_word = compute_p_word(m, used_sentences)
        scores = get_scores(m, p_word)

        best = pick_best(scores, p_word, m, used_sentences)
        append!(used_sentences, [best])
    end

    summary = []
    for sentence_idx in used_sentences
        append!(summary, [sentences[sentence_idx].original])
    end
    return summary
end

"Get sentence scores."
function get_scores(m, p_word)
    scores = m * vec(p_word)
    for (i, s) ∈ enumerate(scores)
        n_words = sum(m[i, :])
        if n_words == 0
            scores[i] = 0
        else
            scores[i] = s / n_words
        end
    end
    scores
end

"Pick the best sentence."
function pick_best(scores, p_word, m, used_sentences)
    ∞ = Inf
    sorted_word_indices = sortperm(p_word, rev=true)
    # Pick candidate words one by one
    for word_idx in sorted_word_indices
        # Sort sentences according to presence of this word and score
        not_contains_word = (m[:, word_idx] .== 0)
        scores_adjusted = scores
        scores_adjusted[not_contains_word] .= -∞
        sorted_sentence_indices = sortperm(scores_adjusted, rev=true)
        # Check sentences if they were already used
        for sentence_idx in sorted_sentence_indices
            if sentence_idx ∉ used_sentences
                # If not used, we found the best sentece
                return sentence_idx
            end
        end
    end
    error("No best sentence found, probably all sentences are already used in the summary.")
end

end
