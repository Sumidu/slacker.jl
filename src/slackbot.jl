# This sends a message to slack
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


const INIT_ERROR_MSG = "Settings file not found. Please create a settings file using `addConfig(name)`."
const KEY_NOT_FOUND_ERROR_MSG = "No configuration found for this name. Please add using `addConfig(name)`"


function readSettingsFile()
    fn = getSettingsFile()
    isfile(fn) || error(INIT_ERROR_MSG)
    dic = Dict{String, SlackConfig}()

    str = open(fn) do file
        read(file, String)
    end

    res = JSON.parse(str)
    for entry in res
        val = SlackConfig(entry[2])
        dic[entry[1]] = val
    end
    dic
end




function addConfig(config::SlackConfig, name::String = "default")
    fn = getSettingsFile()
    dic = Dict(name => config)
    js = JSON.json(dic)

    if isfile(fn)
        @debug "File exists."
        configs = readSettingsFile()
        if haskey(configs,name)
            @info "Key Exists"
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

function removeConfigFile()
    fn = getSettingsFile()
    if isfile(fn)
        rm(fn)
    end
end


function removeConfig(name = "default")
    error("NOT IMPLEMENTED")
    fn = getSettingsFile()
    if isfile(fn)
        rm(fn)
    end
end


function registerSlackHook(webhook_url::String, name::String = "default")
    config = SlackConfig()
    config.webhook_url = webhook_url
    addConfig(config, name)
end

function loadConfig(name="default")
    settings = readSettingsFile()
    if haskey(settings, name)
        return settings[name]
    else
        error(KEY_NOT_FOUND_ERROR_MSG)
    end

end


addConfig(SlackConfig())
loadConfig()





function sendSlackMessage(channel, text; username = "JuliaBot", icon_emoji = ":ghost:")
    error("NOT IMPLEMENTED")
    a = Dict(
        "channel" => channel,
        "username" => username,
        "text" => text,
        "icon_emoji" => icon_emoji)

    message = "payload=" * json(a)
    webhook = getWebHookURL()
    HTTP.request("POST",
        webhook,
        ["Content-Type" => "application/x-www-form-urlencoded"], message;
        verbose = 0)
end
