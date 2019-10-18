# Tutorial to use Slacker.jl

## Setting up Slack
The first thing you need is admin rights to your slack server. This allows you to
create a so called incoming webhook.

Click on [https://api.slack.com/incoming-webhooks](https://api.slack.com/incoming-webhooks)
for more details on the Slack website.

Store the URL to your incoming webhook somewhere safe. Anyone with access to this webhook
may post to your slack server.

## Setting up Slacker

First, go to the Julia REPL and install Slacker by calling the following:

```julia
using Pkg
Pkg.add("Slacker")
```
This should install the slacker package to your main workspace. Next you can setup slacker.
The most simple solution (if you only need one Slack server) is to set the default configuration
to your webhook.

```julia
cfg = SlackConfig("<YOUR WEBHOOK URL GOES HERE", "JuliaBot", "@yourname", ":ghost:")
```

Using this configuration will create a connection to your own "SlackBot Channel". The third
parameter tells you where messages are send to. Replace this with anything that is either a
valid slack channel (starting with #) or a username (starting with @).

The sceond parameter `"JuliaBot"` is the name for the sender. To make your posts recognizable
as a service being called from Julia, I would recommend going with Juliabot. However,
if you want to signal from various programs, you could use the program name as well.

The last parameter `":ghost:"` is the emoji code :ghost: for the avator of the sender.
I typically upload the *three balls* from Julia and define my own emoji called `:juliabot:`
in Slack. Feel free to adjust this as you like.

## Adding the configuration to the registry.
In order to save the configuration to the registry you can call the `addConfiguration()` function.
This allows you to store a set of configurations away from you project repository.
Your data is stored in your home directory. This ensures that if you make your code available,
e.g. on GitHub, that no other user will be able to post to your slack.

```julia
addConfiguration(cfg)
```

You could use Slacker without persisting the configuration in this manner.
However, this is only useful for testing purposes.
**Avoid storing your webhook url in your code** as clear text. This will expose your slack.

### Storing multiple servers in your registry.
The registry system works very simply. You can create as many server configurations as you like.
The only requirement is that they have a unique name when registering them using the
`addConfig` function.


## Sending message to slack
There are two ways of sending a message to slack. The first way is by sending a text
to the `sendSlackMessage` function

```julia
  sendSlackMessage("Hi this is Slacker.jl")
```

This will send a message to the server stored as the `"default"` configuration.
By adding additional servers to the registry you can send to those as easily.

```julia
  sendSlackMessage("Hi this is Slacker.jl", "MySlack")
```

The second parameter accepts both a `String` identifier from the registry, as well
as a `SlackConfig` object created temporarily.

## Removing Slacker from your computer.

Since Slacker writes to your home directory, there is a convenience function to remove your registry.

```julia
removeConfigFile()
```

**Warning:** Unsaved configurations will be lost after this.
