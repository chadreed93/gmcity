// GO IN "items/randomitem/" TO ADD BOXES

ITEM.name = "Random Item"
ITEM.desc = "A random item."
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.category = "Pockets surprises"

ITEM.randomItems = {}

ITEM.functions.use = {
	name = "Open",
	tip = "useTip",
	icon = "icon16/heart_add.png",
	onRun = function(item)
		
		local chance = 1
		
		while (chance <= #item.randomItems) do
			local chanceNumber = math.random(0, 100)
			
			if (chanceNumber <= 25 or chanceNumber >= 75) then
				chance = chance + 1
			else
				break
			end
			
		end
		
		local itm = item.randomItems[chance][math.random(#item.randomItems[chance])]
		
		local itmObject = nut.item.list[itm]
		
		if item:getOwner():getChar():getInv():findEmptySlot(itmObject.width, itmObject.height) then
			item:getOwner():getChar():getInv():add(itm, 1)
			return true
		else
			item:getOwner():notify(L("noSpace"))
		end
		
		return false
		
	end
}