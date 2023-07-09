--[[	By Novikond
	Activate SaraTools by putting this thing on top of any script:
	local saraTools = require('saraTools')
]]

draw = {}
effect = {}

draw.text = function(tag, text, width, x, y, alignment, camera, size, color, borderSize, borderColor, antial, font)
	makeLuaText(tag, text, width, x, y)
	setTextAlignment(tag, alignment or 'left')
	setObjectCamera(tag, camera or 'hud')
	setTextSize(tag, size or 20)
	setTextColor(tag, color or 'ffffff')
	if borderSize or borderColor then setTextBorder(tag, borderSize or 2, borderColor or '000000') end
	setProperty(tag .. '.antialiasing', antial or true)
	setTextFont(tag, font or 'vcr.ttf')
	setObjectOrder(tag, getObjectOrder('healthBar') + 100)
	addLuaText(tag, true)
end

draw.sprite = function(tag, image, x, y, camera, sizeX, sizeY, isAnimated)
	if not isAnimated then makeLuaSprite(tag, image, x, y) 
	else makeAnimatedLuaSprite(tag, image, x, y) end
	setObjectCamera(tag, camera or 'hud')
	if sizeX or sizeY then setGraphicSize(tag, sizeX, sizeY) end
	setObjectOrder(tag, getObjectOrder('healthBar') + 100)
	addLuaSprite(tag, true)
end

draw.graphic = function(tag, x, y, width, height, color, camera)
	makeLuaSprite(tag, nil, x, y)
	makeGraphic(tag, width, height, color or '000000')
	setObjectCamera(tag, camera or 'hud')
	addLuaSprite(tag, true)
end

effect.blink = function(tag, color, speed, ease)
	setProperty(tag .. '.color', getColorFromHex(color))
	doTweenColor(tag .. '-effect-blink', tag, 'ffffff', (speed or 0.2) / playbackRate, ease or 'linear')
end

effect.bop = function(tag, scaleX, scaleY, speed, ease)
	setProperty(tag .. '.scale.x', scaleX)
    setProperty(tag .. '.scale.y', scaleY)
    doTweenX(tag .. '-effect-bop-x', tag .. '.scale', 1, (speed or 0.2) / playbackRate, ease or 'linear')
    doTweenY(tag .. '-effect-bop-y', tag .. '.scale', 1, (speed or 0.2) / playbackRate, ease or 'linear')
end

effect.shift = function(tag, moveX, moveY, isAllowed, speed, ease)
	if isAllowed then og = {x = getProperty(tag..'.x'), y = getProperty(tag..'.y')} end
	setProperty(tag .. '.x', og.x + moveX)
	setProperty(tag .. '.y', og.y + moveY)
	doTweenX(tag .. '-effect-shift-x', tag, og.x, (speed or 0.2) / playbackRate, ease or 'linear')
	doTweenY(tag .. '-effect-shift-y', tag, og.y, (speed or 0.2) / playbackRate, ease or 'linear')
end

function switch(case_table)
   return function(case_val)
      	local case_fn = case_table[case_val] or case_table.def
      	if case_fn then return case_fn() end
   	end
end

function formatTime(millisecond)
    local seconds = math.floor(millisecond / 1000)
    return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60)  
end

return draw, effect