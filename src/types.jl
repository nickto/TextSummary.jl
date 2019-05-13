using TextAnalysis: StringDocument

mutable struct Sentence
    weight::AbstractFloat
    original::String
    processed::StringDocument
end

Base.:(==)(a::Sentence, b::Sentence) = (
    (a.weight == b.weight) &
    (a.original == b.original) &
    (
        (a.processed.text == b.processed.text) &
        (a.processed.metadata.author == b.processed.metadata.author) &
        (a.processed.metadata.language == b.processed.metadata.language) &
        (a.processed.metadata.timestamp == b.processed.metadata.timestamp) &
        (a.processed.metadata.title == b.processed.metadata.title)
    )
)
