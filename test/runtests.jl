using Slacker
using Test

import Slacker.getSettingsFile

function backup()
    src = getSettingsFile()
    target = joinpath(tempdir(),"slackerbackup.json" )
    if isfile(src)
        cp(src, target, force = true)
    end
end


function restore()
    src = getSettingsFile()
    target = joinpath(tempdir(),"slackerbackup.json" )
    if isfile(target)
        mv(target, src, force = true)
    end
end


@testset "SlackConfigs" begin

    # does blank object instantiation work?
    @test isa(SlackConfig(), SlackConfig)


end

@testset "Slacker.jl" begin


    backup()
    addConfig(SlackConfig(), "testConfig")
    @test isfile(getSettingsFile())

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

    removeConfigFile()

    @test !isfile(getSettingsFile())
    restore()
end
