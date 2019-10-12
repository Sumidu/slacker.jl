module Slacker
using HTTP, JSON

include("slackbot.jl")

export SlackConfig, addConfig, loadConfig, sendSlackMessage, removeConfigFile, readSettingsFile

end # module
