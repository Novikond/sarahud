-- property of novikond lol, wait for sarahud reborn plz :pray:

local saraTools = require('saraTools')

-- settings:
local pref = {
	statsType = 'sarahud',
	skin = 'copacetic',
	
	fullTimeTxt = false,
	extraStats = false,
	
	coloredText = true,
	modifiersIcons = false,
	deathCounter = true,
	verticalHealthBar = false,
	
	laneUnderlay = 0,
	elementsAlpha = 1
}

local textColors = {
	['ratingText'] = 'f6b7bd',
	['scoreText'] = 'b1d9f0',
	['missesText'] = 'e3b7ee'
}
-- no more settings :pensive:

local shud = 'saraHUD/'..pref.skin..'/'
local statsWidth = 20

local hudStuff = {'scoreTxt', 'timeBar', 'timeBarBG', 'timeTxt'}
local textStuff = {'ratingText', 'scoreText', 'missesText'}
local statsbgthings = {'leftRounded', 'centerBox', 'rightRounded'}
local DEFsarahud = {'left', 'hud', 16, 'ffffff', 1, '000000', true, 'PhantomMuff.ttf'}

function onCreatePost()
	for i = 1, #hudStuff do setProperty(hudStuff[i]..'.visible', false) end
	
	if pref.statsType == 'sarahud' then
		draw.sprite('leftRounded', 'roundedSHUD', 52, downscroll and 9 or screenHeight - 118, 'hud', 18, 110)
		draw.graphic('centerBox', getProperty('leftRounded.x')+18, getProperty('leftRounded.y'), 1, 110)
		draw.sprite('rightRounded', 'roundedSHUD', getProperty('centerBox.x')+getProperty('centerBox.width'), getProperty('centerBox.y'), 'hud', 18, 110)
		setProperty('rightRounded.flipX', true)
		
		for i = 1, 3 do setProperty(statsbgthings[i]..'.alpha', 0.3) end
	
		draw.sprite('ratingIcon', shud..'ratingIcon', 15, downscroll and 14 or screenHeight - 45, 'hud', 32)
		draw.sprite('scoreIcon', shud..'scoreIcon', 15, downscroll and getProperty('ratingIcon.y')+34 or getProperty('ratingIcon.y')-34, 'hud', 32)
		draw.sprite('missesIcon', shud..'missesIcon', 15, downscroll and getProperty('scoreIcon.y')+34 or getProperty('scoreIcon.y')-34, 'hud', 32)
		
		draw.text('ratingText', '?', 0, getProperty('ratingIcon.x')+42, getProperty('ratingIcon.y')+6, unpack(DEFsarahud))
		draw.text('scoreText', '0', 0, getProperty('scoreIcon.x')+42, getProperty('scoreIcon.y')+6, unpack(DEFsarahud))
		draw.text('missesText', '0', 0, getProperty('missesIcon.x')+42, getProperty('missesIcon.y')+6, unpack(DEFsarahud))
	end
	
	if pref.coloredText then
		setTextColor('ratingText', textColors['ratingText'])
		setTextColor('scoreText', textColors['scoreText'])
		setTextColor('missesText', textColors['missesText'])
	end
end

function onUpdateScore()
	setTextString('ratingText', string.format("%.2f%%", rating * 100)..' ['..getProperty('ratingFC')..']')
	setTextString('scoreText', score)
	setTextString('missesText', misses)

	statsWidth = getProperty('ratingText.width') - 18
	setGraphicSize('centerBox', statsWidth, 110)
	setProperty('rightRounded.x', getProperty('centerBox.x')+getProperty('centerBox.width'))
end

function onGameOverStart()
	if pref.deathCounter then
	local deaths = getPropertyFromClass('PlayState', 'deathCounter')
		draw.sprite('bbIcon', shud..'bbIcon', 15, screenHeight - 45, 'hud', 32)
		draw.text('bbText', (deaths == 1) and '1 time' or deaths..' times', 0, getProperty('bbIcon.x')+38, getProperty('bbIcon.y')+6, unpack(DEFsarahud))
	end
end

function onGameOverConfirm()
	if pref.deathCounter then
		effect.shift('bbText', 15, 0, true, 0.5, 'circOut')
		doTweenAlpha('bbIconbye', 'bbIcon', 0, 1.5, 'circIn')
		doTweenAlpha('bbTextbye', 'bbText', 0, 1.5, 'circIn')
	end
end