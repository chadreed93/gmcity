-- The 'nice' name of the faction.
FACTION.name = "Criminal"
-- This faction is default by the server.
-- This faction does not requires a whitelist.
FACTION.isDefault = true
-- A description used in tooltips in various menus.
FACTION.desc = "The ones devoted to doing dark and criminal activities."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(155, 155, 15)
-- The list of models of the citizens.
-- Only default citizen can wear Advanced Citizen Wears and new facemaps.
local CITIZEN_MODELS = {
	"models/player/zelpa/female_01_b_extended.mdl",
	"models/player/zelpa/female_02_b_extended.mdl",
	"models/player/zelpa/female_03_b_extended.mdl",
	"models/player/zelpa/female_04_b_extended.mdl",
	"models/player/zelpa/female_06_b_extended.mdl",
	"models/player/zelpa/female_07_b_extended.mdl",
	"models/player/zelpa/female_01_b_extended.mdl",
	"models/player/zelpa/female_02_b_extended.mdl",
	"models/player/zelpa/female_03_b_extended.mdl",
	"models/player/zelpa/female_04_b_extended.mdl",
	"models/player/zelpa/female_06_b_extended.mdl",
	"models/player/zelpa/female_07_b_extended.mdl",
	"models/player/zelpa/male_01_extended.mdl",
	"models/player/zelpa/male_02_extended.mdl",
	"models/player/zelpa/male_03_extended.mdl",
	"models/player/zelpa/male_04_extended.mdl",
	"models/player/zelpa/male_05_extended.mdl",
	"models/player/zelpa/male_06_extended.mdl",
	"models/player/zelpa/male_07_extended.mdl",
	"models/player/zelpa/male_08_extended.mdl",
	"models/player/zelpa/male_09_extended.mdl",
	"models/player/zelpa/male_10_extended.mdl",
	"models/player/zelpa/male_11_extended.mdl",
}
FACTION.models = CITIZEN_MODELS
-- The amount of money citizens get.
FACTION.salary = 300
-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_CITIZEN = FACTION.index
