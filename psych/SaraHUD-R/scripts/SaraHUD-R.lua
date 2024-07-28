-- > SaraHUD:R < -- [by Novikond]


-------- DEBUG --------
local noOptionsMenu = false -- if [true], uses the old fashioned way to manage preferences
local pref = { -- all the preferences are executed in this order, don't tweak the order plz
    -- disaplayed info
    statsType = 'SaraHUD',
    extraStats = false,
    etternaBar = true,
    ratings = 'FC',

    -- visuals
    notesPrior = true,
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
	{'noText', 'ffd0da'},

    {'comboText', 'd6ffeb'}
}

local comboThings = {'comboBgTop', 'comboBg', 'comboBgBottom', 'comboSprite', 'comboText'}
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

-------- PREFERENCES --------

local createState = {
    statsType = function()
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
    end,

    extraStats = function()
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
    end,

    etternaBar = function()
        if timeBarType ~= 'Disabled' then
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
        end
    end,

    comboReplace = function()
        setProperty('showRating', false)
		setProperty('showComboNum', false)
		setProperty('showCombo', false)

        uit.graphics.obj('comboBg', 0, downscroll and screenHeight - 30 or 150, 180, 80)
        screenCenter('comboBg', 'x')

        uit.graphics.img('comboBgTop', 'GUI/combo-top', getProperty('comboBg.x'), getProperty('comboBg.y') - 26)
        uit.graphics.img('comboBgBottom', 'GUI/combo-bottom', getProperty('comboBg.x'), getProperty('comboBg.y') + getProperty('comboBg.height'))

        for i = 1, 3 do
            setProperty(comboThings[i] .. '.antialiasing', false)
        end

        uit.graphics.img('comboSprite', 'saraHUD/comboSprite', 0, downscroll and screenHeight - 30 or 140, .7)
        screenCenter('comboSprite', 'x'); setProperty('comboSprite.x', getProperty('comboSprite.x') + 4)

        uit.graphics.text('comboText', 'Sick!! [000]', 0, downscroll and getProperty('comboSprite.y') - 60 or getProperty('comboSprite.y') + 55, 400, 'center')
        setTextSize('comboText', 20)
        screenCenter('comboText', 'x')

        for i = 1, #comboThings do
            setProperty(comboThings[i] .. '.alpha', 0)
        end
    end,

    notesPrior = function()
        setObjectOrder('noteGroup', getObjectOrder('healthBar') + 100)
    end,

    replaceHB = function()
		loadGraphic('healthBar.bg', 'GUI/healthBar')
	end,

	replaceTB = function()
		loadGraphic('timeBar.bg', 'GUI/timeBar')
	end,
}

local updateState = {
    etternaBar = function()
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
    end
}

-------- BRAIN --------

function canonevent(number)
	if number >= 0 and number < 10 then
		return '00' .. number
	elseif number >= 10 and number < 100 then
		return '0' .. number
	else
		return number
	end
end

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

function grabRating()
	local curRating = 'Sick!!'
	if getPropertyFromGroup('notes', sid, 'rating') == 'sick' then
		curRating = 'Sick!!'
	elseif getPropertyFromGroup('notes', sid, 'rating') == 'good' then
		curRating = 'Good!'
	elseif getPropertyFromGroup('notes', sid, 'rating') == 'bad' then
		curRating = 'Bad'
	elseif getPropertyFromGroup('notes', sid, 'rating') == 'shit' then
		curRating = 'Shit'
	end
	return curRating
end

function updateCombo()
    setTextString('comboText', grabRating() .. ' [' .. canonevent(combo) .. ']')

    for i = 1, 3 do
        uit.effect.alpha(comboThings[i], .24, 0, 1.2, {ease = 'easeInOut', startDelay = 1})
    end
    for i = 4, 5 do
        uit.effect.alpha(comboThings[i], 1, 0, 1.2, {ease = 'easeInOut', startDelay = 1})
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
    setTextString('scoreText', score)
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

-------- PSYCH FUNCTIONS --------

function onCreate()
	if version ~= '0.7.3' and getModSetting('outdateCheck', 'SaraHUD-R') then
		setVar('shud_outdated', true)
		bruh = true
	end
	if not checkFileExists(getTextFromFile('data/SHUDlibs.txt') .. 'uit.lua') then
		setVar('shud_noLibs', true)
		bruh = true
	else
		uit = require('mods/' .. getTextFromFile('data/SHUDlibs.txt') .. 'uit')
	end
	if bruh then -- i really hope it will help people.
		addLuaScript('other_scripts/error.lua')
	end
end

function onCreatePost()
    for k, _ in pairs(pref) do
        if getPref(k) ~= false then
            local func = createState[k]
            if func then
                func()
            end
        end
    end

    setProperty('scoreTxt.visible', false)

    if not getPref('etternaBar') then
        setTextSize('timeTxt', 18) 
        setTextFont('timeTxt', 'PhantomMuff.ttf')
        setProperty('timeTxt.antialiasing', true)
        setProperty('timeTxt.y', getProperty('timeBar.y'))
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
    for k, _ in pairs(pref) do
        if getPref(k) ~= false then
            local func = updateState[k]
            if func then
                func()
            end
        end
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

        if getPref('comboReplace') and combo >= 5 then
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