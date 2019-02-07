AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[------------------------------------------------------------------------------------

	THINGS YOU CAN EDIT

--]]------------------------------------------------------------------------------------
local recharge_time = 2 //Time between each recharge after using the dumpster
local prop_delete_time = 15 //Time of how long the props that shoot out will last
local minimum_amount_items = 2 //Least amount of items that can come from dumpster
local maximum_amount_items = 4 //Max amount of items that can come from dumpster
local open_sound = "physics/metal/metal_solid_strain5.wav" //Sound played when the dumpster is used

--Keep all of these numbers whole numbers between 1-100
local prop_percentage = 100 //When set to 100, if no entities or weapons were created, then a prop will be 
local ent_percentage = 25
local weapon_percentage = 10
--Keep all of these numbers whole numbers between 1-100

local Allowed_Dumpster_Teams = { //The teams that are allowed to use the dumpster
	TEAM_HOBO,
	TEAM_CITIZEN,
}

local Dumpster_Items = {
	Props = { --Add/Change models of props
		"models/props_c17/FurnitureShelf001b.mdl",
		"models/props_c17/FurnitureDrawer001a_Chunk02.mdl",
		"models/props_interiors/refrigeratorDoor02a.mdl",
		"models/props_lab/lockerdoorleft.mdl",
		"models/props_wasteland/prison_lamp001c.mdl",
		"models/props_wasteland/prison_shelf002a.mdl",
		"models/props_vehicles/tire001c_car.mdl",
		"models/props_trainstation/traincar_rack001.mdl",
		"models/props_interiors/SinkKitchen01a.mdl",
		"models/props_c17/lampShade001a.mdl", 
		"models/props_junk/PlasticCrate01a.mdl",
		"models/props_c17/metalladder002b.mdl",
		"models/Gibs/HGIBS.mdl",
		"models/props_c17/metalPot001a.mdl",
		"models/props_c17/streetsign002b.mdl",
		"models/props_c17/pottery06a.mdl",
		"models/props_combine/breenbust.mdl",
		"models/props_lab/partsbin01.mdl",
		"models/props_trainstation/payphone_reciever001a.mdl",
		"models/props_vehicles/carparts_door01a.mdl",
		"models/props_vehicles/carparts_axel01a.mdl"
	},
	
	Ents =  { --Change these to entites you want
		"lockpick",
		"keypad_cracker"
	},
	
	Weapons = { --Change these to weapons that you want
		"bb_mac10_alt",
		"bb_fiveseven_alt",
		"bb_deagle_alt",
		"bb_p228_alt",
		"bb_usp_alt",
		"bb_mp5_alt",
		"bb_tmp_alt",
		"bb_p90_alt",
	}
}
/*
local Spawn_Positions = { //The locations/angles of each dumpster
	{Vector(2922.516846, -2890.843994, 97.614372), Angle(0,0,0)},
	{Vector(5541.050293, -1697.577881, 97.615143), Angle(0,180,0)},
	{Vector(4571.008789, -3546.913818, 97.582504), Angle(0,-90,0)},
	{Vector(3685.531738, -2714.948730, -638.518066), Angle(0,180,0)},
	{Vector(1413.322876, 1508.890015, 89.552284), Angle(0,-90,0)},
	{Vector(1370.521851, -3125.158691, 90.464058), Angle(0,90,0)}
}*/
--[[------------------------------------------------------------------------------------

	THINGS YOU CAN EDIT

--]]------------------------------------------------------------------------------------

function ENT:Initialize()
	self:SetModel("models/props_junk/TrashDumpster01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage(dmginfo)
	return
end

function ENT:EmitItems(searcher)
	self:EmitSound(open_sound, 300, 100)
	local pos = self:GetPos() + Vector(0, 0, 50)
	
	for i = 1, math.random(minimum_amount_items,maximum_amount_items) do
		if math.random(1, 100) <= weapon_percentage then
			local ent = ents.Create(table.Random(Dumpster_Items["Weapons"]))
			ent:SetPos(pos)
			ent:Spawn()
		elseif math.random(1, 100) <= ent_percentage then
			local ent = ents.Create(table.Random(Dumpster_Items["Ents"]))
			ent:SetPos(pos)
			ent:Spawn()
		elseif math.random(1, 100) <= prop_percentage then
			local prop = ents.Create("prop_physics")
			prop:SetModel(table.Random(Dumpster_Items["Props"]))
			prop:SetPos(pos)
			prop:Spawn()
			
			timer.Simple(prop_delete_time, function() -- Remove the prop after x seconds
				if prop:IsValid() then
					prop:Remove()
				end
			end)
		end
	end
end

function ENT:Use(activator)
	if self:GetDTInt(0) > 0 then return end
	
	if table.HasValue(Allowed_Dumpster_Teams, activator:Team()) then
		self:SetDTInt(0, recharge_time)
		self:EmitItems(activator)
		timer.Create("DTime " ..self:EntIndex(), 1, recharge_time, function()
			self:RemoveTime()
		end)
	end
end

function ENT:Think()

end

function ENT:RemoveTime()
	self:SetDTInt(0, self:GetDTInt(0) - 1)
	
	if self:GetDTInt(0) <= 0 then
		if timer.Exists("DTime " ..self:EntIndex()) then
			timer.Destroy("DTime " ..self:EntIndex())
		end
	end
end
/*
hook.Add("InitPostEntity", "SpawnDumpsters", function()
	timer.Simple(2, function()
		for k,v in pairs(Spawn_Positions) do
			local dump = ents.Create("dumpster")
			dump:SetPos(v[1])
			dump:SetAngles(v[2])
			dump:Spawn()
		end
	end)
end)
