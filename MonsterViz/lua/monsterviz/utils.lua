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

function MonsterViz.DrawFilledCircle(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
    for i=1,quality do
        tmp = rad(i*360)/quality
        circle[i] = {x = x + cos(tmp)*radius,y = y + sin(tmp)*radius};
    end
    DrawPoly(circle)
end


function MonsterViz.Smooth(new,old,sp)
	local new,old=(new or 0),(old or 0)
    if new>old then
        new=old+(new-old)/sp
    else
        new=old-(old-new)/sp
    end
    return new
end

local smooth = MonsterViz.Smooth

function MonsterViz.GenerateTable(tbl,count,count2)

	local c=count*(count2+1)+count2
	local tbl2={}

	for i=1,c do
		if fmod(i,count2+1)==0 then
			tbl2[i]=tbl[round(i/count2)]
		end
	end
	
	for i=1,c do
		if fmod(i,count2+1)!=0 then
				tbl2[i]=smooth(tbl2[i-1],tbl2[ceil(i/(count2+1))*(count2+1)],2)
		end
	end
	
	for i=1,c do
		for j=1,4 do
			tbl2[i+1]=smooth(tbl2[i],tbl2[i+1],1+j*0.5)
		end
	end
	
	return c,tbl2
end


function MonsterViz.ConvertTime(num)
	
	local mins=floor(num/60)
	local hours=0
	local str=''
	if mins>=60 then
		hours=floor(mins/60)
		mins=mins-hours*60
	end
	local secs=num-hours*60*60-mins*60
	if hours<10 then str="0"..hours else str=""..hours end
	if mins<10 then str=str..":0"..mins else  str=str..":"..mins end
	if secs<10 then str=str..":0"..secs else  str=str..":"..secs end
	return str
	
end

function MonsterViz.TableKeyRandom(tbl)
	local rnd = randtbl(tbl)
	for k, v in pairs(tbl) do
		if v == rnd then
			return k, rnd
		end
	end
end

function MonsterViz.DrawLines(w,w2,posx,posy,count,tbl)
	for k,v in pairs(tbl) do
		if k<=count then

			DrawRect(posx-(count/2)*(w+w2)+k*(w+w2),posy-v+1,w,v+1)
			
		end
	end
end