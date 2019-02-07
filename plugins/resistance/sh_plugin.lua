PLUGIN.name = "Resistance"
PLUGIN.author = "SuperMicronde"
PLUGIN.desc = "Adds a resistance attirbute."

if (SERVER) then
	
hook.Add("EntityTakeDamage", "ApplyResistAttrib", function( target, dmg )

	if (IsValid(target) && target:IsPlayer()) then

		local scale
		local char = target:getChar()

		dmg:ScaleDamage(math.max(math.Truncate(1 - (char:getAttrib("resist", 0) * 0.02), 2), 0.2 ))
		char:updateAttrib("resist", 0.1)

	end

end)

end