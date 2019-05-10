using TextSummary
using Test

include("test_preprocess.jl")

@test TextSummary.greet() == "Hello world"


str = "Revise.jl may help you keep your Julia sessions running longer, reducing the need to restart when you make changes to code. With Revise, you can be in the middle of a session and then edit source code, update packages, switch git branches, and/or stash/unstash code; typically, the changes will be incorporated into the very next command you issue from the REPL. This can save you the overhead of restarting, loading packages, and waiting for code to JIT-compile."
typeof(str)
TextSummary.Preprocess.preprocess(str)
