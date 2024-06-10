--[[ SaraHUD Legacy |3.7b|
    Made by Novikond
    With some help from ChatGPT, Character.AI, Midjourney, ROBLOX AI and more
]]

--[[
    YOU CAN'T CHANGE PREFERENCES IN THIS SCRIPT FROM NOW ON, HEAD TO MODS MENU AND CHANGE PREFERENCES JUST LIKE IT IS IN SARAHUD REBORN!!
    YOU CAN'T CHANGE PREFERENCES IN THIS SCRIPT FROM NOW ON, HEAD TO MODS MENU AND CHANGE PREFERENCES JUST LIKE IT IS IN SARAHUD REBORN!!
    YOU CAN'T CHANGE PREFERENCES IN THIS SCRIPT FROM NOW ON, HEAD TO MODS MENU AND CHANGE PREFERENCES JUST LIKE IT IS IN SARAHUD REBORN!!
]]

-- funni code stuff coming (no touchies)
local hudStuff = {'scoreTxt', 'timeTxt', 'timeBar', 'timeBarBG', 'healthBarOverlay'}
local styleStuff = {'misses', 'score', 'rating', 'missesIcon', 'scoreIcon', 'ratingIcon'}
local lmao = true

local bopX = 1
local bopY = 1.3

leg_text = function(tag, text, width, x, y)
	makeLuaText(tag, text, width, x, y)
	setTextAlignment(tag, 'left')
	setObjectCamera(tag, 'hud')
	setTextSize(tag, 20)
	setObjectOrder(tag, getObjectOrder('healthBar') + 100)
	addLuaText(tag, true)
end

leg_sprite = function(tag, image, x, y)
	makeLuaSprite(tag, image, x, y) 
	setObjectCamera(tag, 'hud')
	scaleObject(tag, .27, .27)
	setObjectOrder(tag, getObjectOrder('healthBar') + 100)
	addLuaSprite(tag, true)
end

function onCreate()
    if getModSettings('style', 'SaraHUDle') == 'classicIco' then
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 10, downscroll and 18 or 665, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', 10, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', 10, downscroll and getProperty('scoreIcon.y')+42 or getProperty('scoreIcon.y')-42, 0.7)
    end

    if getModSettings('style', 'SaraHUDle') == 'modern' then
        setProperty('healthBar.x', 110)
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 820, downscroll and 30 or 650, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', getProperty('ratingIcon.x'), downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', getProperty('missesIcon.x')+120, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
    end

    if getModSettings('style', 'SaraHUDle') == 'cherry' then --Cherry Style by vCherry.kAI.16 (and Novikond made a bit of changes)
        setProperty('healthBar.x', screenWidth-350)
        setProperty('healthBar.angle', 90)
        screenCenter('healthBar', 'y')

            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 820, downscroll and 30 or 650, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', getProperty('ratingIcon.x'), downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', getProperty('missesIcon.x')+120, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
    end

    if getModSettings('style', 'SaraHUDle') == 'disStrum' then
        setProperty('healthBar.y', downscroll and 630 or 90); setProperty('healthBar.x', 75)

            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 10, downscroll and 18 or 665, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', 10, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', 10, downscroll and getProperty('scoreIcon.y')+42 or getProperty('scoreIcon.y')-42, 0.7)
    end

    if getModSettings('style', 'SaraHUDle') == 'classicIco' or getModSettings('style', 'SaraHUDle') == 'modern' or getModSettings('style', 'SaraHUDle') == 'cherry' or getModSettings('style', 'SaraHUDle') == 'disStrum' and not getModSettings('hideInfo', 'SaraHUDle') then
        saraText('rating', '?', 0, getProperty('ratingIcon.x')+45, getProperty('ratingIcon.y')+9, 20, 'left')
        saraText('score', '0', 0, getProperty('scoreIcon.x')+45, getProperty('scoreIcon.y')+9, 20, 'left')
        saraText('misses', '0', 0, getProperty('missesIcon.x')+45, getProperty('missesIcon.y')+9, 20, 'left')
    end
    if getModSettings('style', 'SaraHUDle') == 'classicTxt' then
        saraText('rating', 'Rating: ?', 0, 15, downscroll and 22 or 673, 20, 'left')
        saraText('score', 'Score: 0', 0, 15, downscroll and getProperty('rating.y')+30 or getProperty('rating.y')-30, 20, 'left')
        saraText('misses', 'Misses: 0', 0, 15, downscroll and getProperty('score.y')+30 or getProperty('score.y')-30, 20, 'left')
    end
    -- ok first of all we dont even have "saratext()" in this script, second of all getmodsetting is misspelled lol, let's do a little bit of trolling
end

function onCreatePost()
    for i = 1, 5 do setProperty(hudStuff[i] ..'.visible', false) end

    leg_sprite('ratingIcon', 'ratingIcon', 10, downscroll and 18 or 665)
    leg_sprite('scoreIcon', 'scoreIcon', 10, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42)
    leg_sprite('missesIcon', 'missesIcon', 10, downscroll and getProperty('scoreIcon.y')+42 or getProperty('scoreIcon.y')-42)

    leg_text('rating', '?', 0, getProperty('ratingIcon.x')+46, getProperty('ratingIcon.y')+9)
    leg_text('score', '0', 0, getProperty('scoreIcon.x')+46, getProperty('scoreIcon.y')+9)
    leg_text('misses', '0', 0, getProperty('missesIcon.x')+46, getProperty('missesIcon.y')+9)

    loadGraphic('healthBar.bg', 'healthBarOver')
end

function onUpdatePost() -- holy fuck please stop trying to bring it back it makes me want to vomit
    setProperty('iconP1.x', getMidpointX('healthBar')+224)
    setProperty('iconP2.x', getMidpointX('healthBar')-374)
    setProperty('iconP1.y', getMidpointY('healthBar')-75)
    setProperty('iconP2.y', getMidpointY('healthBar')-75)
end

function onSongStart()
    openCustomSubstate('trolling', true)
end

function onCustomSubstateCreatePost()
    makeLuaSprite('h', nil, 0, 0)
	makeGraphic('h', screenWidth, screenHeight, '000000')
	setObjectCamera('h', 'other')
	addLuaSprite('h', true)

    leg_sprite('sarahud', 'dadada', 0, 0, 0)
    setObjectCamera('sarahud', 'other')
    setProperty('sarahud.antialiasing', false)
    setGraphicSize('sarahud', 0)
    screenCenter('sarahud')

    leg_text('bruh', 'i am never porting it on 0.7 because i dont like it\npress enter and never ask for the port plz')
    setObjectCamera('bruh', 'other')
    setProperty('bruh.alpha', 0)

    startTween('wtf', 'sarahud.scale', {x = 1.8, y = 1.8}, 30, {startDelay = 4, onComplete = 'mrow'})
    playSound('dadada')
end

function onCustomSubstateUpdatePost()
    if keyboardJustPressed('ENTER') then
        os.exit()
    end
end

function mrow()
    startTween('bah', 'bruh', {alpha = .5}, 2, {startDelay = 3.5})
end