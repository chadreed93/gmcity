PLUGIN.name = "Extended Chat";
PLUGIN.author = "Casadis";
PLUGIN.desc = "Adds a variety of useful commands for admins and players alike.";

nut.util.include("sh_commands.lua");

nut.config.add("pdaNetwork", true, "Whether or not the PDA network is online.", nil, {
	category = "Chat"
});
