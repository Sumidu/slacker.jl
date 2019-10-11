module Slacker
using HTTP, JSON


include("slackbot.jl")

export SlackConfig, addConfig, loadConfig, sendSlackMessage, removeConfigFile

end # module
