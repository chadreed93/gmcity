include( 'shared.lua' )
 
ENT.RenderGroup = RENDERGROUP_BOTH
 
function ENT:Draw()
    self:DrawModel()

	local offset = Vector( 0, 0, 85 )

	local ang = self:GetAngles()
	local pos = self:GetPos() + offset + ang:Up()

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	cam.Start3D2D(Pos + Ang:Right() * -26 + Ang:Up() * 10, Ang, 0.2)
		draw.SimpleTextOutlined("-VIP + Forums-", "Akbar", 0, 0, Color(0, 180, 0, 255), 1, 1, 1, Color(0, 0, 0, 255) );
		draw.SimpleTextOutlined("Press E" .. self.dt.price, "Akbar", 0, 35, Color(0, 180, 0, 255), 1, 1, 1, Color(0, 0, 0, 255) );
	cam.End3D2D()

end

local function openPaypal()
	local DonateMenu = vgui.Create( "DFrame" )
	DonateMenu:SetPos( ScrW() / 2 - 200, ScrH() / 2 - 145 )
	DonateMenu:SetSize( 425, 150 )
	DonateMenu:SetTitle( "Donate Info" )
	DonateMenu:SetVisible( true )
	DonateMenu:SetDraggable( true )
	DonateMenu:ShowCloseButton( true )
	DonateMenu:MakePopup()
	DonateMenu.Paint = function()
		draw.RoundedBox( 8, 0, 0, DonateMenu:GetWide(), DonateMenu:GetTall(), Color( 51, 204, 255, 105 ) )
	end

	local html = vgui.Create( "HTML", DonateMenu )
	html:OpenURL( "http://insanityrp.com/npc.jpg" )
	html:SetPos( 0, 25 )
	html:SetSize( DonateMenu:GetWide(), DonateMenu:GetTall() )

	local vipSite = vgui.Create( "DButton", DonateMenu )
	vipSite:SetSize( 80, 30 )
	vipSite:SetPos( 20, 110 )
	vipSite:SetText( "Buy VIP" )
	vipSite.DoClick = function()
		gui.OpenURL( "http://www.insanityrp.com/index.php?topic=10.msg14#msg14" )
	end

	local vipSite = vgui.Create( "DButton", DonateMenu )
	vipSite:SetSize( 80, 30 )
	vipSite:SetPos( 320, 110 )
	vipSite:SetText( "Forums" )
	vipSite.DoClick = function()
		gui.OpenURL( "http://www.insanityrp.com/" )
	end
end

usermessage.Hook( "openPaypal", openPaypal )

