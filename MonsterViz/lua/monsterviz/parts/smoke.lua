local SetDrawColor	= 	surface.SetDrawColor
local SetTexture	= 	surface.SetTexture
local GetTextureID	=	surface.GetTextureID
local TexRectRot	=	surface.DrawTexturedRectRotated

PART.Name 	= "Smoke"
PART.Autor 	= "Capster"
PART.Smokes = {}

local sprites =
{
	GetTextureID("particles/smokey"),
}

function PART:Init()

	local size = math.Rand(ScrW()/5, ScrW())
	table.insert(self.Smokes,{
		tex = table.Random(sprites),
		x 	= math.Rand(0, ScrW()/3),
		y 	= math.Rand(0, ScrH()),
		w 	= size,
		h 	= size,
		a	= 0,
	})
	
end
		
function PART:Draw(lvl)
	for k, v in pairs(self.Smokes) do
		SetDrawColor(Color(50,50,50,23))
		SetTexture(v.tex)
		TexRectRot(v.x, v.y, v.w, v.h, v.a)
		v.x = v.x + lvl
		v.y = v.y + math.Rand(lvl, -lvl)
		v.a = v.a + math.Rand(lvl, -lvl)
		if v.x>ScrW() or v.y>ScrH()/3 then
			self:Init()
			table.remove(self.Smokes, k)
		end
	end
end