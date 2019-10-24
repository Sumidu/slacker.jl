using Slacker
using Test
using HTTP
using JSON

import Slacker.getConfigFile

function backup()
    src = getConfigFile()
    target = joinpath(tempdir(),"slackerbackup.json" )
    if isfile(src)
        cp(src, target, force = true)
    end
end


function restore()
    src = getConfigFile()
    target = joinpath(tempdir(),"slackerbackup.json" )
    if isfile(target)
        mv(target, src, force = true)
    end
end


@testset "SlackConfig Constructors" begin

    # does blank object instantiation work?
    @test isa(SlackConfig(), SlackConfig)


end

@testset "Creating and writing Config Files" begin

    # ensure existing configuration is not overridden
    backup()
    addConfig(SlackConfig(), "testConfig")
    @test isfile(getConfigFile())

    conf = loadConfig("testConfig")

    @test conf.user == "JuliaBot"
    @test conf.channel == "#general"
    @test conf.icon_emoji == ":ghost:"

    addConfig(SlackConfig("webhook", "name", "channel", "icon"), "testConfig2")
    conf2 = loadConfig("testConfig2")

    @test conf2.webhook_url == "webhook"
    @test conf2.user == "name"
    @test conf2.channel == "channel"
    @test conf2.icon_emoji == "icon"


    #@test_warn "Overwriting exisiting configuration." addConfig(SlackConfig("webhook", "name2", "channel2", "icon2"), "testConfig2")
    conf2 = loadConfig("testConfig2")


    removeConfigFile()
    @test !isfile(getConfigFile())
    restore()

end

@testset "Removing Configs" begin
    addConfig("DUMMY_URL", "testConfig3")
    @test hasConfig("testConfig3") == true
    removeConfig("testConfig3")
    @test hasConfig("testConfig3") == false

end

@testset "Sending Messages" begin
    message = "This is a complicated Test Message. :smile:"
    addConfig("https://postman-echo.com/post", "echo_config")
    res = sendMessage(message, "echo_config")
    @test res.status==200
    @test res.headers[1][1]=="Content-Type"
    @test res.headers[1][2]=="application/json; charset=utf-8"
    body = String(res.body)
    dic = JSON.parse(body)
    content = JSON.parse(dic["json"]["payload"])
    @test content["channel"] == "#random"
    @test content["username"] == "Juliabot"
    @test content["icon_emoji"] == ":ghost:"
    @test content["text"] == message
    removeConfig("echo_config")
    @test hasConfig("echo_config") == false

end



#TODO Test overwriting of file?
# Loadconfig not found error
# sending... figure out how :D
