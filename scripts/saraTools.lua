--[[	By Novikond
	Activate SaraTools by putting this thing on top of any script:
	local saraTools = require('saraTools')
]]

draw = {}
effect = {}
util = {}

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

effect.blink = function(tag, color, speed, easeType)
	setProperty(tag .. '.color', getColorFromHex(color))
	doTweenColor(tag .. '-effect-blink', tag, 'ffffff', (speed or 0.2) / playbackRate, easeType or 'linear') -- not using startTween() here cuz buggy
end

effect.alpha = function(tag, alphaFrom, alphaTo, speed, easeType)
	setProperty(tag .. '.alpha', alphaFrom)
	startTween(tag .. '-effect-alpha', tag, {alpha = alphaTo}, (speed or 0.2) / playbackRate, {ease = easeType or 'linear'})
end

effect.bop = function(tag, scaleX, scaleY, speed, easeType)
	setProperty(tag .. '.scale.x', scaleX)
    setProperty(tag .. '.scale.y', scaleY)
	startTween(tag .. '-effect-bop-x', tag .. '.scale', {x = 1}, (speed or 0.2) / playbackRate, {ease = easeType or 'linear'})
	startTween(tag .. '-effect-bop-y', tag .. '.scale', {y = 1}, (speed or 0.2) / playbackRate, {ease = easeType or 'linear'})
end

effect.shift = function(tag, ogX, ogY, moveX, moveY, speed, easeType)
	setProperty(tag .. '.x', ogX + moveX)
	setProperty(tag .. '.y', ogY + moveY)
	startTween(tag .. '-effect-shift-x', tag, {x = ogX}, (speed or 0.2) / playbackRate, {ease = easeType or 'linear'})
	startTween(tag .. '-effect-shift-y', tag, {y = ogY}, (speed or 0.2) / playbackRate, {ease = easeType or 'linear'})
end

util.switch = function(case_table)
   return function(case_val)
      	local case_fn = case_table[case_val] or case_table.def
      	if case_fn then return case_fn() end
   	end
end

util.formatTime = function(millisecond)
    local seconds = math.floor(millisecond / 1000)
    return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60) 
end

util.floorDecimal = function(value, decimals) -- port of `CoolUtil.floorDecimal` to lua
    if decimals < 1 then return math.floor(value) end

    local tempMult = 1
    for i = 1, decimals do tempMult = tempMult * 10 end

    local newValue = math.floor(value * tempMult)
    return newValue / tempMult
end

util.traceHealthBar = function(obj, direction, offset)
	local hp = getProperty('healthBar.percent') * (getProperty('healthBar.width') / 100)
	local the = (getProperty('healthBar.' .. direction) + getProperty('healthBar.width') - hp)
	setProperty(obj .. '.' .. direction, the - offset)
end

return draw, effect, util