if (SERVER) then

	util.AddNetworkString( "OpenEventMenu" )
	util.AddNetworkString( "SetEventString" )
	util.AddNetworkString( "SetEventColor" )



	concommand.Add( "vision_events", function( ply )

		if !ply:IsAdmin() then return end

		net.Start("OpenEventMenu")
		net.Send( ply )

	end)

	net.Receive( "SetEventString", function( um, ply )
		if !ply:IsAdmin() then return end
		EventName = net.ReadString()
		net.Start( "SetEventString" )
			net.WriteString( EventName )
		net.Broadcast()
	end)

	net.Receive( "SetEventColor", function( um, ply )
		if !ply:IsAdmin() then return end
		EventColor = net.ReadTable()
		net.Start( "SetEventColor" )
			net.WriteTable( EventColor )
		net.Broadcast()
	end)

	hook.Add( "PlayerInitialSpawn", "qsdqsd", function( ply ) 
		timer.Simple( 1, function() 
			if !IsValid( ply ) then return end 

			net.Start( "SetEventString" )
				net.WriteString( EventName )
			net.Send( ply )

			net.Start( "SetEventColor" )
				net.WriteTable( EventColor )
			net.Send( ply )

		end)
	end)


	hook.Add("PlayerSay", "VisionEventMenuChatCommand", function(ply, text, teamonly)
	if text == "!event" then
		net.Start("OpenEventMenu")
		net.Send(ply)
	return ""
	end
	end)

end


if (CLIENT) then

	surface.CreateFont("VEvents_HUDTitle", { font = "bebasneue", size = 30})
	surface.CreateFont("VEvents_HUDStatus", { font = "bebasneue", size = 27})
	surface.CreateFont("VEvents_DERMATitle", { font = "bebasneue", size = 27})
	surface.CreateFont("VEvents_DERMATyping", { font = "bebasneue", size = 23})
	surface.CreateFont("VEvents_DERMACredits", { font = "bebas neue", size = 8})

	local frameWidth = 450
	local frameHeight = 235

	local VcolorShownEvent = Color(0,175,175,255)
	local sentthetingstringv = "Normal Duties"

	local function VisionEventsDerma()

	    local frameEvents = vgui.Create( "DFrame" )
	    frameEvents:SetPos( 0, 0 )
	    frameEvents:SetSize( frameWidth, frameHeight )
	    frameEvents:SetTitle( "" )
	    frameEvents:SetVisible( true )
	    frameEvents:Center()
	    frameEvents:SetDraggable( true )
	    frameEvents:SetMouseInputEnabled(true)
	    frameEvents:ShowCloseButton( false )
	    frameEvents:MakePopup()
	    frameEvents.Paint = function()
	    	draw.RoundedBox( 0, 0, 0, frameWidth, frameHeight, Color(35,35,35,235))
	    	draw.RoundedBox( 0, 0, 0, frameWidth, 25, Color(0,150,150,255))
	    	draw.DrawText( "Vision Event Menu", "VEvents_DERMATitle", 5, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	    	draw.DrawText( "Enter the Event Status Text Below\nRemember to set it back once done", "VEvents_DERMATyping", 121, 45, color, TEXT_ALIGN_CENTER)
	    	draw.SimpleTextOutlined( "DEVELOPED BY DERPES", "DebugFixed", 60, 221, Color(255,255,255,255), 0, 2, 1, Color(0,0,0,255))
		end

		local eventframeclose = vgui.Create('DButton', frameEvents)
	    eventframeclose:SetFont('VEvents_DERMATitle')
	    eventframeclose:SetText('X')
	    eventframeclose:SetColor(Color(255,255,255,255))
	    eventframeclose:SetSize(60, 25)
	    eventframeclose:SetDrawBackground(true)
	    eventframeclose:SetPos( frameEvents:GetWide()-60, 0)
	    eventframeclose.DoClick = function()
	        frameEvents:Remove()
	    end
	    if eventframeclose:IsHovered() then
	   		VEventCloseHover = Color(180,0,0,255)
		else
			VEventCloseHover = Color(230,0,0,255)
		end
	    eventframeclose.Paint = function()
	        surface.SetDrawColor(VEventCloseHover)
	        surface.DrawRect(0, 0, eventframeclose:GetWide() + 5, eventframeclose:GetTall() + 5)
	    end


	    local RGBSetEventColour = vgui.Create( "DColorMixer", frameEvents )
	    RGBSetEventColour:SetPos( frameEvents:GetWide()-205, 30 )
	    RGBSetEventColour:SetSize( 200, 200 )
	    RGBSetEventColour.ValueChanged = function( self, color )
	    	net.Start( "SetEventColor" )
	            net.WriteTable(color)
	        net.SendToServer()
	    end
    
	    local SetEventString = vgui.Create("DTextEntry", frameEvents)
	    SetEventString:SetPos( 20,frameEvents:GetTall()/2-20 )
	    SetEventString:SetSize( 200, 55 )
	    SetEventString:SetFont("VEvents_DERMATitle")
	    SetEventString.MaxChars = 30

	    local SubmitSetVEventStatus = vgui.Create( "DButton", frameEvents )
	    SubmitSetVEventStatus:SetText( "APPLY TEXT" )
	    SubmitSetVEventStatus:SetFont("VEvents_DERMATyping")
	    SubmitSetVEventStatus:SetTextColor( Color( 255, 255, 255 ) )
	    SubmitSetVEventStatus:SetPos( 75, 170 )
	    SubmitSetVEventStatus:SetSize( 100, 30 )
	    SubmitSetVEventStatus.Paint = function()
	    if SubmitSetVEventStatus:IsHovered() then
	   		VEventButtonColor = Color(0,110,110,255)
		else
			VEventButtonColor = Color(0,150,150,255)
		end
	    	draw.RoundedBox( 0, 0, 0, SubmitSetVEventStatus:GetWide(), SubmitSetVEventStatus:GetTall(), Color(0,150,150,255))
		end
	    SubmitSetVEventStatus.DoClick = function()
	       	net.Start( "SetEventString" )
	            net.WriteString(SetEventString:GetValue())
	        net.SendToServer()

	    end

	end
	net.Receive("OpenEventMenu", VisionEventsDerma)

	local function VisionEventsHUD()

	    if GetConVarNumber("vrphud_toggle")  == 1 then
	        draw.SimpleTextOutlined( "Event Status", "VEvents_HUDTitle", ScrW()/2, 75, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
	        draw.SimpleTextOutlined( sentthetingstringv, "VEvents_HUDStatus", ScrW()/2, 98, VcolorShownEvent, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
	    end

	end
	hook.Add("HUDPaint", "VisionEventsHUD", VisionEventsHUD)

	local function SetEventString()

		sentthetingstringv = net.ReadString()

	end
	net.Receive( "SetEventString", SetEventString )

	local function SetEventColor()

		VcolorShownEvent = net.ReadTable()

	end
	net.Receive( "SetEventColor", SetEventColor )

end