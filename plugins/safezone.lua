local PLUGIN = PLUGIN
PLUGIN.name = "Safe Zones"
PLUGIN.author = "some faggot"
PLUGIN.desc = "Safe zones"

local playerMeta = FindMetaTable("Player")

function playerMeta:isInArea(areaID)
	local areaData = nut.area.getArea(areaID)

	if (!areaData) then
		return false, "Area you specified is not valid."
	end

	--local char = v:getChar()

	--if (!char) then
	--	return false, "Your character is not valid."
	--end

	local clientPos = self:GetPos() + self:OBBCenter()
	return clientPos:WithinAABox(areaData.minVector, areaData.maxVector), areaData
end

function playerMeta:getSafeStatus()
	return (self:getNetVar("isSafe")) or false
end

function playerMeta:setSafeStatus(status)
	self:setNetVar("isSafe", status)
end
if (CLIENT) then
	function PLUGIN:HUDPaint()
		if LocalPlayer():getSafeStatus() then
			local Texture1 = Material("sprites/sent_ball") --This is setup to draw a 32x32 icon on the HUD if you're safe
			surface.SetMaterial(Texture1)
			surface.SetDrawColor(Color(0, 255, 0, 255))
			surface.DrawTexturedRect(ScrW()-48, ScrH()-189, 32, 32, Color(0, 255, 0, 255))
			else
				local Texture1 = Material("sprites/sent_ball") --This is setup to draw a 32x32 icon on the HUD if you're not safe
				surface.SetMaterial(Texture1)
				surface.SetDrawColor(Color(255, 0, 0, 255))
				surface.DrawTexturedRect(ScrW()-48, ScrH()-189, 32, 32, Color(0, 255, 0, 255))
			
		end
	end
else
function PLUGIN:PlayerLoadedChar(client, character, lastChar)
		client:setSafeStatus(false)
		client:setNetVar("safeTick", CurTime() + 5)
end
function PLUGIN:OnPlayerAreaChanged(client, areaID)
	if client:getArea() then
		client:setNetVar("safeTick", CurTime() + 5)
	end
end

function PLUGIN:ScalePlayerDamage(client, hitGroup, dmgInfo)
	if client:getSafeStatus() then
		dmgInfo:ScaleDamage(0)
	end
end


local thinkTime = CurTime()
local funny = 0
function PLUGIN:Think()
	if (thinkTime < CurTime()) then
		for k, v in ipairs(player.GetAll()) do
			funny = 0
			for u, i in ipairs(nut.area.getAllArea()) do
				if v:isInArea(u) then
					funny = 0
					break
				end
				funny = funny + 1
			end
			if funny > 0 then
				v.curArea = nil
			end
		
			if v:getArea() ~= nil then
				if !v:getSafeStatus("isSafe") then
					if v:getNetVar("safeTick") > CurTime() then
						v:setSafeStatus(true)
					end
				end
			else
				v:setSafeStatus(false)
				v:setNetVar("safeTick", CurTime() + 5)
			end
		end
		thinkTime = CurTime() + .5
	end
end
end