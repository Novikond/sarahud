--[[
	SaraHUD:R ver.[1.0b]
	by Novikond
]]

-- settings:
local pref = {
	statsType = 'vanilla', -- Available: 'sarahud', 'vanilla'
	skin = 'copacetic',
	
	extraStats = 'default', -- Available: false, 'default' || Will be available: 'expanded', 'debug'

	statsBg = true,
	coloredText = true,
	
	laneUnderlay = 0,
	oppUnderlay = true,
}

local textColors = {
	{'ratingText', 'f6b7bd'},
	{'scoreText', 'b1d9f0'},
	{'missesText', 'e3b7ee'},
	
	{'sickText', 'ccffbf'},
	{'goodText', 'fcffba'},
	{'badText', 'ffd2bb'},
	{'noText', 'ffbfcc'}
}
-- no more settings :pensive:

local saraTools
local shud = 'saraHUD/'..pref.skin..'/'
local statsWidth = 20

local hudStuff = {'scoreTxt', 'timeTxt'}
local textStuff = {'ratingText', 'scoreText', 'missesText'}
local iconStuff = {'ratingIcon', 'scoreIcon', 'missesIcon'}
local statsbgthings = {'leftRounded', 'centerBox', 'rightRounded'}
local extrDef = {'sickIcon', 'goodIcon', 'badIcon', 'noIcon'}
local DEFsarahud = {'left', 'hud', 16, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf'}

local newId
local sicks = 0
local goods = 0
local bads = 0
local shits = 0

function getScriptDirectory()
	local info = debug.getinfo(1, "S")
	local scriptPath = info.source:sub(2)
	return scriptPath:match("(.*/)") or ""
end

function onCreate() saraTools = require(getScriptDirectory() .. 'saraTools') end

function onCreatePost()
	for i = 1, #hudStuff do setProperty(hudStuff[i] .. '.visible', false) end
	
	--draw.sprite('test', shud .. 'pracIcon', 0, 0, 'hud'); screenCenter('test')
	
	if not hideHud then
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
				draw.graphic('centerBox', 0, downscroll and 25 or screenHeight - 50, 590, 40)
				screenCenter('centerBox', 'x')
				draw.sprite('leftRounded', 'roundedVanilla', getProperty('centerBox.x') - 10, getProperty('centerBox.y'), 'hud')
				draw.sprite('rightRounded', 'roundedVanilla', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud')
				setProperty('rightRounded.flipX', true)
				setProperty('leftRounded.antialiasing', false)
				setProperty('rightRounded.antialiasing', false)
				for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
			end
		
			draw.sprite('ratingIcon', shud .. 'ratingIcon', (screenWidth / 2) - 295, downscroll and 30 or screenHeight - 45, 'hud', 32)
			draw.sprite('scoreIcon', shud .. 'scoreIcon', getProperty('ratingIcon.x') + 230, downscroll and 30 or screenHeight - 45, 'hud', 32)
			draw.sprite('missesIcon', shud .. 'missesIcon', getProperty('scoreIcon.x') + 230, downscroll and 30 or screenHeight - 45, 'hud', 32)
		
			draw.text('ratingText', '?', 0, getProperty('ratingIcon.x') + 36, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
			draw.text('scoreText', '0', 0, getProperty('scoreIcon.x') + 36, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
			draw.text('missesText', '0', 0, getProperty('missesIcon.x') + 36, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
		end

		if pref.extraStats == 'default' then
			draw.sprite('sickIcon', shud .. 'sickIcon', screenWidth - 56, (screenHeight / 2) - 48, 'hud', 42)
			draw.sprite('goodIcon', shud .. 'goodIcon', getProperty('sickIcon.x'), getProperty('sickIcon.y') + 46, 'hud', 42)
			draw.sprite('badIcon', shud .. 'badIcon', getProperty('sickIcon.x'), getProperty('goodIcon.y') + 46, 'hud', 42)
			draw.sprite('noIcon', shud .. 'noIcon', getProperty('sickIcon.x'), getProperty('badIcon.y') + 46, 'hud', 42)
			for i = 1, #extrDef do setProperty(extrDef[i] .. '.alpha', 0.5) end

			draw.text('sickText', '0', 100, getProperty('sickIcon.x') - 29, getProperty('sickIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('goodText', '0', 100, getProperty('goodIcon.x') - 29, getProperty('goodIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('badText', '0', 100, getProperty('badIcon.x') - 29, getProperty('badIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('noText', '0', 100, getProperty('noIcon.x') - 29, getProperty('noIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
		end
	end
	
	if pref.coloredText then
		for i = 1, #textColors do
			setTextColor(textColors[i][1], textColors[i][2])
		end
	end

	if timeBarType ~= 'Disabled' then
		draw.text('songText', songName, 400, 0, getProperty('timeBar.y'), 'center', 'hud', 16, nil, 1, nil, true, 'PhantomMuff.ttf')
		draw.text('timeText', util.formatTime(songLength), 80, getProperty('timeBar.x') + getProperty('timeBar.width') - 82, getProperty('timeBar.y'), 'right', 'hud', 16, nil, 1, nil, true, 'PhantomMuff.ttf')
		screenCenter('songText', 'x')

		draw.sprite('songIcon', shud .. 'songIcon', getProperty('timeBar.x') - 30, getProperty('timeBar.y') - 2, 'hud', 26)
		draw.sprite('timeIcon', shud .. 'timerIcon', getProperty('timeBar.x') + getProperty('timeBar.width') + 5, getProperty('timeBar.y') - 2, 'hud', 26)
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
end

function onUpdatePost()
	if timeBarType ~= 'Disabled' then
		setProperty('songText.y', getProperty('timeBar.y'))
		setProperty('timeText.y', getProperty('timeBar.y'))

		setProperty('songIcon.y', getProperty('timeBar.y') - 2)
		setProperty('timeIcon.y', getProperty('timeBar.y') - 2)

		setProperty('songText.alpha', getProperty('timeBar.alpha'))
		setProperty('timeText.alpha', getProperty('timeBar.alpha'))
		setProperty('songIcon.alpha', getProperty('timeBar.alpha'))
		setProperty('timeIcon.alpha', getProperty('timeBar.alpha'))
	end

	if pref.laneUnderlay > 0 then
		for i = 0, 3 do
			setProperty('bfUnderlay' .. i .. '.x', getPropertyFromGroup('playerStrums', i, 'x'))
			if pref.oppUnderlay then setProperty('dadUnderlay' .. i .. '.x', getPropertyFromGroup('opponentStrums', i, 'x')) end
		end
	end
end

function goodNoteHit(id, d, t, sus)
	if not sus then
		updateHud()
		if pref.extraStats ~= false then 
			newId = id -- no idea why getProperty('sicks') and stuff like that doesn't work anymore
			updateHudExtra() 
		end
	end
end
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

function updateHudExtra()
	if pref.extraStats == 'default' then
		if getPropertyFromGroup('notes', newId, 'rating') == 'sick' then
			sicks = sicks + 1
			effect.alpha('sickIcon', 1, .5)
		elseif getPropertyFromGroup('notes', newId, 'rating') == 'good' then
			goods = goods + 1
			effect.alpha('goodIcon', 1, .5)
		elseif getPropertyFromGroup('notes', newId, 'rating') == 'bad' then
			bads = bads + 1
			effect.alpha('badIcon', 1, .5)
		elseif getPropertyFromGroup('notes', newId, 'rating') == 'shit' then
			shits = shits + 1
			effect.alpha('noIcon', .9, .5)
		end

		setTextString('sickText', sicks)
		setTextString('goodText', goods)
		setTextString('badText', bads)
		setTextString('noText', shits)
	end
end