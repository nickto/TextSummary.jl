# TextSummary.jl
Automatic text summarisation.

## Implemented algorithms

- SumBasic

## Usage
```julia
using TextSummary

text = """
Some long text. We want to summarise this text.
It consists of sentences and paragraphs.
But it does not matter because it is eventually split into sentences.
Just make sure that there are no line separators within a sentence.
"""

summary = summarize(sentences=preprocess(text), k=5, scorer=SumBasic.score)
```

## TODO

- [X] ~~Check why TF-IDF does not work and whether there is way to make it work:~~ Does not make sense for summarization of a single document.
- [X] Normalize frequency by the sentence length
- [X] If you just sum frequencies, it looks only at a single sentence which is obviously wrong.
