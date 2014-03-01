include ("monsterviz/monsterviz.lua")

local add = concommand.Add

add("mv_reload", function()
	print("reloaded")
	include ("monsterviz/monsterviz.lua")
end)
