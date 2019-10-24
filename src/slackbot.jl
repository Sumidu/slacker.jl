# This contains the main slacker program

const INIT_ERROR_MSG = "Config file not found. Please create a settings file using `addConfig(name)`."
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

    """
    ...
    # Arguments
    - `webhook_url::String`: the incoming webhook_url
    - `user::String`: the name of the user Slacker should have in slack.
    - `channel::String`: the channel Slacker should post to. Allows channel with # and direc messages using @.
    - `icon_emoji::String` : the icon the user should have when posting. By adding a custom emoji e.g. :juliabot: you can easily give julia its own avatar.
    ...
    """
    function SlackConfig(webhook_url, user, channel, icon_emoji)
        new(webhook_url, user, channel, icon_emoji)
    end

end



function getConfigFile()
    joinpath(homedir(), ".slacker_config.json")
end



"""
Load the registry and return all registered servers as a Dict.
"""
function readConfigFile()
    fn = getConfigFile()
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


"""
Add a Slack server configuration to the registry. Shorthand to create a
 configuration that posts to the random channel (uses Juliabot and :ghost:
 as defaults).

# Examples
```julia-repl
julia> addConfig("server.url", "config_name")
```
"""
function addConfig(webhook_url::String, name::String)
    cfg = SlackConfig(webhook_url, "Juliabot", "#random",":ghost:")
    addConfig(cfg, name)
end

"""
Add a Slack server configuration to the registry. Multiple servers can be
defined by adjusting the `name` parameter.

# Examples
```julia-repl
julia> addConfig(SlackConfig("server.url", "username", "#channel", ":smile:"))
```
"""
function addConfig(config::SlackConfig, name::String = "default")
    fn = getConfigFile()
    dic = Dict(name => config)
    js = JSON.json(dic)

    if isfile(fn)
        @debug "File exists."
        configs = readConfigFile()
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

"""
Deletes the whole registry from the computer.
"""
function removeConfigFile()
    fn = getConfigFile()
    if isfile(fn)
        rm(fn)
    end
end



"""
Load the default configuration from the registry. Other configurations may be loaded
by specifying the `name` parameter.
"""
function loadConfig(name="default")
    settings = readConfigFile()
    if haskey(settings, name)
        return settings[name]
    else
        error(KEY_NOT_FOUND_ERROR_MSG)
    end

end

"""
Sends a message `text`to Server defined in the configuration `cfg`.
"""
function sendMessage(text, config::SlackConfig)
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
Sends a message `text`to the configured default slack server or the one specified in `cfg`.
"""
function sendMessage(text, cfg::String = "default")
    config = loadConfig(cfg)
    sendMessage(text, config)
end


"""
Tests whether a configuration exists
"""
function hasConfig(name = "default")
    fn = getConfigFile()
    if isfile(fn)
        dic = readConfigFile()
        if haskey(dic, name)
            return true
        end
    end
    false
end


"""
removes an individual configuration
call with parameter "default" to delete the default configuration
"""
function removeConfig(name)
    #helps debugging
    #name = "default"
    fn = getConfigFile()
    dic = readConfigFile()
    if haskey(dic, name)
        cfg = pop!(dic, name)
    end
    # helps for debugging
    #dic[name] = cfg
    open(fn, write = true) do file
        write(file, JSON.json(dic))
    end
    "Configuration $name removed."
end
