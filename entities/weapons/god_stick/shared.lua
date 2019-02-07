if( SERVER ) then
 
        AddCSLuaFile( "shared.lua" );
 
end
if( CLIENT ) then
 
        SWEP.PrintName = "Stick Of Administration";
        SWEP.Slot = 0;
        SWEP.SlotPos = 5;
        SWEP.DrawAmmo = false;
        SWEP.DrawCrosshair = false;
 
end

// Variables that are used on both client and server
 
SWEP.Author			= "Nate"
SWEP.Instructions       = "Left click to Punish, right click to change option"
SWEP.Contact       		= ""
SWEP.Purpose        	= "To punish minges"
 
SWEP.ViewModelFOV       = 47
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  		= "melee"

SWEP.Spawnable      	= false
SWEP.AdminSpawnable     = true
SWEP.Category = "CityRP"

SWEP.NextStrike = 0;

SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing"..math.random(1, 2)..".wav" );
SWEP.Sound1 = Sound( "npc/metropolice/vo/moveit.wav" );
SWEP.Sound2 = Sound( "npc/metropolice/vo/movealong.wav" );

SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = 0                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = false            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = 0            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
 
SWEP.UseHands = true
SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.FireWhenLowered = true
/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
 
        if( SERVER ) then

				self.Gear = 1;
        
        end
		
		self:SetWeaponHoldType( "normal" );
		
end

local SLAP_SOUNDS = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav"
}
 
 
/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end
 
function SWEP:DoFlash( ply )
 
        umsg.Start( "StunStickFlash", ply ); umsg.End();
 
end

local Gears = {};

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
        if( CurTime() < self.NextStrike ) then return; end
		if !self.Owner:IsAdmin() then
			self.Owner:Kick("Admin Stick with no Admin?...");
			return false;
		end
 
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		local r, g, b, a = self.Owner:GetColor();
		
		
		if a != 0 then
			self:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1, 2)..".wav", 70, math.random(95, 110))
		end
		
		
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
 
        self.NextStrike = ( CurTime() + .3 );

        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
        
        local Gear = self.Owner:GetTable().CurGear or 1;
		
		if Gears[Gear][3] and !self.Owner:IsSuperAdmin() then
			self.Owner:notify("This gear requires Super Admin status.");
			return false;
		end
		
		Gears[Gear][4](self.Owner, trace);
  end
  

  local function AddGear ( Title, Desc, SA, Func )
		table.insert(Gears, {Title, Desc, SA, Func});
  end
  
AddGear("[DEV]ENT Info", "Left Click to get Info of an Entity.", false,
function ( Player )
	local Eyes = Player:GetEyeTrace().Entity:GetPos();
	local Eyes2 = Player:GetEyeTrace().Entity:GetAngles();
	local Eyes3 = Player:GetEyeTrace().Entity:GetModel();

	if (CLIENT) then
		SetClipboardText('Vector(' .. math.Round(Eyes.x) .. ', ' .. math.Round(Eyes.y) .. ', ' .. math.Round(Eyes.z) .. ')');
	end
	Player:PrintMessage(HUD_PRINTTALK, Eyes3);
	Player:PrintMessage(HUD_PRINTTALK, 'Vector(' .. math.Round(Eyes.x) .. ', ' .. math.Round(Eyes.y) .. ', ' .. math.Round(Eyes.z) .. ')\nAngle(' .. tostring(Eyes2) .. ')');
end
);  
  
AddGear("Kill Player", "Aim at a player to slay him.", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity:Kill();
			Player:notify("Player has been killed");

		end
	end
);

AddGear("Slap Player", "Aim at an entity to slap him.", false,
	function ( Player, Trace )
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:notify("Entity has been slapped");

				else
					local RandomVelocity = Vector( math.random(500) - 250, math.random(500) - 250, math.random(500) - (500 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:notify("Player has been slapped");

				end
	end
);

AddGear("Warn Player", "Aim at a player to warn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:notify("An admin thinks you're doing something stupid. Stop.");
				Player:notify("Player has been warned via notification");
			end
	end
);

AddGear("Kick Player", "Aim at a player to kick him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity:SteamID() == "STEAM_0:0:19025303" then
					self.Owner:Kill();
					Player:notify("REALLY NIGGA!");
				else
					Trace.Entity:Kick("Kicked.");
					Player:notify("Player has been kicked");
				end
			end
	end
);

AddGear("Respawn Player", "Aim at a player to respawn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:notify("An administrator has respawned you.");
				Trace.Entity:Spawn();
				Player:notify("Player has been respawned");
			end
	end
);

AddGear("Super Slap Player", "Aim at an entity to super slap him.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(50000) - 25000, math.random(50000) - 25000, math.random(50000) - (50000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:notify("Slapped that damn entity into space");
				else
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:notify("Slapped the hoe with my pimp hand");
				end
			end
	end
);

AddGear("Unlock Door", "Aim at a door to unlock it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('unlock', '', 0);
				Trace.Entity:Fire('open', '', .5);
				Player:notify("Door locked.");
			end
	end
);

AddGear("Lock Door", "Aim at a door to lock it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('lock', '', 0);
				Trace.Entity:Fire('close', '', .5);
				Player:notify("Door locked.");
			end
	end
);

AddGear("Invisibility", "Left click to turn invisible. Left click again to return back to normal.", true,
	function ( Player )
		local r, g, b, a = Player:GetColor();
		
		if a == 255 then
			Player:notify("You are now invisible.");
			Player:SetColor(0, 0, 0, 0);
		else
			Player:notify("You are no longer invisible.");
			Player:SetColor(255, 255, 255, 255);
		end
	end
);

AddGear("Retrieve Item Owner", "Left click to retrieve owner of an item", true,
	function(Player, Trace)
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Player:notify("Don't be an idiot and ask for whos the owner of the player, tard.")
			return false
		end
		
		if IsValid(Trace.Entity) then
			if Trace.Entity:GetTable().ItemSpawner then
				Player:notify("Owner: " .. Trace.Entity:GetTable().ItemSpawner:GetRPName() .. "[" .. Trace.Entity:GetTable().ItemSpawner:Nick() .. "]")
			elseif Trace.Entity.pickupPlayer then
				Player:notify("Owner: " .. Trace.Entity.pickupPlayer:GetRPName() .. "[" .. Trace.Entity.pickupPlayer:Nick() .. "]")
			elseif Trace.Entity:GetTable().Owner then
				Player:notify("Owner: " .. Trace.Entity:GetTable().Owner:GetRPName() .. "[" .. Trace.Entity:GetTable().Owner:Nick() .. "]")
			else
				Player:notify("Unsupported entity")
			end
		end
	end
);	


AddGear("Revive Player", "Aim at a corpse to revive the player.", true,
	function ( Player, Trace )
		Player:notify("Doesn't work yet, scream at nate to add it.");

	end
);

AddGear("Ignite", "Spawns a fire wherever you're aiming.", true,
	function ( Player, Trace )
		if IsValid(Trace.Entity) then
			Trace.Entity:Ignite(300);
		else
			local Fire = ents.Create('vfire');
			Fire:SetPos(Trace.HitPos);
			Fire:Spawn();
			
			Player:notify("Fire started.");

		end
	end
);

AddGear("Teleport", "Teleports you to a targeted location.", true,
	function ( Player, Trace )
		local EndPos = Player:GetEyeTrace().HitPos;
		local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward();
		
		Player:SetPos(EndPos + (CloserToUs * 20));
		Player:notify("You have teleported.");
	end
);

AddGear("God Mode", "Left click to alternate between god and mortal.", true,
	function ( Player, Trace )
		if Player.IsGod then
			Player.IsGod = false;
			Player:notify("You are now vulnerable.");
			Player:GodDisable();
		else
			Player.IsGod = true;
			Player:notify("You are now invulnerable.");
			Player:GodEnable();
		end
	end
);

AddGear("Extinguish ( Local )", "Extinguishes the fires near where you aim.", true,
	function ( Player, Trace )
			for k, v in pairs(ents.FindInSphere(Trace.HitPos, 250)) do
				if v:GetClass() == 'vfire' then
					v:Remove();
				end
			end
			
			Player:notify("All fires extinguished nearby.");
	end
);

 AddGear("Extinguish ( All )", "Extinguishes all fires on the map.", true,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('vfire')) do
				v:Remove();
			end
			
			for k, v in pairs(player.GetAll()) do
				v:notify("All fires on the map have been extinguished to preserve gameplay.");
			end
			
			Player:notify("Fires extinguished.");
	end
);

AddGear("Remover", "Aim at any object to remove it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "ticket_check") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "car_display") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "prop_vehicle_prisoner_pod") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx_repeater") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control2") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				end;
				
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
				else
					Trace.Entity:Remove();
				end
			end
	end
);

AddGear("Explode", "Aim at any object to explode it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "ticket_check") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "car_display") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "prop_vehicle_prisoner_pod") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx_repeater") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control2") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				end;
				
				ExplodeInit(Trace.Entity:GetPos(), Player)
				
				timer.Simple(.5, function ( )
					if IsValid(Trace.Entity) then
						if Trace.Entity:IsPlayer() then
							Trace.Entity:Kill();
						elseif string.find(tostring(Trace.Entity), "jeep") then
							Trace.Entity:DisableVehicle(true, false)
						else
							Trace.Entity:Remove();
						end
					end
				end);
			end
	end
);

AddGear("Freeze", "Target a player to change his freeze state.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity.IsFrozens then
					Trace.Entity:Freeze(false);
					Player:notify("Player unfrozen.");
					Trace.Entity:notify("You have been unfrozen.");
					Trace.Entity.IsFrozens = nil;
				else
					Trace.Entity.IsFrozens = true;
					Trace.Entity:Freeze(true);
					Player:notify("Player frozen.");
					Trace.Entity:notify("You have been frozen.");
				end

			end
	end
);

AddGear("Telekinesis ( Stupid )", "Left click to make it float.", true,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = nil;
			end
	end
);

AddGear("Telekinesis ( Smart )", "Left click to make it float and follow your crosshairs.", true,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = true;
			end
	end
);

AddGear("[SA]Weather: Clear", "Left click to change weather to clear.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:notify("This gear requires SuperAdmin status.");
			return false;
		end
		
		
		Player:ConCommand( "ulx rcon sf_setweather clear" )

		v:notify("Weather has been changed to Clear.");
	end);
AddGear("[SA]Weather: Rain", "Left click to change weather to Rainy.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:notify("This gear requires SuperAdmin status.");
			return false;
		end
		
		
		Player:ConCommand( "ulx rcon sf_setweather rain" )

		v:notify("Weather has been changed to Rainy.");
	end);
AddGear("[SA]Weather: Foggy", "Left click to change weather to Foggy.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:notify("This gear requires SuperAdmin status.");
			return false;
		end
		
		
		Player:ConCommand( "ulx rcon sf_setweather fog" )

		v:notify("Weather has been changed to Foggy.");
	end);
AddGear("[SA]Weather: Cloudy", "Left click to change weather to Cloudy.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:notify("This gear requires SuperAdmin status.");
			return false;
		end
		
		
		Player:ConCommand( "ulx rcon sf_setweather cloudy" )

		v:notify("Weather has been changed to Cloudy.");
	end);
AddGear("[O]Weather: Radioactive", "Left click to change weather to Radioactive.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:notify("This gear requires Owner status.");
			return false;
		end
		
		
		Player:ConCommand( "ulx rcon sf_setweather radioactive" )

		v:notify("Weather has been changed to Radioactive.");
	end);
AddGear("Day Time", "Left click to change time to day.", false,
	function ( Player, Trace )
		StormFox.SetTime(480)
		v:notify("Time has been set to day time.");
	end
);
AddGear("Night Time", "Left click to change time to night.", false,
	function ( Player, Trace )
		StormFox.SetTime(1200)
		v:notify("Time has been set to night time.");

	end
);
function SWEP:Think ( )
	if self.Floater then
			local trace = {}
			trace.start = self.Floater:GetPos()
			trace.endpos = trace.start - Vector(0, 0, 100000);
			trace.filter = { self.Floater }
			local tr = util.TraceLine( trace )
		
		local altitude = tr.HitPos:Distance(trace.start);
		
		local ent = self.Spazzer;
		local vec;
		
		if self.FloatSmart then
			local trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)
			trace.filter = { self.Owner, self.Weapon }
			local tr = util.TraceLine( trace )
			
			vec = trace.endpos - self.Floater:GetPos();
		else
			vec = Vector(0, 0, 0);
		end
		
		if altitude < 150 then
			if vec == Vector(0, 0, 0) then
				vec = Vector(0, 0, 25);
			else
				vec = vec + Vector(0, 0, 100);
			end
		end
		
		vec:Normalize()
		
		if self.Floater:IsPlayer() then
			local speed = self.Floater:GetVelocity()
			self.Floater:SetVelocity( (vec * 1) + speed)
		else
			local speed = self.Floater:GetPhysicsObject():GetVelocity()
			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 20), 10, 20)) + speed)
		end

	end
end

 // Draw the Crosshair
 local chRotate = 0;
 function SWEP:DrawHUD( )
 if (!CLIENT) then return; end
	 //local godstickCrosshair = surface.GetTextureID("gui/faceposer_indicator");
	 local trace = self.Owner:GetEyeTrace();
	 local x = (ScrW()/2);
	 local y = (ScrH()/2);
					
		if IsValid(trace.Entity) then
			draw.WordBox( 8, 8, 10, "Target: " .. tostring(trace.Entity), "CoolvectiaSpeed", Color(50,50,75,100), Color(255,0,0,255) );
			surface.SetDrawColor(255, 0, 0, 255);
			chRotate = chRotate + 8;
		else
			draw.WordBox( 8, 8, 10, "Target: " .. tostring(trace.Entity), "CoolvectiaSpeed", Color(50,50,75,100), Color(255,255,255,255) );
			surface.SetDrawColor(255, 255, 255, 255);
			chRotate = chRotate + 3;
		end
		
		//surface.SetTexture(godstickCrosshair);
		//surface.SetDrawColor(255, 255, 255, 180);
		//surface.DrawTexturedRectRotated(x, y, 64, 64, 0 + chRotate);
		
		
 end
 
 function MonitorWeaponVis ( )
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() and IsValid(v:GetActiveWeapon()) then
			local pr, pg, pb, pa = v:GetColor();
			local wr, wg, wb, wa = v:GetActiveWeapon():GetColor();
			
			if pa == 0 and wa == 255 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 0);
			elseif pa == 255 and wa == 0 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 255);
			end
		end
		
		/*
		if v:InVehicle() and v:GetVehicle().CanFly then
			local t, r, a = v:GetVehicle();
			
			if ValidEntity(t) then
				local p = t:GetPhysicsObject();
				a = t:GetAngles();
				r = 180 * ((a.r-180) > 0 && 1 or -1) - (a.r - 180);
				p:AddAngleVelocity(p:GetAngleVelocity() * -1 + Angle(a.p * -1, 0, r));
			end
		end
		*/
	end
 end
 hook.Add('Think', 'MonitorWeaponVis', MonitorWeaponVis);
 
 function MonitorKeysForFlymobile ( Player, Key )
	if Player:InVehicle() and Player:GetVehicle().CanFly then
		local Force;
		
		if Key == IN_ATTACK then
			Force = Player:GetVehicle():GetUp() * 450000;
		elseif Key == IN_ATTACK2 then
			Force = Player:GetVehicle():GetForward() * 100000;
		end
		
		if Force then
			Player:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
		end
	end
 end
 hook.Add('KeyPress', 'MonitorKeysForFlymobile', MonitorKeysForFlymobile);
 
 if SERVER then
	  function GodSG ( Player, Cmd, Args )
			Player:GetTable().CurGear = tonumber(Args[1]);
	  end
	  concommand.Add('god_sg', GodSG);
 end
 
 timer.Simple(.5, function () GAMEMODE.StickText = Gears[1][1] .. ' - ' .. Gears[1][2] end);
 
  /*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()	
		if SERVER then return false; end
		
		local MENU = DermaMenu()
		
		for k, v in pairs(Gears) do
			local Title = v[1];
			
			if v[3] then
				Title = "[SA] " .. Title;
			end
			
			MENU:AddOption(Title, 	function()
										RunConsoleCommand('god_sg', k) 
										LocalPlayer():PrintMessage(HUD_PRINTTALK, v[2]);
										GAMEMODE.StickText = v[1] .. ' - ' .. v[2];
									end )
		end
		
		MENU:Open( 100, 100 )	
		timer.Simple( 0, function() gui.SetMousePos(110, 110 ) end)
	
  end 
  
 /*function TryRevive ()
	//if !LocalPlayer():IsSuperAdmin() then return false; end
	
	local EyeTrace = LocalPlayer():GetEyeTrace();
	
 			for k, v in pairs(player.GetAll()) do
				if !v:Alive() then
					for _, ent in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do						
						if ent == v:GetRagdollEntity() then
							RunConsoleCommand('perp_m_h', v:UniqueID());
							LocalPlayer():PrintMessage(HUD_PRINTTALK, "Player revived.");
							return;
						end
					end
				end
			end
 end
 usermessage.Hook('god_try_revive', TryRevive);