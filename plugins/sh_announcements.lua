PLUGIN.name = "Admin Announcement"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Allows server administrators to send out announcements."


nut.chat.register("adminannounce", {
	onCanSay =  function(speaker, text)
		return speaker:IsAdmin()
	end,
	onCanHear = 1000000,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(255, 0, 250), " [Admin Announcement] ", color_white, text)
	end,
	prefix = {"/adminannounce"}
})