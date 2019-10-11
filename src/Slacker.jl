module Slacker
using HTTP, JSON

greet() = print("Hello World!")

include("slackbot.jl")

export SlackConfig
export addConfig

end # module
