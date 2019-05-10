module Preprocess
using TextAnalysis
using WordTokenizers
using Languages

export preprocess

"Remove all symbols identified as Unicode general category Punctuation."
function remove_utf_punctuation(str::String)
    join([letter for letter in str if !ispunct(letter)], "")
end

"When applied to Documents, remove all symbols identified as Unicode general category Punctuation inplace.."
function remove_utf_punctuation!(str::AbstractDocument)
    str.text = remove_utf_punctuation(str.text)
    nothing
end

"When applied to strings, removes all symbols identified as Unicode general category Punctuation"
function remove_utf_punctuation(str::StringDocument)
    remove_utf_punctuation(str.text)
end

"Infer the language of a StringDocument."
function detect_language(sd::StringDocument, confidence_threshold::AbstractFloat=0.9)
    detector = LanguageDetector()
    lang, script, confidence = detector(sd.text)
    if confidence < confidence_threshold
        @warn "Could not infer language with reasonable confidence ($confidence)."
    end
    return lang, script, confidence
end

"Infer and set the language of a StringDocument."
function set_language!(sd::StringDocument, confidence_threshold::AbstractFloat=0.9)
    lang, _, _ = detect_language(sd, confidence_threshold)
    language!(sd, lang)
    lang
end

function preprocess(str::String)
    sd = StringDocument(str)
    prepare!(sd, strip_corrupt_utf8)
    prepare!(sd, strip_html_tags)

    lang = set_language!(sd)

    # Split into sentences
    sentences = split_sentences(text(sd))

    # Remove empty sentences
    sentences = [sentence for sentence in sentences if sentence != ""]

    # Convert each sentence to StringDocument, but also keep the original
    sentences = [
        Dict{String, Any}(
            "original" => String(sentence),
            "processed" => StringDocument(String(sentence))
        )
        for sentence in sentences
    ]

    # Preprocess
    for sentence in sentences
        language!(sentence["processed"], lang)
        # Remove ё from russian
        if lang == Languages.Russian()
            sentence["processed"].text = replace(sentence["processed"].text, "ё" => "е")
        end

        remove_case!(sentence["processed"])
        prepare!(sentence["processed"], strip_numbers)
        prepare!(sentence["processed"], strip_punctuation)

        # Above function removes only a small subset of punctuation
        remove_utf_punctuation!(sentence["processed"])
        prepare!(sentence["processed"], strip_stopwords)
        prepare!(sentence["processed"], strip_pronouns)
        prepare!(sentence["processed"], strip_frequent_terms)
        prepare!(sentence["processed"], strip_whitespace)
        prepare!(sentence["processed"], stem_words)
    end

    return sentences
end

end