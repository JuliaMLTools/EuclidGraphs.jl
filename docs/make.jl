using Documenter, EuclidGraphs
makedocs(
    sitename="EuclidGraphs.jl",
    modules=[EuclidGraphs],
)
deploydocs(
    repo = "github.com/JuliaMLTools/EuclidGraphs.jl.git",
)