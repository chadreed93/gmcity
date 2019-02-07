nut.chat.register("gpda", {
	format = "[G-PDA] %s: \"%s\"",
	color = Color(144, 238, 144),
	filter = "pda",
	onCanHear = function(speaker, listener)
		if (nut.config.get("pdaNetwork")) then
			local inv = (listener:getChar() and listener:getChar():getInv() or nil);

			if (inv) then
				pdaItem = inv:hasItem("pda");
				if (pdaItem and pdaItem:getData("power", false)) then
					return true
				end
			end	
		end

		return false
	end,
	onCanSay = function(speaker, text)
		if (nut.config.get("pdaNetwork")) then
			local inv = (speaker:getChar() and speaker:getChar():getInv() or nil);

			if (inv) then
				pdaItem = inv:hasItem("pda");
				if (pdaItem) then
					if (pdaItem:getData("power", false)) then
						speaker:EmitSound("ambient/machines/keyboard"..math.random(1, 6).."_clicks.wav", math.random(50, 60), math.random(80, 120));
						return true
					else
						speaker:notifyLocalized("cpdapowerneeded");	
					end
				else
					speaker:notifyLocalized("cpdaneeded");
				end
			end
		else
			speaker:notifyLocalized("cpdanetworkneeded");	
		end

		return false
	end,
	prefix = {"/gpda"},
})

nut.chat.register("pda", {
	format = "[PDA] %s: %s.",
	color = Color(192, 192, 192),
	deadCanChat = false,
	onCanSay = function(speaker, text)
		if (nut.config.get("pdaNetwork")) then
			local inv = (speaker:getChar() and speaker:getChar():getInv() or nil);

			if (inv) then
				pdaItem = inv:hasItem("pda");
				if (pdaItem) then
					if (pdaItem:getData("power", false)) then
						speaker:EmitSound("ambient/machines/keyboard"..math.random(1, 6).."_clicks.wav", math.random(50, 60), math.random(80, 120));
						return true
					else
						speaker:notifyLocalized("cpdapowerneeded");	
					end
				else
					speaker:notifyLocalized("cpdaneeded");
				end
			end
		else
			speaker:notifyLocalized("cpdanetworkneeded");	
		end

		return false
	end
})

nut.command.add("pda", {
	syntax = "<string target> <string message>",
	onRun = function(client, arguments)
		local message = arguments[2]
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local voiceMail = target:getNutData("vm")

			if (voiceMail and voiceMail:find("%S")) then
				return target:Name()..": "..voiceMail
			end

			if ((client.nutNextPM or 0) < CurTime()) then
				nut.chat.send(client, "pda", message, false, {client, target})

				client.nutNextPM = CurTime() + 0.5
				target.nutLastPM = client
			end
		end
	end
})