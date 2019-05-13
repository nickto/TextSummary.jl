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

summary = summarize(sumbasic_weights!(preprocess(text)))
```
