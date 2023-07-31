--[[
	SaraHUD:R ver.[1.0b]
	by Novikond
]]

-- settings:
local pref = {
	statsType = 'vanilla', -- Available: 'sarahud', 'vanilla'
	skin = 'copacetic',
	
	statsBg = true,
	extraStats = false, -- wip
	
	coloredText = true,
	modifiersIcons = false, -- wip
	verticalHealthBar = false,
	
	laneUnderlay = .5,
	oppUnderlay = true,
	elementsAlpha = 1
}

local textColors = {
	{'ratingText', 'f6b7bd'},
	{'scoreText', 'b1d9f0'},
	{'missesText', 'e3b7ee'}
}
-- no more settings :pensive:

local saraTools
local shud = 'saraHUD/'..pref.skin..'/'
local statsWidth = 20

local hudStuff = {'scoreTxt', --[['timeBar', 'timeBarBG', 'timeTxt']]}
local textStuff = {'ratingText', 'scoreText', 'missesText'}
local iconStuff = {'ratingIcon', 'scoreIcon', 'missesIcon'}
local statsbgthings = {'leftRounded', 'centerBox', 'rightRounded'}
local DEFsarahud = {'left', 'hud', 16, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf'}

function getScriptDirectory()
	local info = debug.getinfo(1, "S")
	local scriptPath = info.source:sub(2)
	return scriptPath:match("(.*/)") or ""
end

function onCreate() saraTools = require(getScriptDirectory() .. 'saraTools') end

function onCreatePost()
	for i = 1, #hudStuff do setProperty(hudStuff[i] .. '.visible', false) end
	
	--draw.sprite('test', shud .. 'pracIcon', 0, 0, 'hud'); screenCenter('test')
	
	if pref.statsType == 'sarahud' then
		if pref.statsBg then
			draw.sprite('leftRounded', 'roundedSHUD', 52, downscroll and 9 or screenHeight - 118, 'hud', 18, 110)
			draw.graphic('centerBox', getProperty('leftRounded.x') + 18, getProperty('leftRounded.y'), 1, 110)
			draw.sprite('rightRounded', 'roundedSHUD', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud', 18, 110)
			setProperty('rightRounded.flipX', true)
			setProperty('leftRounded.antialiasing', false)
			setProperty('rightRounded.antialiasing', false)
			for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
		end
	
		draw.sprite('ratingIcon', shud .. 'ratingIcon', 15, downscroll and 14 or screenHeight - 45, 'hud', 32)
		draw.sprite('scoreIcon', shud .. 'scoreIcon', 15, downscroll and getProperty('ratingIcon.y') + 34 or getProperty('ratingIcon.y') - 34, 'hud', 32)
		draw.sprite('missesIcon', shud .. 'missesIcon', 15, downscroll and getProperty('scoreIcon.y') + 34 or getProperty('scoreIcon.y') - 34, 'hud', 32)
		
		draw.text('ratingText', '?', 0, not pref.statsBg and getProperty('ratingIcon.x') + 37 or getProperty('ratingIcon.x') + 44, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
		draw.text('scoreText', '0', 0, not pref.statsBg and getProperty('scoreIcon.x') + 37 or getProperty('scoreIcon.x') + 44, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
		draw.text('missesText', '0', 0, not pref.statsBg and getProperty('missesIcon.x') + 37 or getProperty('missesIcon.x') + 44, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
	
	elseif pref.statsType == 'vanilla' then 
		if pref.statsBg then
			draw.graphic('centerBox', 0, downscroll and 10 or screenHeight - 50, 590, 40)
			screenCenter('centerBox', 'x')
			draw.sprite('leftRounded', 'roundedVanilla', getProperty('centerBox.x') - 10, getProperty('centerBox.y'), 'hud')
			draw.sprite('rightRounded', 'roundedVanilla', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud')
			setProperty('rightRounded.flipX', true)
			setProperty('leftRounded.antialiasing', false)
			setProperty('rightRounded.antialiasing', false)
			for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
		end
		
		draw.sprite('ratingIcon', shud .. 'ratingIcon', (screenWidth / 2) - 295, downscroll and 14 or screenHeight - 45, 'hud', 32)
		draw.sprite('scoreIcon', shud .. 'scoreIcon', getProperty('ratingIcon.x') + 230, downscroll and 14 or screenHeight - 45, 'hud', 32)
		draw.sprite('missesIcon', shud .. 'missesIcon', getProperty('scoreIcon.x') + 230, downscroll and 14 or screenHeight - 45, 'hud', 32)
		
		draw.text('ratingText', '?', 0, getProperty('ratingIcon.x') + 36, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
		draw.text('scoreText', '0', 0, getProperty('scoreIcon.x') + 36, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
		draw.text('missesText', '0', 0, getProperty('missesIcon.x') + 36, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
	end
	
	if pref.coloredText then
		for i = 1, #textColors do
			setTextColor(textColors[i][1], textColors[i][2])
		end
	end
	
	if pref.verticalHealthBar then
		setProperty('healthBar.angle', 90)
		screenCenter('healthBar', 'y')
		setProperty('healthBar.x', screenWidth - 355)
		setProperty('iconP2.flipX', true)
	end

	if pref.laneUnderlay > 0 then
		for i = 0, 3 do
			draw.graphic('bfUnderlay' .. i, getPropertyFromGroup('playerStrums', i, 'x'), 0, 110, screenHeight)
			setProperty('bfUnderlay' .. i .. '.alpha', pref.laneUnderlay)
			setObjectOrder('bfUnderlay' .. i, getObjectOrder('strumLineNotes') - 1)

			if pref.oppUnderlay then
				draw.graphic('dadUnderlay' .. i, getPropertyFromGroup('opponentStrums', i, 'x'), 0, 110, screenHeight)
				setProperty('dadUnderlay' .. i .. '.alpha', pref.laneUnderlay)
				setObjectOrder('dadUnderlay' .. i, getObjectOrder('strumLineNotes') - 1)
			end
		end
	end
	
	if pref.elementsAlpha < 1 then
		for i = 1, 3 do
			setProperty(textStuff[i] .. '.alpha', pref.elementsAlpha)
			setProperty(iconStuff[i] .. '.alpha', pref.elementsAlpha)
			if pref.elementsAlpha <= .7 and pref.statsBg then 
				setProperty(statsbgthings[i] .. '.alpha', 0.1)
			end
		end
	end
end

function onUpdatePost()
	if pref.verticalHealthBar then
		setProperty('iconP1.x', getProperty('healthBar.x') + 225)
		setProperty('iconP2.x', getProperty('healthBar.x') + 225)
		util.traceHealthBar('iconP1', 'y', 310)
		util.traceHealthBar('iconP2', 'y', 430)
	end

	if pref.laneUnderlay > 0 then
		for i = 0, 3 do
			setProperty('bfUnderlay' .. i .. '.x', getPropertyFromGroup('playerStrums', i, 'x'))
			if pref.oppUnderlay then setProperty('dadUnderlay' .. i .. '.x', getPropertyFromGroup('opponentStrums', i, 'x')) end
		end
	end
end

function goodNoteHit(n, d, t, sus) if not sus then updateHud() end end
function noteMiss() updateHud() end

function updateHud()
	setTextString('ratingText', util.floorDecimal(rating * 100, 2) .. '% [' .. getProperty('ratingFC') .. ']')
	setTextString('scoreText', score)
	setTextString('missesText', misses)

	if pref.statsBg and pref.statsType ~= 'vanilla' then
		statsWidth = getProperty('ratingText.width') - 18
		setGraphicSize('centerBox', statsWidth, 110)
		setProperty('rightRounded.x', getProperty('centerBox.x') + getProperty('centerBox.width'))
	end
end