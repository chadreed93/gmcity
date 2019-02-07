PLUGIN.name = "Broadcast system"
PLUGIN.desc = "Broadcasts a chat message to anyone in the server."
PLUGIN.author = "PMX"

-- Variables that you can change
CHAT_IDENTIFIER = "[BROADCAST] "
CHAT_IDENTIFIER_COLOR = Color(0, 153, 0)
CHAT_MESSAGE_COLOR = Color(255, 255, 255)
CHAT_ALLOWED_RANK = "superadmin"
CHAT_NO_PERMISSIONS = "You do not have enough privileges to do that!"

-- Do not change anything below this line unless you know what you are doing
nut.chat.register("broadcast", {
    onGetColor = function(speaker, text)
        return Color(255,255,255)
    end,
    onChatAdd = function(speaker, text)
    	if(speaker:IsUserGroup(CHAT_ALLOWED_RANK)) then                         
        	chat.AddText(CHAT_IDENTIFIER_COLOR, CHAT_IDENTIFIER, CHAT_MESSAGE_COLOR, text)
        else
        	nut.util.notify(CHAT_NO_PERMISSIONS, speaker)
        end
    end,
    onCanHear = function(speaker, listener)
            if (listener:Alive()) then
                listener:EmitSound("ambient/levels/prison/radio_random" .. math.random( 1, 9 ) ..".wav")
            else
                return false
            end
    end,
    deadCanChat = false,
    format = "%s to everyone: %s",
    prefix = {"/bc"},
    noSpaceAfter = true
})