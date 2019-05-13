module Preprocess
import ..Sentence
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
        @warn "Could not infer language with reasonable confidence ($(repr(lang)), $confidence)."
    end
    return lang, script, confidence
end

"Infer and set the language of a StringDocument."
function set_language!(sd::StringDocument, confidence_threshold::AbstractFloat=0.9)
    lang, _, _ = detect_language(sd, confidence_threshold)
    language!(sd, lang)
    lang
end

"Preprocess a single sentence."
function preprocess_sentence!(sd::StringDocument, lang::Language)
    language!(sd, lang)
    # Remove ё from russian
    if sd.metadata.language == Languages.Russian()
        sd.text = replace(sd.text, "ё" => "е")
    end

    remove_case!(sd)
    prepare!(sd, strip_numbers)
    prepare!(sd, strip_punctuation)

    # Above function removes only a small subset of punctuation
    remove_utf_punctuation!(sd)
    # prepare!(sd, strip_stopwords)
    # prepare!(sd, strip_pronouns)
    # prepare!(sd, strip_frequent_terms)
    # prepare!(sd, strip_whitespace)
    # prepare!(sd, stem_words)
end

"""
    preprocess(str)

Preprocess a string:
1. Strip HTML tags
2. Strip Corrupt UTF characters
3. Infer language
4. Split into sentences
5. Lowercase
6. Remove numbers
7. Remove punctuation
8. Remove stopwords
9. Remove pronouns
10. Remove frequent terms
11. Strip whitespace
12. Stem

# Examples
```julia-repl
julia> preprocess("This is the first sentence. Second sentence.")
2-element Array{Sentence,1}:
 Sentence("This is the first sentence.", TextAnalysis.StringDocument{String}("sentenc", TextAnalysis.DocumentMetadata(Languages.English(), "Untitled Document", "Unknown Author", "Unknown Time")))
 Sentence("Second sentence.", TextAnalysis.StringDocument{String}("sentenc", TextAnalysis.DocumentMetadata(Languages.English(), "Untitled Document", "Unknown Author", "Unknown Time")))
```
"""
function preprocess(str::String)::Array{Sentence,1}
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
        Sentence(
            0.0,
            String(sentence),
            StringDocument(String(sentence))
        ) for sentence in sentences
    ]

    # Preprocess
    for sentence in sentences
        preprocess_sentence!(sentence.processed, lang)
    end
    return sentences
end

end
