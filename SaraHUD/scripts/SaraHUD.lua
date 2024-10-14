-- > SaraHUD < -- [by Novikond]

-------- DEBUG --------
local noOptionsMenu = false -- if [true], uses the old fashioned way to manage preferences
local pref = {
    -- disaplayed info
    statsType = 'Vanilla',
    extraStats = false,
    timeMod = true,
    ratings = 'FC',

    -- visuals
    replaceHB = true,
    replaceTB = true,
    comboReplace = false,
    coloredText = true,

    laneUnderlay = 0,
    oppUnderlay = false,

    -- technical
    outdateCheck = true
}

-------- VARS --------

local uit -- prev. known as "saraTools"

local textColors

local comboThings = {'comboText', 'comboTextFB', 'comboRatingText'}
local bg = {'infoBgLeft', 'infoBg', 'infoBgRight'}
local extrSim = {'sick', 'good', 'bad', 'no'}
local extrFul = {'combo', 'tnh'}

local statsWidth = 20
local ratingthing = '%'

local sid -- ik i could make it easier, don't look at me like that
local sicks = 0
local goods = 0
local bads = 0
local nos = 0

-------- PSYCH FUNCTIONS, PREFERENCES --------

function onCreate()
    if version <= "0.7.3" then modFolder = 'SaraHUD' end -- poor 0.7 users
    uit = require(getTextFromFile('lib_path.txt') .. 'uit')
    textColors = uit.util.tomlParse(getTextFromFile(modFolder .. '/data/text_colors.toml'))
end

function onCreatePost()
    setProperty('scoreTxt.visible', false)

    setTextSize('timeTxt', 22)
    setTextFont('timeTxt', 'PhantomMuff.ttf')
    setProperty('timeTxt.antialiasing', true)
    setProperty('timeTxt.y', getProperty('timeBar.y') - 4)

    if not hideHud then
        if getPref('statsType') == 'Vanilla' then
            uit.graphics.obj('infoBg',  (screenWidth / 2) + 15, getProperty('healthBar.y') + 30, 200, 40)
            uit.graphics.img('infoBgLeft', 'GUI/round-vanilla', getProperty('infoBg.x') - 10, getProperty('infoBg.y'))
            uit.graphics.img('infoBgRight', 'GUI/fade-vanilla', getProperty('infoBg.x') + getProperty('infoBg.width'), getProperty('infoBg.y'))
            setProperty('infoBgRight.flipX', true)

            for i = 1, #bg do
                setProperty(bg[i] .. '.alpha', .16)
            end

            uit.graphics.img('missesIcon', 'saraHUD/missesIcon', (screenWidth / 2) + 20, getProperty('healthBar.y') + 34, .54)
            uit.graphics.text('missesText', '0', getProperty('missesIcon.x') + 38, getProperty('missesIcon.y') + 6, 0)

            uit.graphics.img('scoreIcon', 'saraHUD/scoreIcon', (screenWidth / 2) + 100, getProperty('healthBar.y') + 34, .54)
            uit.graphics.text('scoreText', '0', getProperty('scoreIcon.x') + 38, getProperty('scoreIcon.y') + 6, 0)

        elseif getPref('statsType') == 'Alt' then
            uit.graphics.obj('infoBg', 30, downscroll and 25 or screenHeight - 121, 180, 100)
            uit.graphics.img('infoBgLeft', 'GUI/fade-shud', getProperty('infoBg.x') - 30, getProperty('infoBg.y'))
            uit.graphics.img('infoBgRight', 'GUI/round-shud', getProperty('infoBg.x') + getProperty('infoBg.width'), getProperty('infoBg.y'))

            setProperty('infoBgRight.flipX', true)

            for i = 1, #bg do
                setProperty(bg[i] .. '.alpha', .16)
            end

            uit.graphics.img('ratingIcon', 'saraHUD/ratingIcon', 15, downscroll and 16 or screenHeight - 50, .62)
            uit.graphics.img('scoreIcon', 'saraHUD/scoreIcon', 15, downscroll and getProperty('ratingIcon.y') + 40 or getProperty('ratingIcon.y') - 40, .62)
            uit.graphics.img('missesIcon', 'saraHUD/missesIcon', 15, downscroll and getProperty('scoreIcon.y') + 40 or getProperty('scoreIcon.y') - 40, .62)

            uit.graphics.text('ratingText', '?', getProperty('ratingIcon.x') + 50, getProperty('ratingIcon.y') + 9)
            uit.graphics.text('scoreText', '0', getProperty('scoreIcon.x') + 50, getProperty('scoreIcon.y') + 9)
            uit.graphics.text('missesText', '0', getProperty('missesIcon.x') + 50, getProperty('missesIcon.y') + 9)
        end
    end

    if getPref('replaceHB') then
		loadGraphic('healthBar.bg', 'bars/healthBar_grad')
	end

	if getPref('replaceTB') then
		loadGraphic('timeBar.bg', 'bars/timeBar_grad')
	end

    if getPref('timeMod') then
        if getPref('replaceTB') then 
            loadGraphic('timeBar.bg', 'bars/timeBar_mod_grad')
        else
            loadGraphic('timeBar.bg', 'bars/timeBar_mod')
        end

        loadGraphic('timeBar.leftBar', 'bars/timeBar_fill_mod')
        loadGraphic('timeBar.rightBar', 'bars/timeBar_fill_mod')
        setProperty('timeBar.barWidth', getProperty('timeBar.width'))

        screenCenter('timeBar', 'x')
        setProperty('timeBar.y', middlescroll and (downscroll and screenHeight - 22 or 25) or (downscroll and screenHeight - 60 or 50))

        setTextSize('timeTxt', 18)
        setTextAlignment('timeTxt', 'right')

        uit.graphics.text('fcTxt', '[N/A]', getProperty('timeBar.x'), getProperty('timeBar.y') - 18, 400)

        if timeBarType == 'Song Name' then
            setTextString('timeTxt', shortenText(getTextString('timeTxt'), 6))
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

    if getPref('comboReplace') then
        setProperty('showComboNum', false)
        setProperty('showCombo', false)
        setProperty('showRating', false)

        uit.graphics.text('comboText', 'x5', getProperty('healthBar.x') + getProperty('healthBar.width') - 300, getProperty('healthBar.y') - 40, 300, 'right')
        setTextFont('comboText', 'Newgrounds.otf')
        setTextBorder('comboText', 3, '000000')
        setTextSize('comboText', 40)

        uit.graphics.text('comboTextFB', 'x5', getProperty('comboText.x') - 15, getProperty('comboText.y'), 300, 'right') -- FB stands for feedback
        setTextFont('comboTextFB', 'Newgrounds.otf')
        setTextSize('comboTextFB', 40)

        uit.graphics.text('comboRatingText', 'Sick!!', screenWidth / 2 - 150, middlescroll and (downscroll and screenHeight - 210 or 180) or (downscroll and screenHeight - 150 or 85), 300, 'center')
        setTextFont('comboRatingText', 'Newgrounds.otf')
        setTextBorder('comboRatingText', 3, '000000')
        setTextSize('comboRatingText', 40)

        for i = 1, #comboThings do
            setProperty(comboThings[i] .. '.alpha', 0)
        end
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

    for key, value in pairs(textColors) do
        setTextColor(key, value)
    end
end

function onUpdatePost()
    if getPref('timeMod') and timeBarType ~= 'Disabled' then
        uit.util.oto('timeTxt', 'timeBar', {x = getProperty('timeBar.width') - 400, y = -18, alpha = true})
        uit.util.oto('fcTxt', 'timeBar', {x = 0, y = -18, alpha = true})
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

-------- BRAIN --------

function niceFcBro()
    local yip = ''
    if not getPref('timeMod') then
        yip = ' [' .. getProperty('ratingFC') .. ']'
    end
    return yip
end

function translate(translation_key, text) -- poor 0.7 users (part 2)
    local output = text
    if version >= '1.0' then
        output = getTranslationPhrase(translation_key, text)
    end
    return output
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

function shortenText(text, maxLength)
    if #text > maxLength then
        return string.sub(text, 1, maxLength - 1) .. "..."
    else
        return text
    end
end

function getPref(tag)
    local output = ''
    if not noOptionsMenu then
        output = getModSetting(tag, 'SaraHUD')
    else
        output = pref[tag]
    end
    return output
end

function updateHud()
    if getPref('statsType') ~= 'Vanilla' then -- alr i won't delete ratings
        setTextString('ratingText', uit.util.floorDecimal(rating * 100, 2) .. '%' .. niceFcBro())
    end
    setTextString('missesText', misses)
    setTextString('scoreText', commas(score))
    setTextString('fcTxt', '[' .. getProperty('ratingFC') .. ']')
end

function updateCombo()
    judgement = getPropertyFromGroup('notes', sid, 'rating')

    setTextString('comboText', 'x' .. combo)
    setTextString('comboTextFB', 'x' .. combo)

    uit.effect.alpha('comboText', 1, 0, .8, {ease = 'easeOut', startDelay = 1.5})
    uit.effect.alpha('comboTextFB', .5, 0, .2, {ease = 'easeInOut'})
    uit.effect.bop('comboTextFB', 1.2, 1.2, .3, {ease = 'easeOut'})

    uit.effect.move('comboRatingText', screenWidth / 2 - 150, middlescroll and (downscroll and screenHeight - 210 or 180) or (downscroll and screenHeight - 150 or 85), 0, 5, .1, {ease = 'easeIn'})
    uit.effect.alpha('comboRatingText', 1, 0, .8, {ease = 'easeOut', startDelay = 1.2})


    if judgement == 'sick' then
        uit.effect.color('comboRatingText', 'cee8c8', nil, {ease = 'easeIn'})
        setTextString('comboRatingText', translate('combo_sick', 'Sick!!'))
    elseif judgement == 'good' then
        uit.effect.color('comboRatingText', 'cae9e9', nil, {ease = 'easeIn'})
        setTextString('comboRatingText', translate('combo_good', 'Good!'))
    elseif judgement == 'bad' then
        uit.effect.color('comboRatingText', 'e0cbc0', nil, {ease = 'easeIn'})
        setTextString('comboRatingText', translate('combo_bad', 'Bad'))
    elseif judgement == 'shit' then
        uit.effect.color('comboRatingText', 'dfb8c0', nil, {ease = 'easeIn'})
        setTextString('comboRatingText', translate('combo_shit', 'Shit'))
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