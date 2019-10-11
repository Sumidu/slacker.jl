# Slacker

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sumidu.github.io/slacker.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sumidu.github.io/slacker.jl/dev)
[![Build Status](https://travis-ci.com/sumidu/slacker.jl.svg?branch=master)](https://travis-ci.com/sumidu/slacker.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/sumidu/slacker.jl?svg=true)](https://ci.appveyor.com/project/sumidu/slacker-jl)
[![Codecov](https://codecov.io/gh/sumidu/slacker.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/sumidu/slacker.jl)
[![Coveralls](https://coveralls.io/repos/github/sumidu/slacker.jl/badge.svg?branch=master)](https://coveralls.io/github/sumidu/slacker.jl?branch=master)

A package that allows sending to slack. It uses a configuration file stored in the home directory of the user.
It allows for multiple named configurations, if several slack servers are used.


## Installation

```julia
using Pkg
Pkg.dev("http://github.com/sumidu/slacker.jl")
```

## Usage
```julia
  using Slacker

  # replace the url with your incoming Webhook URL
  cfg = SlackConfig("https://hooks.slack.com/services/....", "JuliaBot", "#general", ":ghost:")

  addConfig(cfg)

  sendSlackMessage("Hi this is a Test from Slacker.")

```

## Using Multiple Servers


```julia
  using Slacker

  cfg1 = SlackConfig("url1", "JuliaBot", "#general", ":ghost:")
  cfg2 = SlackConfig("url2", "JuliaBot2", "@sumidu", ":smile:")

  addConfig(cfg, "server1")
  addConfig(cfg, "server2")

  sendSlackMessage("Hi this is a Test from Slacker to server1.", "server1")
  sendSlackMessage("Hi this is a Test from Slacker to server1.", "server2")

```

## Changing the channel or Username of a configuration temporarily

```julia
  using Slacker

  cfg = loadConfig("server1")
  cfg.channel = "#random"
  cfg.user = "Julia Random Bot"
  cfg.icon_emoji = ":grinning:"

  sendSlackMessage("Hi this is a Test from Slacker to server1.", cfg)
```
