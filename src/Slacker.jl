module Slacker
using HTTP, JSON

include("slackbot.jl")

export SlackConfig, addConfig, loadConfig, sendMessage, removeConfigFile, readConfigFile
export hasConfig, removeConfig

end # module
