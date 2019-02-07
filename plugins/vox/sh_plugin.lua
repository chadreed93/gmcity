PLUGIN.name = "VOX Announcer"
PLUGIN.author = "Weedvangelist"
PLUGIN.desc = "Black Mesa VOX Announcer."

nut.util.include("cl_vox.lua")

if (CLIENT) then
	surface.CreateFont("nut_VOXText", {
		font = "Courier New",
		size = 22,
		weight = 800
	})
	
	function PLUGIN:BuildHelpOptions(data, tree)
		data:AddHelp("VOX List", function()
			return "https://github.com/Weedvangelist/bmrp-addons/blob/master/Vox%20Announcer/wordlist.txt"
		end, "icon16/comment.png")
	end
else
	-- This workshop has the sound files that you need.
	resource.AddWorkshop("1533069346")
end

function PLUGIN:IsVOXAllowed(client)
	return client:IsAdmin() -- Change this if you need so.
end

local prefixes = {"/vox", "/v", "/announce"} -- Change this if you need so.
local voxname = "VOX"
local textFilter = {
	"bizwarn",
	"bloop",
	"delay",
	"beep",
	"bell",
	"blip",
	"boop",
	"buzz",
	"dadeda",
	"deeoo",
	"doop",
	"flatline",
	"fuzz",
	"_commna",
	"_period",
}

local slen = string.len
local sleft = string.Left
local sright = string.Right
local srep = string.Replace

nut.chat.register("vox", {
	onChat = function(speaker, text)
		voxBroadcast(text)
		-- filter text
		text = string.gsub( text, "[0-9!=.-]", "" )
	
		for _, word in ipairs( textFilter ) do
			text = srep( text, word .. " ", "" )	
			text = srep( text, word, "" )	
		end

		local index = 1
		while (text[index] == " ") do
			index = index + 1	
		end
		text = sright(text, slen(text)-(index-1))

		index = 0
		while (text[slen(text)-index] == " ") do
			index = index + 1	
		end
		text = sleft(text, slen(text)-(index))

		chat.AddText(Color(133, 133, 133), voxname .. ": ".. string.upper(text) .. "." )
	end,
	prefix = prefixes,
	canHear = function(speaker, listener)
		return true
	end,
	canSay = function(speaker)
		if nut.schema.Call("IsVOXAllowed", speaker) != false then
			return true
		end

		nut.util.Notify("You're not permitted to broadcast VOX.", speaker)
	end,
	font = "nut_VOXText"
})