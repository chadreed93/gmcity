CLASS.name = "S.W.A.T Member"
CLASS.faction = FACTION_CITIZEN
CLASS.salary = 400
CLASS.law = true
CLASS.weapons = {
	"weapon_bf3_1911",
	"cw_mp5",
	"nut_stunstick",
	"nut_arrestbaton",
	"keypad_cracker",
}
CLASS.business = {
	["doorcharge"] = 1,
	["teargas"] = 1,
	["tie"] = 1,
	
	["ammo_ar2"] = 1,
--	["bg_wf_p226_silencer"] = 1,
--	["bg_wf_p226_rds"] = 1,
}

CLASS.limit = 3
CLASS.team = 1
CLASS.color = Color(11, 11, 190)
CLASS.model = {
	"models/player/kerry/swat_ls_2.mdl",
	"models/player/kerry/swat_ls.mdl"
}

function CLASS:onSet(client)
	for k, v in ipairs(self.weapons) do
		client:Give(v)
	end
end

function CLASS:onCanBe(client)
	local char = client:getChar()

	return (char and char:getClass() == CLASS_POLICE)
end

CLASS_POLICEARMED = CLASS.index