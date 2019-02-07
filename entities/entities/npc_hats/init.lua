AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize( )
	self:SetModel( "models/Characters/Hostage_02.mdl" )
 	self:SetHullType( HULL_HUMAN )
	self:SetUseType( SIMPLE_USE )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetMaxYawSpeed( 5000 )
	local PhysAwake = self.Entity:GetPhysicsObject()
	if PhysAwake:IsValid() then
		PhysAwake:Wake()
	end 
end

function ENT:OnTakeDamage( dmg ) 
	return false
end

function ENT:AcceptInput( name, activator, caller )
   if ( name == "Use" && IsValid( activator ) ) then
		activator:PS_ToggleMenu()
    end
end
