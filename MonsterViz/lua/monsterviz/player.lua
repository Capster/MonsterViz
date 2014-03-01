local Tag = "MonsterViz"

local floor			= 	math.floor
local abs			=	math.abs
local round			= 	math.Round
local fmod			=	math.fmod
local ceil			=	math.ceil
local insert		= 	table.insert
local rand 			= 	math.Rand
local randtbl		=	table.Random
local hook 			= 	hook
local SetDrawColor	= 	surface.SetDrawColor
local DrawRect		= 	surface.DrawRect
local SetFont		= 	surface.SetFont
local DrawText		= 	surface.DrawText
local GetTextSize	= 	surface.GetTextSize
local SetTextPos	= 	surface.SetTextPos
local SetTextColor	= 	surface.SetTextColor
local SetTexture	= 	surface.SetTexture
local CreateFont	=	surface.CreateFont
local GetTextureID	=	surface.GetTextureID
local sin,cos,rad 	= 	math.sin,math.cos,math.rad
local DrawPoly 		= 	surface.DrawPoly
local TexRect		=	surface.DrawTexturedRect
local pairs			= 	pairs
local print			=	print
local MsgC			= 	MsgC
local Color			= 	Color
local ScrW			= 	ScrW
local ScrH			= 	ScrH
local CreateStream	= 	BASS.StreamFileURL
local TKR			=	MonsterViz.TableKeyRandom
local smooth		=	MonsterViz.Smooth
local sensivity 	= 	1000
local smoothing		=	15
local Add 			= 	concommand.Add
local GenerateTable = 	MonsterViz.GenerateTable
local DrawLines		=	MonsterViz.DrawLines

CreateFont( Tag, {
	font = "Impact",
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

CreateFont( Tag.."Big", {
	font = "Futura Hv BT",
	size = 75,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

CreateFont( Tag.."Big_desk", {
	font = "Futura Hv BT",
	size = 40,
	weight = 50,
	blursize = 0,
	scanlines = 0,
} )


function MonsterViz:Draw(tabl, tabl1, channel, curcolor, curtrackname, curtrack)

	local lvl = channel:GetLevel()
	
	MonsterViz.Modules.Space:Draw(lvl)
	MonsterViz.Modules.Smoke:Draw(lvl)
	channel:fft256(tabl1)

	SetTexture (-1)
	for k,v in pairs(tabl1) do
		tabl[k]=smooth(v*sensivity,(tabl[k] or 0), smoothing) 
	end

	SetDrawColor(curcolor)


	DrawLines(12,5,ScrW()/2,ScrH()/2,GenerateTable(tabl,10,6))

	local str=MonsterViz.ConvertTime(round(channel:GetTime()))..' / '..MonsterViz.ConvertTime(round(channel:GetLength()))
	SetFont(Tag)
	local w,h = GetTextSize(str)
	SetTextPos(ScrW() - w - 85,ScrH()/2 + 5)
	SetTextColor(255,255,255)
	DrawText(str)
	
	SetFont(Tag.."Big")
	local w,_h = GetTextSize(curtrack.autor)
	SetTextPos(100 ,ScrH()/2 + 5)
	SetTextColor(255,255,255)
	DrawText(curtrack.autor or "UNKNOWN")
	
	SetFont(Tag.."Big_desk")
	local w,h = GetTextSize(curtrackname)
	SetTextPos(100 ,ScrH()/2 + _h)
	SetTextColor(255,255,255)
	DrawText(curtrackname or "UNKNOWN")
	
end


Add("mv_stop", function()
	Msg"[MonsterViz] " MsgC(color_white, "Stopping Current Stream\n")
	CurChannel:Remove()
end)

local function HOOK(type, func)
	hook.Add(type, Tag, func)
end

local function UNHOOK(type)
	hook.Remove(type, Tag)
end

local curtrackname, curtrack = TKR(MonsterViz.TrackList)

CreateStream(curtrack.url,

	function(channel, err)
		
		if(channel) then
		
			channel:Play()
			CurChannel = channel
			
			Msg"[MonsterViz] " MsgC(color_white, "Now playing: "..channel:GetFilename() .. "\n")
			local curcolorname, curcolor = TKR(MonsterViz.Colors)
			
			if MonsterViz.DEVMODE then
				Msg"[MonsterViz] " MsgC(color_white, "Current visualizer color is " .. curcolorname .. "\n")
			end
			
			local tabl, tabl1 = {}, {}
			--channel:SetVolume(1)
			
			MonsterViz.Modules.Space:Init()
			
			for i = 0,35 do
				MonsterViz.Modules.Smoke:Init()
			end
			HOOK("HUDShouldDraw", function(item)
				if(item == "CHudHealth") or (item == "CHudBattery") then
					return false
				end
			end)
			
			HOOK("HUDPaint", function()
				
				MonsterViz:Draw(tabl, tabl1, channel, curcolor, curtrackname, curtrack)
				
				if !channel:IsPlaying() or input.IsKeyDown(KEY_HOME) then
					UNHOOK("HUDPaint")
					UNHOOK("HUDShouldDraw")
					return channel and channel:Remove()
				end
				
			end )

			
		end

	end, 
	
	true
	
)