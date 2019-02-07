//ENT.Base = "base_ai" 
//ENT.Type = "ai"
//ENT.Base = "base_gmodentity" 
//ENT.Type = "anim"

ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName		= "Donation NPC"
ENT.Author			= "-Dave-"
ENT.Contact			= "N/A"
ENT.Purpose			= "N/A"
ENT.Instructions	= "Press E"
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end