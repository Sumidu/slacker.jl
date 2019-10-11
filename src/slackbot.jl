# This sends a message to slack




function getWebHookURL()
    f = ".slack_webhook"
    s = read(f, String)
    chop(s)
end

function sendSlackMessage(channel, text; username = "JuliaBot", icon_emoji = ":ghost:")
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
