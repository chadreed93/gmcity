CLASS.name = "Police Officer"
CLASS.faction = FACTION_LAW
CLASS.salary = 300
CLASS.vote = true
CLASS.law = true
CLASS.weapons = {
	"weapon_bf3_1911",
	"nut_stunstick",
	"nut_arrestbaton",
	"keypad_cracker",
	"nut_taser",
}
CLASS.business = {
	["doorcharge"] = 1,
	["teargas"] = 1,
	["tie"] = 1,
	
--	["bg_wf_p226_silencer"] = 1,
	--["bg_wf_p226_rds"] = 1,
}
CLASS.limit = 6
CLASS.team = 1
CLASS.color = Color(25, 25, 170)
CLASS.model = {
	"models/taggart/police01/male_01.mdl",
	"models/taggart/police01/male_02.mdl",
	"models/taggart/police01/male_03.mdl",
	"models/taggart/police01/male_04.mdl",
	"models/taggart/police01/male_05.mdl",
	"models/taggart/police01/male_06.mdl",
	"models/taggart/police01/male_07.mdl",
	"models/taggart/police01/male_08.mdl",
	"models/taggart/police01/male_09.mdl"
}

function CLASS:onSet(client)
	for k, v in ipairs(self.weapons) do
		client:Give(v)
	end
end

CLASS_POLICE = CLASS.index