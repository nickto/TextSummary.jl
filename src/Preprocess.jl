module Preprocess
using TextAnalysis
using WordTokenizers
using Languages

export remove_utf_punctuation, remove_utf_punctuation!, preprocess

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

function preprocess(str::String)
    sd = StringDocument(str)
    prepare!(sd, strip_corrupt_utf8)
    prepare!(sd, strip_html_tags)

    # Detect language
    detector = LanguageDetector()
    lang, _, confidence = detector(sd.text)
    if confidence < 0.9
        @warn "Could not infer language with reasonable confidence ($confidence)."
    end
    language!(sd, lang)

    # Keep only line breaks between paragraphs
    # replace!(sd.text, r"\r\n(?!\r\n)"=>"")
    sd.text = replace(sd.text, r"\r\n\r\n"=>"\n")
    sd.text = replace(sd.text, r"\r\n"=>" ")
    sd.text = replace(sd.text, r"\n\n"=>"\n")

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
