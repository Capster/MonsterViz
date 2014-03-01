if CurChannel then CurChannel:Remove() end

require("bass2")

MonsterViz.DEVMODE 				= true
MonsterViz.GreenScreen 			= false
MonsterViz["Green Screen"] 		= Color(0x00, 0xFF, 0x00)


include("monsterviz/utils.lua")
include("monsterviz/tracklist.lua")
include("monsterviz/colors.lua")

MonsterViz.Modules = {} 

local files, _ = file.Find("lua/monsterviz/parts/*.lua", "GAME")

for k,v in pairs(files) do

	PART = {}
	
	PART.Name = "Unknown"
	PART.Autor = "Unknown"
	
	include("monsterviz/parts/"..v)
	
	MonsterViz.Modules[PART.Name] = PART
	
end


include("monsterviz/player.lua")


