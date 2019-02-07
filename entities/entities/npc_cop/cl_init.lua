include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.

surface.CreateFont("coolveticaBIG", {
	size = 20,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"})

surface.CreateFont("coolveticaSMALL", {
	size = 16,
	weight = 100,
	antialias = true,
	shadow = false,
	font = "ariel"})

function NPCShopMenu()
	local ply = LocalPlayer()

	// Main npc panel
	local npcmenu = vgui.Create("DFrame")
	npcmenu:SetSize(280, 100)
	npcmenu:SetPos(ScrW()*0.5, ScrH()*0.5)
	npcmenu:SetTitle("Cop Recuiter")
	npcmenu:SetSizable(false)
	npcmenu:SetDeleteOnClose(false)
	npcmenu:Center()
	npcmenu:SetDraggable(false)
	npcmenu:MakePopup() 
	function  npcmenu:Paint( w , h )
 					surface.SetDrawColor(17,17,17,150)
                    surface.DrawRect(0,0,w,h)
                    surface.SetDrawColor(0,100,200,255)
                    surface.DrawOutlinedRect(0,0,w,h)
	end
	// Label 
	local label1 = vgui.Create("DLabel", npcmenu)
	label1:SetPos(10,30)
	label1:SetText("Would you like to become A Cop?")
	label1:SizeToContents()
	label1:Center()
	local x, y = label1:GetPos() -- get the X and Y coordinates of the centered label
		label1:SetPos(x, 30) -- leave the horizontal X position and just edit the vertical one - this way its centered

	// Yes Button
	local ply = LocalPlayer()
	local button1 = vgui.Create("DButton", npcmenu)
	button1:SetSize(60,20)
	button1:SetText("Yes Sir!")
	button1:Center()
	button1.DoClick = function() RunConsoleCommand("givecp")
		npcmenu:Close()
	end
	local x, y = button1:GetPos() -- get the X and Y coordinates of the centered label
		button1:SetPos(60, 60) -- leave the horizontal X position and just edit the vertical one - this way its centered

	// No Button
	local button2 = vgui.Create("DButton", npcmenu)
	button2:SetSize(60,20)
	button2:SetText("Oh hell no!")
	button2:Center()
	button2.DoClick = function()
		npcmenu:Close()
	end
	local x, y = button2:GetPos() -- get the X and Y coordinates of the centered label
		button2:SetPos(160, 60) -- leave the horizontal X position and just edit the vertical one - this way its centered
end
usermessage.Hook("CopNPCUsed", NPCShopMenu) --Hook to messages from the server so we know when to display the menu.