ITEM.name = "PDA";
ITEM.desc = "A PDA that lets you communicate with others.";
ITEM.model = "models/props_lab/reciever01d.mdl";
ITEM.category = "Electronics";
ITEM.width = 1;
ITEM.height = 1;
ITEM.price = 50;

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100);
		else
			surface.SetDrawColor(255, 110, 110, 100);
		end

		surface.DrawRect(w - 14, h - 14, 8, 8);
	end
end

ITEM.functions.toggle = {
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	onRun = function(item)
		item:setData("power", !item:getData("power", false), nil, nil);
		item.player:EmitSound("buttons/button14.wav", 70, 150);
		return false
	end,
}