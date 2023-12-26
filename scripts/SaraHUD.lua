--[[
	SaraHUD:R ver.[1.0]
	by Novikond
]]

local saraTools

local textColors = {
	{'ratingText', 'f6b7bd'},
	{'scoreText', 'b1d9f0'},
	{'missesText', 'e3b7ee'},
	
	{'sickText', 'ccffbf'},
	{'goodText', 'fcffba'},
	{'badText', 'ffd2bb'},
	{'noText', 'ffbfcc'},

	{'curStepText', 'ffc6be'},
	{'curBeatText', 'ffc6be'},

	{'textRatings', 'dffff0'}
}

local hudStuff = {'scoreTxt', 'timeTxt'}
local statsbgthings = {'leftRounded', 'centerBox', 'rightRounded'}
local extrDef = {'sickIcon', 'goodIcon', 'badIcon', 'noIcon'}
local extrDebu = {'curStepIcon', 'curBeatIcon'}

local DEFsarahud = {'left', 'hud', 16, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf'}

local statsWidth = 20
local newId -- yes we totally need it
local sicks = 0 -- yes we totally need it
local goods = 0 -- yes we totally need it
local bads = 0 -- yes we totally need it
local shits = 0 -- yes we totally need it

function onCreate()
	saraTools = require(getTextFromFile('data/SHUDlibs.txt') .. 'saraTools')
end

function onCreatePost()
	for i = 1, #hudStuff do setProperty(hudStuff[i] .. '.visible', false) end
	
	--draw.sprite('test', 'saraHUD/pracIcon', 0, 0, 'hud'); screenCenter('test')

	if not hideHud then
		if getModSetting('statsType', 'SaraHUD') == 'SaraHUD' then
			if getModSetting('statsBg', 'SaraHUD') then
				draw.sprite('leftRounded', 'GUI/roundedSHUD', 52, downscroll and 9 or screenHeight - 118, 'hud', 18, 110)
				draw.graphic('centerBox', getProperty('leftRounded.x') + 18, getProperty('leftRounded.y'), 1, 110)
				draw.sprite('rightRounded', 'GUI/roundedSHUD', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud', 18, 110)
				setProperty('rightRounded.flipX', true)
				setProperty('leftRounded.antialiasing', false)
				setProperty('rightRounded.antialiasing', false)
				for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
			end
	
			draw.sprite('ratingIcon', 'saraHUD/ratingIcon', 15, downscroll and 14 or screenHeight - 45, 'hud', 32)
			draw.sprite('scoreIcon', 'saraHUD/scoreIcon', 15, downscroll and getProperty('ratingIcon.y') + 34 or getProperty('ratingIcon.y') - 34, 'hud', 32)
			draw.sprite('missesIcon', 'saraHUD/missesIcon', 15, downscroll and getProperty('scoreIcon.y') + 34 or getProperty('scoreIcon.y') - 34, 'hud', 32)
		
			draw.text('ratingText', '?', 0, not getModSetting('statsBg', 'SaraHUD') and getProperty('ratingIcon.x') + 37 or getProperty('ratingIcon.x') + 49, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
			draw.text('scoreText', '0', 0, not getModSetting('statsBg', 'SaraHUD') and getProperty('scoreIcon.x') + 37 or getProperty('scoreIcon.x') + 49, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
			draw.text('missesText', '0', 0, not getModSetting('statsBg', 'SaraHUD') and getProperty('missesIcon.x') + 37 or getProperty('missesIcon.x') + 49, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
	
		elseif getModSetting('statsType', 'SaraHUD') == 'Psych-Like' then
			if getModSetting('statsBg', 'SaraHUD') then
				draw.graphic('centerBox', 0, downscroll and 25 or screenHeight - 50, 590, 40)
				screenCenter('centerBox', 'x')
				draw.sprite('leftRounded', 'GUI/roundedVanilla', getProperty('centerBox.x') - 10, getProperty('centerBox.y'), 'hud')
				draw.sprite('rightRounded', 'GUI/roundedVanilla', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud')
				setProperty('rightRounded.flipX', true)
				setProperty('leftRounded.antialiasing', false)
				setProperty('rightRounded.antialiasing', false)
				for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
			end
		
			draw.sprite('scoreIcon', 'saraHUD/scoreIcon', (screenWidth / 2) - 295, downscroll and 30 or screenHeight - 45, 'hud', 32)
			draw.sprite('missesIcon', 'saraHUD/missesIcon', getProperty('scoreIcon.x') + 210, downscroll and 30 or screenHeight - 45, 'hud', 32)
			draw.sprite('ratingIcon', 'saraHUD/ratingIcon', getProperty('missesIcon.x') + 210, downscroll and 30 or screenHeight - 45, 'hud', 32)
		
			draw.text('scoreText', '0', 0, getProperty('scoreIcon.x') + 36, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
			draw.text('missesText', '0', 0, getProperty('missesIcon.x') + 36, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
			draw.text('ratingText', '?', 0, getProperty('ratingIcon.x') + 36, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
		end

		if getModSetting('extraStats', 'SaraHUD') == 'Simple' then
			draw.sprite('sickIcon', 'saraHUD/sickIcon', screenWidth - 56, (screenHeight / 2) - 48, 'hud', 42)
			draw.sprite('goodIcon', 'saraHUD/goodIcon', getProperty('sickIcon.x'), getProperty('sickIcon.y') + 46, 'hud', 42)
			draw.sprite('badIcon', 'saraHUD/badIcon', getProperty('sickIcon.x'), getProperty('goodIcon.y') + 46, 'hud', 42)
			draw.sprite('noIcon', 'saraHUD/noIcon', getProperty('sickIcon.x'), getProperty('badIcon.y') + 46, 'hud', 42)
			for i = 1, #extrDef do setProperty(extrDef[i] .. '.alpha', 0.5) end

			draw.text('sickText', '0', 100, getProperty('sickIcon.x') - 29, getProperty('sickIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('goodText', '0', 100, getProperty('goodIcon.x') - 29, getProperty('goodIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('badText', '0', 100, getProperty('badIcon.x') - 29, getProperty('badIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('noText', '0', 100, getProperty('noIcon.x') - 29, getProperty('noIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')

		elseif getModSetting('extraStats', 'SaraHUD') == 'Debug' then
			draw.sprite('curStepIcon', 'saraHUD/curStepIcon', screenWidth - 56, (screenHeight / 2) - 2, 'hud', 42)
			draw.sprite('curBeatIcon', 'saraHUD/curBeatIcon', getProperty('curStepIcon.x'), getProperty('curStepIcon.y') + 46, 'hud', 42)
			for i = 1, #extrDebu do setProperty(extrDebu[i] .. '.alpha', 0.5) end

			draw.text('curStepText', '0', 100, getProperty('curStepIcon.x') - 29, getProperty('curStepIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
			draw.text('curBeatText', '0', 100, getProperty('curBeatIcon.x') - 29, getProperty('curBeatIcon.y') + 11, 'center', 'hud', 18, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf')
		end
	end

	if timeBarType ~= 'Disabled' then
		draw.text('songText', songName, 400, 0, getProperty('timeBar.y'), 'center', 'hud', 16, nil, 1, nil, true, 'PhantomMuff.ttf')
		draw.text('timeText', util.formatTime(songLength), 80, getProperty('timeBar.x') + getProperty('timeBar.width') - 82, getProperty('timeBar.y'), 'right', 'hud', 16, nil, 1, nil, true, 'PhantomMuff.ttf')
		screenCenter('songText', 'x')

		draw.sprite('songIcon', 'saraHUD/songIcon', getProperty('timeBar.x') - 30, getProperty('timeBar.y') - 2, 'hud', 26)
		draw.sprite('timeIcon', 'saraHUD/timerIcon', getProperty('timeBar.x') + getProperty('timeBar.width') + 5, getProperty('timeBar.y') - 2, 'hud', 26)
	end

	if getModSetting('replaceHB', 'SaraHUD') then
		loadGraphic('healthBar.bg', 'GUI/healthBar')
	end

	if getModSetting('replaceTB', 'SaraHUD') then
		loadGraphic('timeBar.bg', 'GUI/timeBar')
	end

	if getModSetting('textRatings', 'SaraHUD') then
		setProperty('showRating', false)
		setProperty('showComboNum', false)
		setProperty('showCombo', false)

		if getModSetting('statsBg', 'SaraHUD') then
			draw.graphic('centerBoxR', getProperty('healthBar.x') + getProperty('healthBar.width') + 49, getProperty('healthBar.y') - 10, 130, 40)
			draw.sprite('leftRoundedR', 'GUI/roundedVanilla', getProperty('centerBoxR.x') - 10, getProperty('centerBoxR.y'), 'hud')
			draw.sprite('rightRoundedR', 'GUI/roundedVanilla', getProperty('centerBoxR.x') + getProperty('centerBoxR.width'), getProperty('centerBoxR.y'), 'hud')
			setProperty('rightRoundedR.flipX', true)
			setProperty('leftRoundedR.antialiasing', false)
			setProperty('rightRoundedR.antialiasing', false)
			for i = 1, 3 do setProperty(statsbgthings[i] .. 'R.alpha', 0) end
		end

		draw.sprite('comboIcon', 'saraHUD/comboIcon', getProperty('healthBar.x') + getProperty('healthBar.width') + 50, getProperty('healthBar.y') - 6, 'hud', 32)
		draw.text('textRatings', 'Sick [000]', 0, getProperty('comboIcon.x') + 36, getProperty('comboIcon.y') + 6, unpack(DEFsarahud))
		setProperty('comboIcon.alpha', 0)
		setProperty('textRatings.alpha', 0)
	end

	if getModSetting('laneUnderlay', 'SaraHUD') > 0 then
		for i = 0, 3 do
			draw.graphic('bfUnderlay' .. i, getPropertyFromGroup('playerStrums', i, 'x'), 0, 110, screenHeight)
			setProperty('bfUnderlay' .. i .. '.alpha', getModSetting('laneUnderlay', 'SaraHUD'))
			setObjectOrder('bfUnderlay' .. i, getObjectOrder('strumLineNotes') + 1)

			if getModSetting('oppUnderlay', 'SaraHUD') then
				draw.graphic('dadUnderlay' .. i, getPropertyFromGroup('opponentStrums', i, 'x'), 0, 110, screenHeight)
				setProperty('dadUnderlay' .. i .. '.alpha', getModSetting('laneUnderlay', 'SaraHUD'))
				setObjectOrder('dadUnderlay' .. i, getObjectOrder('strumLineNotes') + 1)
			end
		end
	end

	if getModSetting('coloredText', 'SaraHUD') then
		for i = 1, #textColors do
			setTextColor(textColors[i][1], textColors[i][2])
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

		setProperty('songText.visible', getProperty('timeBar.visible'))
		setProperty('timeText.visible', getProperty('timeBar.visible'))
		setProperty('songIcon.visible', getProperty('timeBar.visible'))
		setProperty('timeIcon.visible', getProperty('timeBar.visible'))
	end

	if getModSetting('laneUnderlay', 'SaraHUD') > 0 then
		for i = 0, 3 do
			setProperty('bfUnderlay' .. i .. '.x', getPropertyFromGroup('playerStrums', i, 'x'))
			if getModSetting('oppUnderlay', 'SaraHUD') then setProperty('dadUnderlay' .. i .. '.x', getPropertyFromGroup('opponentStrums', i, 'x')) end
		end
	end
end

function goodNoteHitPost(id, d, t, sus)
	if not sus then
		updateHud()
		newId = id -- no idea why getProperty('sicks') doesn't work in 0.7

		if getModSetting('extraStats', 'SaraHUD') ~= 'Disabled' then
			updateHudExtra()
		end

		if getModSetting('textRatings', 'SaraHUD') then
			if getModSetting('statsBg', 'SaraHUD') then
				for i = 1, 3 do
					setProperty(statsbgthings[i] .. 'R.alpha', .2)
					startTween(statsbgthings[i] .. 'R-effect-alpha', statsbgthings[i] .. 'R', {alpha = 0}, 1, {ease = 'cubeInOut', startDelay = .9})
				end
			end
			setTextString('textRatings', grabRating() .. ' [' .. canonevent(combo) .. ']')

			setProperty('comboIcon.alpha', 1)
			startTween('comboIcon-effect-alpha', 'comboIcon', {alpha = 0}, 1, {ease = 'cubeInOut', startDelay = .9})
			setProperty('textRatings.alpha', 1)
			startTween('textRatings-effect-alpha', 'textRatings', {alpha = 0}, 1, {ease = 'cubeInOut', startDelay = .9})
		end
	end
end
function noteMiss() updateHud() end

function onStepHit()
	if getModSetting('extraStats', 'SaraHUD') == 'Debug' then
		setTextString('curStepText', curStep)
	end
end

function onBeatHit()
	if getModSetting('extraStats', 'SaraHUD') == 'Debug' then
		setTextString('curBeatText', curBeat)
	end
end

function onSongStart()
	if timeBarType ~= 'Disabled' then
		setTextString('timeText', util.formatTime(songLength))
	end
end

function updateHud()
	setTextString('ratingText', util.floorDecimal(rating * 100, 2) .. '% [' .. getProperty('ratingFC') .. ']')
	setTextString('scoreText', score)
	setTextString('missesText', misses)

	if getModSetting('statsBg', 'SaraHUD') and getModSetting('statsType', 'SaraHUD') ~= 'Psych-Like' then
		statsWidth = getProperty('ratingText.width') - 12
		setGraphicSize('centerBox', statsWidth, 110)
		setProperty('rightRounded.x', getProperty('centerBox.x') + getProperty('centerBox.width'))
	end
end

function updateHudExtra()
	if getModSetting('extraStats', 'SaraHUD') == 'Simple' then
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

function grabRating()
	local curRating = 'Sick'

	if getPropertyFromGroup('notes', newId, 'rating') == 'sick' then
		curRating = 'Sick'
	elseif getPropertyFromGroup('notes', newId, 'rating') == 'good' then
		curRating = 'Good'
	elseif getPropertyFromGroup('notes', newId, 'rating') == 'bad' then
		curRating = 'Bad'
	elseif getPropertyFromGroup('notes', newId, 'rating') == 'shit' then
		curRating = 'Shit'
	end

	return curRating
end

function canonevent(number)
	if number >= 0 and number < 10 then
		return '00' .. number
	elseif number >= 10 and number < 100 then
		return '0' .. number
	else
		return number
	end
end