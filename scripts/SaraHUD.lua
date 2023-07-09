--[[
	SaraHUD:R ver.[0.1.3]
	by Novikond
]]

-- settings:
local pref = {
	statsType = 'sarahud', -- Available: 'sarahud'
	skin = 'copacetic',
	
	statsBg = true,
	fullTimeTxt = false, -- wip
	extraStats = false, -- wip
	
	coloredText = true,
	modifiersIcons = false, -- wip
	deathScreen = true,
	verticalHealthBar = false, -- wip
	
	laneUnderlay = 0, -- wip
	elementsAlpha = 1
}

local textColors = {
	['ratingText'] = 'f6b7bd',
	['scoreText'] = 'b1d9f0',
	['missesText'] = 'e3b7ee'
}
-- no more settings :pensive:

local saraTools
local shud = 'saraHUD/'..pref.skin..'/'
local statsWidth = 20

local hudStuff = {'scoreTxt', 'timeBar', 'timeBarBG', 'timeTxt'}
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
	
	if pref.statsType == 'sarahud' then
		if pref.statsBg then
			draw.sprite('leftRounded', 'roundedSHUD', 52, downscroll and 9 or screenHeight - 118, 'hud', 18, 110)
			draw.graphic('centerBox', getProperty('leftRounded.x') + 18, getProperty('leftRounded.y'), 1, 110)
			draw.sprite('rightRounded', 'roundedSHUD', getProperty('centerBox.x') + getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud', 18, 110)
			setProperty('rightRounded.flipX', true)
			for i = 1, 3 do setProperty(statsbgthings[i] .. '.alpha', 0.2) end
		end
	
		draw.sprite('ratingIcon', shud .. 'ratingIcon', 15, downscroll and 14 or screenHeight - 45, 'hud', 32)
		draw.sprite('scoreIcon', shud .. 'scoreIcon', 15, downscroll and getProperty('ratingIcon.y') + 34 or getProperty('ratingIcon.y') - 34, 'hud', 32)
		draw.sprite('missesIcon', shud .. 'missesIcon', 15, downscroll and getProperty('scoreIcon.y') + 34 or getProperty('scoreIcon.y') - 34, 'hud', 32)
		
		draw.text('ratingText', '?', 0, not pref.statsBg and getProperty('ratingIcon.x') + 37 or getProperty('ratingIcon.x') + 44, getProperty('ratingIcon.y') + 6, unpack(DEFsarahud))
		draw.text('scoreText', '0', 0, not pref.statsBg and getProperty('scoreIcon.x') + 37 or getProperty('scoreIcon.x') + 44, getProperty('scoreIcon.y') + 6, unpack(DEFsarahud))
		draw.text('missesText', '0', 0, not pref.statsBg and getProperty('missesIcon.x') + 37 or getProperty('missesIcon.x') + 44, getProperty('missesIcon.y') + 6, unpack(DEFsarahud))
	elseif pref.statsType == 'vanilla' then 
		-- i'm too lazy man
	end
	
	if pref.coloredText then
		setTextColor('ratingText', textColors['ratingText'])
		setTextColor('scoreText', textColors['scoreText'])
		setTextColor('missesText', textColors['missesText'])
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

function onUpdateScore()
	setTextString('ratingText', string.format("%.2f%%", rating * 100) .. ' [' .. getProperty('ratingFC') .. ']')
	setTextString('scoreText', score)
	setTextString('missesText', misses)

	if pref.statsBg then
		statsWidth = getProperty('ratingText.width') - 18
		setGraphicSize('centerBox', statsWidth, 110)
		setProperty('rightRounded.x', getProperty('centerBox.x') + getProperty('centerBox.width'))
	end
end

function onGameOverStart()
	if pref.deathScreen then
		local deaths = getPropertyFromClass('PlayState', 'deathCounter')
		local deathScreenText = '< Misses: ' .. misses .. ' | Score: ' .. score .. ' | Rating: ' .. string.format("%.2f%%", rating * 100) .. ' > • < Blueballed: ' .. deaths .. ' >'
		draw.sprite('bbIcon', shud .. 'bbIcon', 15, screenHeight - 45, 'hud', 32)
		draw.text('bbText', deathScreenText, 0, getProperty('bbIcon.x') + 38, getProperty('bbIcon.y') + 6, unpack(DEFsarahud))
	end
end

function onGameOverConfirm()
	if pref.deathScreen then
		effect.shift('bbText', 15, 0, true, 0.5, 'circOut')
		doTweenAlpha('bbIconbye', 'bbIcon', 0, 1.5, 'circIn')
		doTweenAlpha('bbTextbye', 'bbText', 0, 1.5, 'circIn')
	end
end