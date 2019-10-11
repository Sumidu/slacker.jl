using Documenter, Slacker

makedocs(;
    modules=[Slacker],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/sumidu/Slacker.jl/blob/{commit}{path}#L{line}",
    sitename="Slacker.jl",
    authors="André Calero Valdez",
    assets=String[],
)

deploydocs(;
    repo="github.com/sumidu/Slacker.jl",
)
