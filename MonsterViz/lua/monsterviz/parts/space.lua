local floor			= 	math.floor
local insert		= 	table.insert
local rand 			= 	math.Rand
local SetDrawColor	= 	surface.SetDrawColor
local DrawRect		= 	surface.DrawRect
local DrawPoly 		= 	surface.DrawPoly
local TexRect		=	surface.DrawTexturedRect
local pairs			= 	pairs
local Color			= 	Color
local ScrW			= 	ScrW
local ScrH			= 	ScrH
local DFC			= 	MonsterViz.DrawFilledCircle

PART.Name 	= "Space"
PART.Autor 	= "Condarnad"

function PART:Init()
	Space = {}
	for i =  0, 350 do
		local y,y1=rand(150,ScrH()-150),rand(0,ScrH())
		insert(Space, {
		x 			= rand(0,ScrW()),
		y 			= y,
		size	 	= rand(1,1.5),
		offset	= y>y1 and y1/ScrW() or -y1/ScrW(),
		speed 	= rand(0.3,0.5),
		color 	= Color(0xFF,0xFF,0xFF,rand(20,100))})
	end
end

local function generate_dot(element)
	local y,y1=rand(150,ScrH()-150),rand(0,ScrH())
	Space[element]= {
		x 			= 0,
		y 			= y,
		size 		= rand(1,1.5),
		offset	= y>y1 and y1/ScrW() or -y1/ScrW(),
		speed 	= rand(0.3,0.5),
		color 	= Color(0xFF,0xFF,0xFF,rand(20,100))}
end

function PART:Draw(lvl)

	SetDrawColor(MonsterViz.GreenScreen and MonsterViz["Green Screen"] or color_black)
	DrawRect(0,0,ScrW(), ScrH())
	for k, v in pairs(Space) do
		
		if v.x>ScrW() or v.y>ScrH() or v.color.a<20 then
			generate_dot(k)
		end
		
		if floor(rand(1,20))==4 then
			v.color.a=v.color.a-0.05
		end
		
		
		
		SetDrawColor(v.color)	
		
		DFC(v.x, v.y, v.size, 20)
		
		v.x = v.x + v.speed*lvl
		v.y = v.y + v.offset*lvl*v.speed
		
	end
	--SMOKE:DrawSmoke(lvl)
end

