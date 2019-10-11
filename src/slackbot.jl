# This contains the main slacker program

const INIT_ERROR_MSG = "Settings file not found. Please create a settings file using `addConfig(name)`."
const KEY_NOT_FOUND_ERROR_MSG = "No configuration found for this name. Please add using `addConfig(name)`"


# A structure that contains a configuration for an incoming webhook on slack
mutable struct SlackConfig
    webhook_url:: String
    user:: String
    channel:: String
    icon_emoji:: String
    function SlackConfig()
        SlackConfig("http://www.example.org", "JuliaBot", "#general", ":ghost:")
    end

    function SlackConfig(dic)
        SlackConfig(dic["webhook_url"], dic["user"], dic["channel"], dic["icon_emoji"])
    end

    function SlackConfig(webhook_url, user, channel, icon_emoji)
        new(webhook_url, user, channel, icon_emoji)
    end

end



function getSettingsFile()
    joinpath(homedir(), ".slacker_config.json")
end



# read all settings
function readSettingsFile()
    fn = getSettingsFile()
    isfile(fn) || error(INIT_ERROR_MSG)
    dic = Dict{String, SlackConfig}()

    # read file
    str = open(fn) do file
        read(file, String)
    end

    # parse json to Dict
    res = JSON.parse(str)
    for entry in res
        val = SlackConfig(entry[2])
        dic[entry[1]] = val
    end
    dic
end



# add a configuration to registry
function addConfig(config::SlackConfig, name::String = "default")
    fn = getSettingsFile()
    dic = Dict(name => config)
    js = JSON.json(dic)

    if isfile(fn)
        @debug "File exists."
        configs = readSettingsFile()
        if haskey(configs,name)
            @warn "Overwriting exisiting configuration."
            configs[name] = config
            open(fn, write = true) do file
                write(file, JSON.json(configs))
            end
        else
            configs[name] = config
            @debug "Append Key"
            open(fn, write = true) do file
                write(file, JSON.json(configs))
            end
        end
    else
        @debug "New File."
        open(fn, write = true) do file
            write(file, js)
        end
    end
end

# delete the registry
function removeConfigFile()
    fn = getSettingsFile()
    if isfile(fn)
        rm(fn)
    end
end



# load a specific config from the registry
function loadConfig(name="default")
    settings = readSettingsFile()
    if haskey(settings, name)
        return settings[name]
    else
        error(KEY_NOT_FOUND_ERROR_MSG)
    end

end


#send message to slack using a config name
function sendSlackMessage(text, config::SlackConfig)
    a = Dict(
        "channel" => config.channel,
        "username" => config.user,
        "text" => text,
        "icon_emoji" => config.icon_emoji)

    message = "payload=" * JSON.json(a)
    webhook = config.webhook_url
    try
        resp = HTTP.request("POST",
            webhook,
            ["Content-Type" => "application/x-www-form-urlencoded"], message;
            verbose = 0)
    catch e
        @warn "Could not send message $e"
    end
end


"""
    sendSlackMessage(text, cfg::String = "default")

Sends a message to the configured default slack server or the one specified in `cfg`.
"""
function sendSlackMessage(text, cfg::String = "default")
    config = loadConfig(cfg)
    sendSlackMessage(text, config)
end


#TODO

function removeConfig(name = "default")
    error("NOT IMPLEMENTED")
end
