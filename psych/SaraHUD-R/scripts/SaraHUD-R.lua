-- > SaraHUD:R < -- [by Novikond]

-------- DEBUG --------
local noOptionsMenu = false -- if [true], uses the old fashioned way to manage preferences
local pref = {
    -- disaplayed info
    statsType = 'SaraHUD',
    extraStats = false,
    etternaBar = true,
    ratings = 'FC',

    -- visuals
    replaceHB = true,
    replaceTB = true,
    timebarIcons = true,
    comboReplace = false,
    coloredText = true,

    laneUnderlay = 0,
    oppUnderlay = false,

    -- technical
    outdateCheck = true
}

-------- VARS --------

-- we actually have fixed all the bugs when ai deletes files on your pc... we isolated her ai model in this update
local uit -- prev. known as "saraTools"

local textColors = { -- should i store this in different file or something
	{'ratingText', 'ffd2d6'},
	{'scoreText', 'ceedff'},
	{'missesText', 'f7d5ff'},
	
	{'sickText', 'dfffd6'},
	{'goodText', 'd8ffff'},
	{'badText', 'ffe0cf'},
	{'noText', 'ffd0da'}
}

local comboThings = {'comboText', 'comboTextFB', 'comboRatingText', 'comboRatingTextFB'}
local bg = {'infoBgLeft', 'infoBg', 'infoBgRight'}
local extrSim = {'sick', 'good', 'bad', 'no'}
local extrFul = {'combo', 'tnh'}

local bruh = false -- dumbass check
local statsWidth = 20
local ratingthing = '%'

local sid -- ik i could make it easier, don't look at me like that
local sicks = 0
local goods = 0
local bads = 0
local nos = 0

-------- PSYCH FUNCTIONS, PREFERENCES --------

function onCreate()
	if version <= '0.7.2' and getModSetting('outdateCheck', 'SaraHUD-R') then
		setVar('shud_outdated', true)
		bruh = true
	end
	if not checkFileExists(getTextFromFile('libs_location.txt') .. 'uit.lua') then
		setVar('shud_noLibs', true)
		bruh = true
	else
		uit = require('mods/' .. getTextFromFile('libs_location.txt') .. 'uit')
	end
	if bruh then -- i really hope it will help people.
		addLuaScript('other_scripts/error.lua')
	end
end

function onCreatePost()
    setProperty('scoreTxt.visible', false)

    if not hideHud then
        if getPref('statsType') == 'SaraHUD' then
            uit.graphics.obj('infoBg', 30, downscroll and 25 or screenHeight - 121, 180, 100)
            uit.graphics.img('infoBgLeft', 'GUI/fade-shud', getProperty('infoBg.x') - 30, getProperty('infoBg.y'))
            uit.graphics.img('infoBgRight', 'GUI/round-shud', getProperty('infoBg.x') + getProperty('infoBg.width'), getProperty('infoBg.y'))

            setProperty('infoBgRight.flipX', true)

            for i = 1, #bg do
                setProperty(bg[i] .. '.antialiasing', false)
                setProperty(bg[i] .. '.alpha', .26)
            end

            uit.graphics.img('ratingIcon', 'saraHUD/ratingIcon', 15, downscroll and 16 or screenHeight - 50, .62)
            uit.graphics.img('scoreIcon', 'saraHUD/scoreIcon', 15, downscroll and getProperty('ratingIcon.y') + 40 or getProperty('ratingIcon.y') - 40, .62)
            uit.graphics.img('missesIcon', 'saraHUD/missesIcon', 15, downscroll and getProperty('scoreIcon.y') + 40 or getProperty('scoreIcon.y') - 40, .62)

            uit.graphics.text('ratingText', '?', getProperty('ratingIcon.x') + 50, getProperty('ratingIcon.y') + 9)
            uit.graphics.text('scoreText', '0', getProperty('scoreIcon.x') + 50, getProperty('scoreIcon.y') + 9)
            uit.graphics.text('missesText', '0', getProperty('missesIcon.x') + 50, getProperty('missesIcon.y') + 9)
            
        elseif getPref('statsType') == 'Psych-Like' then
            uit.graphics.obj('infoBg', 0, getProperty('healthBar.y') + 30, 600, 40)
            screenCenter('infoBg', 'x')

            uit.graphics.img('infoBgLeft', 'GUI/fade-vanilla', getProperty('infoBg.x') - 16, getProperty('infoBg.y'))
            uit.graphics.img('infoBgRight', 'GUI/fade-vanilla', getProperty('infoBg.x') + getProperty('infoBg.width'), getProperty('infoBg.y'))
            setProperty('infoBgRight.flipX', true)

            for i = 1, #bg do
                setProperty(bg[i] .. '.antialiasing', false)
                setProperty(bg[i] .. '.alpha', .26)
            end

            uit.graphics.img('scoreIcon', 'saraHUD/scoreIcon', (screenWidth / 2) - 295, getProperty('healthBar.y') + 34, .54)
            uit.graphics.img('missesIcon', 'saraHUD/missesIcon', getProperty('scoreIcon.x') + 200, getProperty('healthBar.y') + 34, .54)
            uit.graphics.img('ratingIcon', 'saraHUD/ratingIcon', getProperty('missesIcon.x') + 160, getProperty('healthBar.y') + 34, .54)

            uit.graphics.text('scoreText', '0', getProperty('scoreIcon.x') + 38, getProperty('scoreIcon.y') + 6, 0)
            uit.graphics.text('missesText', '0', getProperty('missesIcon.x') + 38, getProperty('missesIcon.y') + 6, 0)
            uit.graphics.text('ratingText', '?', getProperty('ratingIcon.x') + 38, getProperty('ratingIcon.y') + 6, 0)

        elseif getPref('statsType') == 'Vanilla' then
            uit.graphics.obj('infoBg',  (screenWidth / 2) + 100, getProperty('healthBar.y') + 30, 140, 40)
            uit.graphics.img('infoBgLeft', 'GUI/fade-vanilla', getProperty('infoBg.x') - 16, getProperty('infoBg.y'))
            uit.graphics.img('infoBgRight', 'GUI/fade-vanilla', getProperty('infoBg.x') + getProperty('infoBg.width'), getProperty('infoBg.y'))
            setProperty('infoBgRight.flipX', true)

            for i = 1, #bg do
                setProperty(bg[i] .. '.antialiasing', false)
                setProperty(bg[i] .. '.alpha', .26)
            end

            uit.graphics.img('scoreIcon', 'saraHUD/scoreIcon', (screenWidth / 2) + 110, getProperty('healthBar.y') + 34, .54)
            uit.graphics.text('scoreText', '0', getProperty('scoreIcon.x') + 38, getProperty('scoreIcon.y') + 6, 0)
        end
    end

    if getPref('extraStats') then
        uit.graphics.img('noIcon', 'saraHUD/noIcon', screenWidth - 64, (screenHeight / 2) + 54, .75)
        uit.graphics.img('badIcon', 'saraHUD/badIcon', screenWidth - 64, getProperty('noIcon.y') - 50, .75)
        uit.graphics.img('goodIcon', 'saraHUD/goodIcon', screenWidth - 64, getProperty('badIcon.y') - 50, .75)
        uit.graphics.img('sickIcon', 'saraHUD/sickIcon', screenWidth - 64, getProperty('goodIcon.y') - 50, .75)
        for i = 1, #extrSim do setProperty(extrSim[i] .. 'Icon.alpha', 0.5) end

        uit.graphics.text('noText', '0', getProperty('noIcon.x') - 28, getProperty('noIcon.y') + 12, 100, 'center')
        uit.graphics.text('badText', '0', getProperty('badIcon.x') - 28, getProperty('badIcon.y') + 12, 100, 'center')
        uit.graphics.text('goodText', '0', getProperty('goodIcon.x') - 28, getProperty('goodIcon.y') + 12, 100, 'center')
        uit.graphics.text('sickText', '0', getProperty('sickIcon.x') - 28, getProperty('sickIcon.y') + 12, 100, 'center')
        for i = 1, #extrSim do setProperty(extrSim[i] .. 'Text.alpha', 0.6) end
    end

    if getPref('etternaBar') and timeBarType ~= 'Disabled' then
        setProperty('timeTxt.visible', false)

        uit.graphics.text('songText', songName, 0, getProperty('timeBar.y'), 400, 'center')
        uit.graphics.text('timeText', '0:00', getProperty('timeBar.x') + getProperty('timeBar.width') - 82, getProperty('timeBar.y'), 80, 'right')
        screenCenter('songText', 'x')

        setTextSize('songText', 16)
        setTextSize('timeText', 16)

		if getPref('timebarIcons') then
            uit.graphics.img('songIcon', 'saraHUD/songIcon', getProperty('timeBar.x') - 30, getProperty('timeBar.y') - 2, .4)
            uit.graphics.img('timeIcon', 'saraHUD/timerIcon', getProperty('timeBar.x') + getProperty('timeBar.width') + 5, getProperty('timeBar.y') - 2, .4)
		end

    elseif not getPref('etternaBar') and timeBarType ~= 'Disabled' then
        setTextSize('timeTxt', 18) 
        setTextFont('timeTxt', 'PhantomMuff.ttf')
        setProperty('timeTxt.antialiasing', true)
        setProperty('timeTxt.y', getProperty('timeBar.y'))
    end

    if getPref('comboReplace') then
        setProperty('showComboNum', false)
        setProperty('showCombo', false)
        setProperty('showRating', false)

        uit.graphics.text('comboText', 'x5', getProperty('healthBar.x') + getProperty('healthBar.width') - 300, getProperty('healthBar.y') - 40, 300, 'right')
        setTextFont('comboText', 'Dimentia-Med.ttf')
        setTextBorder('comboText', 3, '000000')
        setTextSize('comboText', 40)

        uit.graphics.text('comboTextFB', 'x5', getProperty('comboText.x') - 15, getProperty('comboText.y'), 300, 'right') -- FB stands for feedback
        setTextFont('comboTextFB', 'Dimentia-Med.ttf')
        setTextSize('comboTextFB', 40)

        uit.graphics.text('comboRatingText', 'Sick!!', getProperty('healthBar.x'), getProperty('healthBar.y') - 70, 300)
        setTextFont('comboRatingText', 'Dimentia-Med.ttf')
        setTextBorder('comboRatingText', 3, '000000')
        setTextSize('comboRatingText', 40)

        uit.graphics.text('comboRatingTextFB', 'Sick!!', getProperty('comboRatingText.x') + 15, getProperty('comboRatingText.y'), 300) -- FB stands for feedback
        setTextFont('comboRatingTextFB', 'Dimentia-Med.ttf')
        setTextSize('comboRatingTextFB', 40)

        for i = 1, #comboThings do
            setProperty(comboThings[i] .. '.alpha', 0)
        end
    end

    if getPref('replaceHB') then
		loadGraphic('healthBar.bg', 'GUI/healthBar')
	end

	if getPref('replaceTB') then
		loadGraphic('timeBar.bg', 'GUI/timeBar')
	end

    if getPref('laneUnderlay') > 0 then
		for i = 0, 3 do
            uit.graphics.obj('bfUnderlay' .. i, getPropertyFromGroup('playerStrums', i, 'x'), 0, 110, screenHeight)
			setProperty('bfUnderlay' .. i .. '.alpha', getPref('laneUnderlay'))
			setObjectOrder('bfUnderlay' .. i, getObjectOrder('strumLineNotes') + 1)

			if getPref('oppUnderlay') then
				uit.graphics.obj('dadUnderlay' .. i, getPropertyFromGroup('opponentStrums', i, 'x'), 0, 110, screenHeight)
				setProperty('dadUnderlay' .. i .. '.alpha', getPref('laneUnderlay'))
				setObjectOrder('dadUnderlay' .. i, getObjectOrder('strumLineNotes') + 1)
			end
		end
	end

    if getPref('coloredText') then -- it's safer to run this function here
		for i = 1, #textColors do
			setTextColor(textColors[i][1], textColors[i][2])
		end
    end
end

function onUpdatePost()
    if getPref('etternaBar') and timeBarType ~= 'Disabled' then
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

    if getPref('laneUnderlay') > 0 then
		for i = 0, 3 do
			setProperty('bfUnderlay' .. i .. '.x', getPropertyFromGroup('playerStrums', i, 'x'))
			if getPref('oppUnderlay') then
                setProperty('dadUnderlay' .. i .. '.x', getPropertyFromGroup('opponentStrums', i, 'x'))
            end
		end
	end
end

function goodNoteHit(id, d, t, sus)
    if not sus then
        sid = id -- shur up
        updateHud()

        if getPref('extraStats') then
            updateHudExtra()
        end

        if getPref('comboReplace') then
            updateCombo()
        end
    end
end

function noteMiss()
    updateHud()

    if getPref('extraStats') then
        updateHudExtra()
    end
end

function onSongStart()
    if getPref('etternaBar') then
        setTextString('timeText', uit.util.formatTime(songLength))
    end
end

-------- BRAIN --------

function whatRating()
	if getModSetting('ratings', 'SaraHUD-R') == 'FC' then
		ratingthing = '% [' .. getProperty('ratingFC') .. ']'
	elseif getModSetting('ratings', 'SaraHUD-R') == 'Name' then
		ratingthing = '% [' .. getProperty('ratingName') .. ']'
	else
		ratingthing = '%'
	end
	return ratingthing
end

function updateCombo()
    judgement = getPropertyFromGroup('notes', sid, 'rating')

    setTextString('comboText', 'x' .. combo)
    setTextString('comboTextFB', 'x' .. combo)

    uit.effect.alpha('comboText', 1, 0, .8, {ease = 'easeOut', startDelay = 1.5})
    uit.effect.alpha('comboTextFB', .5, 0, .2, {ease = 'easeInOut'})
    uit.effect.bop('comboTextFB', 1.2, 1.2, .3, {ease = 'easeOut'})

    uit.effect.alpha('comboRatingText', 1, 0, .8, {ease = 'easeOut', startDelay = 1.2})
    uit.effect.alpha('comboRatingTextFB', .5, 0, .2, {ease = 'easeInOut'})
    uit.effect.bop('comboRatingTextFB', 1.2, 1.2, .3, {ease = 'easeOut'})

    if judgement == 'sick' then
        setTextString('comboRatingText', translate('combo_sick', 'Sick!!'))
        setTextString('comboRatingTextFB', translate('combo_sick', 'Sick!!'))
    elseif judgement == 'good' then
        setTextString('comboRatingText', translate('combo_good', 'Good!'))
        setTextString('comboRatingTextFB', translate('combo_good', 'Good!'))
    elseif judgement == 'bad' then
        setTextString('comboRatingText', translate('combo_bad', 'Bad'))
        setTextString('comboRatingTextFB', translate('combo_bad', 'Bad'))
    elseif judgement == 'shit' then
        setTextString('comboRatingText', translate('combo_shit', 'Shit'))
        setTextString('comboRatingTextFB', translate('combo_shit', 'Shit'))
    end
end

function updateHudExtra()
    judgement = getPropertyFromGroup('notes', sid, 'rating')

    if judgement == 'sick' then
        sicks = sicks + 1
        uit.effect.alpha('sickIcon', .9, .5)
        uit.effect.alpha('sickText', .9, .6)
    elseif judgement == 'good' then
        goods = goods + 1
        uit.effect.alpha('goodIcon', .9, .5)
        uit.effect.alpha('goodText', .9, .6)
    elseif judgement == 'bad' then
        bads = bads + 1
        uit.effect.alpha('badIcon', .9, .5)
        uit.effect.alpha('badText', .9, .6)
    elseif judgement == 'shit' then
        nos = nos + 1
        uit.effect.alpha('noIcon', .9, .5)
        uit.effect.alpha('noText', .9, .6)
    end

    setTextString('sickText', sicks)
    setTextString('goodText', goods)
    setTextString('badText', bads)
    setTextString('noText', nos)
end

function updateHud()
    if getPref('statsType') ~= 'Vanilla' then
        setTextString('ratingText', uit.util.floorDecimal(rating * 100, 2) .. whatRating())
        setTextString('missesText', misses)
    end

    setTextString('scoreText', commas(score))
end

function commas(number)
    local formatted = tostring(number)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(%d+)(%d%d%d)", "%1,%2")
        if k == 0 then
            break
        end
    end
    return formatted
end

function translate(translation_key, text) -- for fellow 0.7.2 users
    output = text
    if version >= '1.0' then
        output = getTranslationPhrase(translation_key, text)
    end
    return output
end

function getPref(tag)
    local output = ''
    if not noOptionsMenu then
        output = getModSetting(tag, 'SaraHUD-R')
    else
        output = pref[tag]
    end
    return output
end