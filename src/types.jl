using TextAnalysis: StringDocument

mutable struct Sentence
    weight::AbstractFloat
    original::String
    processed::StringDocument
end
