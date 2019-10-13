using Documenter, Slacker

makedocs(;
    modules=[Slacker],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Tutorial" => "tutorial.md",
    ],
    repo="https://github.com/Sumidu/slacker.jl/blob/{commit}{path}#L{line}",
    sitename="slacker.jl",
    authors="André Calero Valdez",
    format = Documenter.HTML(assets = []),
)

deploydocs(;
    repo="github.com/Sumidu/slacker.jl",
)
