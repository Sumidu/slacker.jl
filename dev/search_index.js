var documenterSearchIndex = {"docs":
[{"location":"#Slacker.jl-1","page":"Home","title":"Slacker.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Modules = [Slacker]","category":"page"},{"location":"#Slacker.addConfig","page":"Home","title":"Slacker.addConfig","text":"addConfig(config::SlackConfig, name::String = \"default\")\n\nAdd a Slack server configuration to the registry. Multiple servers can be defined by adjusting the name parameter.\n\n\n\n\n\n","category":"function"},{"location":"#Slacker.loadConfig","page":"Home","title":"Slacker.loadConfig","text":"loadConfig(name=\"default\")\n\nLoad the default configuration from the registry. Other configurations may be loaded by specifying the name parameter.\n\n\n\n\n\n","category":"function"},{"location":"#Slacker.readSettingsFile-Tuple{}","page":"Home","title":"Slacker.readSettingsFile","text":"readSettingsFile()\n\nLoad the registry and return all registered servers as a Dict.\n\n\n\n\n\n","category":"method"},{"location":"#Slacker.removeConfigFile-Tuple{}","page":"Home","title":"Slacker.removeConfigFile","text":"removeConfigFile()\n\nDeletes the whole registry from the computer.\n\n\n\n\n\n","category":"method"},{"location":"#Slacker.sendSlackMessage","page":"Home","title":"Slacker.sendSlackMessage","text":"sendSlackMessage(text, cfg::String = \"default\")\n\nSends a message textto the configured default slack server or the one specified in cfg.\n\n\n\n\n\n","category":"function"},{"location":"#Slacker.sendSlackMessage-Tuple{Any,SlackConfig}","page":"Home","title":"Slacker.sendSlackMessage","text":"sendSlackMessage(text, cfg::SlackConfig)\n\nSends a message textto Server defined in the configuration cfg.\n\n\n\n\n\n","category":"method"}]
}
