--[[ SaraHUD Legacy |3.6|
    Made by Novikond
    Gamebanana: https://gamebanana.com/mods/371851
--]]

-- styles: 'classicTxt', 'classicIco' 'modern', 'cherry', 'disStrum'

-- Settings --
local pref = {
    style ='classicIco', --main thing of hud, all available styles are listed above

    update = true, -- make timer, song-name and health bar overlay have the same alpha as health bar

    timer = true, --display timer
    songName = true, --display song name
    HBoverlay = true, --health bar overlay

    iconPoz = true, --icons not moving and on corners of health bar
    hudMiss = true, --purple miss animation for some hud stuff

    botplHideInfo = false, --when you use botplay, it hide info
    hideInfo = false, --hide info at all
    
    funkyArrow = false, --arrow, that point where your hp (helpful with "iconPoz" pref)
    hpBye = false, --when hp is full, hide health bar
    disableBop = false, --disable icon bop (may be shitty if use without "iconPoz" pref)

    customHBcolors = false, --enable custom colors for health bar
    BFhbColor = '00FF00', --bf side (vanilla fnf '00FF00')
    DADhbColor = 'FF0000', --dad side (vanilla fnf 'FF0000')

    laneUnderlay = 0, --set up transparency
    DADunderlay = false, --enable underlay for opponent too

    cFont = 'PhantomMuff.ttf' --put in mods/fonts
}
-- bottom text --

-- funni code stuff coming (no touchies)
local hudStuff = {'scoreTxt', 'timeTxt', 'timeBar', 'timeBarBG', 'healthBarOverlay'}
local styleStuff = {'misses', 'score', 'rating', 'missesIcon', 'scoreIcon', 'ratingIcon'}
local oppNotes = false

local bopX = 1
local bopY = 1.3

function onCreate()
    if pref.style == 'disStrum' then
        if getPropertyFromClass('ClientPrefs', 'opponentStrums') == true then oppNotes = true end
        setPropertyFromClass('ClientPrefs', 'opponentStrums', false)
    end
end

function onCreatePost()
    for i = 1, 5 do setProperty(hudStuff[i] ..'.visible', false) end --this thing hide vanilla stuff

    switchStyle() -- enable styles

    --preferences
    if pref.songName then songBruh() end
    if pref.timer then timerBruh() end
    if pref.HBoverlay then HBoverlayBruh() end
    if pref.funkyArrow then makeArrow() end
    if pref.customHBcolors then HBcolorsBruh() end
    if pref.hideInfo then hideInfoBruh() end
    if pref.laneUnderlay > 0 then underlayBruh() end
end

function onUpdatePost()
    --preferences ugh
    if pref.iconPoz then iconsBruh() end
    if not pref.iconPoz and pref.style == 'cherry' then cherryIconsBruh() end
    if pref.disableBop then noBopBruh() end
    if pref.botplHideInfo then botplayHideBruh() end
end

function onBeatHit()
    if pref.timer then setTextString('timer', formatTime(getSongPosition() - noteOffset) .. ' / ' .. formatTime(songLength)) end
end

function onUpdate()
    if pref.funkyArrow then arrowBruh() end
    if pref.hpBye then byeHPBruh() end
    if pref.update then updateStuff() end
end

function onRecalculateRating()
    --make info work (thanks to SameTheta for rating percents)
    if pref.style == 'classicIco' or pref.style == 'modern' or pref.style == 'cherry' or pref.style == 'disStrum' then
        setTextString('misses', misses)
        setTextString('score', score)
        setTextString('rating', ratingName..' | '..string.format("%.2f%%", rating * 100)..' ['..getProperty('ratingFC')..']')
    end
    if pref.style == 'classicTxt' then
        setTextString('misses', 'Misses: '..misses)
        setTextString('score', 'Score: '..score)
        setTextString('rating', 'Rating: '..ratingName..' | '..string.format("%.2f%%", rating * 100)..' ['..getProperty('ratingFC')..']')
    end
end

function goodNoteHit() if getPropertyFromClass('ClientPrefs', 'scoreZoom') then infoBopBruh() end end

function noteMiss() if pref.hudMiss == true then hudMissBruh() end end

function onDestroy()
    if oppNotes == true then
        setPropertyFromClass('ClientPrefs', 'opponentStrums', true)
    end
end

-- hud functions starting here

function switchStyle() -- style
    if pref.style == 'classicIco' then
        if not pref.hideInfo then
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 10, downscroll and 18 or 665, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', 10, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', 10, downscroll and getProperty('scoreIcon.y')+42 or getProperty('scoreIcon.y')-42, 0.7)
        end
    end

    if pref.style == 'modern' then
        setProperty('healthBar.x', 110)
        if not pref.hideInfo then
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 820, downscroll and 30 or 650, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', getProperty('ratingIcon.x'), downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', getProperty('missesIcon.x')+120, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
        end
    end

    if pref.style == 'cherry' then --Cherry Style by vCherry.kAI.16 (and Novikond made a bit of changes)
        setProperty('healthBar.x', screenWidth-350)
        setProperty('healthBar.angle', 90)
        screenCenter('healthBar', 'y')

        if not pref.hideInfo then
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 820, downscroll and 30 or 650, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', getProperty('ratingIcon.x'), downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', getProperty('missesIcon.x')+120, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
        end
    end

    if pref.style == 'disStrum' then
        setProperty('healthBar.y', downscroll and 630 or 90); setProperty('healthBar.x', 75)

        if not pref.hideInfo then
            saraSprite('ratingIcon', 'saraHUD/ratingIcon', 10, downscroll and 18 or 665, 0.7)
            saraSprite('scoreIcon', 'saraHUD/scoreIcon', 10, downscroll and getProperty('ratingIcon.y')+42 or getProperty('ratingIcon.y')-42, 0.7)
            saraSprite('missesIcon', 'saraHUD/missesIcon', 10, downscroll and getProperty('scoreIcon.y')+42 or getProperty('scoreIcon.y')-42, 0.7)
        end
    end

    if pref.style == 'classicIco' or pref.style == 'modern' or pref.style == 'cherry' or pref.style == 'disStrum' and not pref.hideInfo then
        saraText('rating', '?', 0, getProperty('ratingIcon.x')+45, getProperty('ratingIcon.y')+9, 20, 'left')
        saraText('score', '0', 0, getProperty('scoreIcon.x')+45, getProperty('scoreIcon.y')+9, 20, 'left')
        saraText('misses', '0', 0, getProperty('missesIcon.x')+45, getProperty('missesIcon.y')+9, 20, 'left')
    end
    if pref.style == 'classicTxt' then
        saraText('rating', 'Rating: ?', 0, 15, downscroll and 22 or 673, 20, 'left')
        saraText('score', 'Score: 0', 0, 15, downscroll and getProperty('rating.y')+30 or getProperty('rating.y')-30, 20, 'left')
        saraText('misses', 'Misses: 0', 0, 15, downscroll and getProperty('score.y')+30 or getProperty('score.y')-30, 20, 'left')
    end
end

function songBruh() -- songName
    if pref.style == 'classicTxt' then
        saraText('song', songName, 500, 0, downscroll and getProperty('healthBar.y')+25 or getProperty('healthBar.y')-40, 20, 'center')
        screenCenter('song', 'x')
    end
    if pref.style == 'classicIco' then
        saraSprite('songIcon', 'saraHUD/songIcon', getMidpointX('healthBar')-160, downscroll and getMidpointY('healthBar')+15 or getMidpointY('healthBar')-45, 0.5)
        saraText('song', songName, 500, getProperty('songIcon.x')+34, getProperty('songIcon.y')+2, 20, 'left')
    end
    if pref.style == 'modern' then
        saraSprite('songIcon', 'saraHUD/songIcon', getMidpointX('healthBar')-215, downscroll and getMidpointY('healthBar')+15 or getMidpointY('healthBar')-45, 0.5)
        saraText('song', songName, 500, getProperty('songIcon.x')+34, getProperty('songIcon.y')+2, 20, 'left')
    end
    if pref.style == 'cherry' then
        saraSprite('songIcon', 'saraHUD/songIcon', 536, downscroll and 648 or 58, 0.4)
        saraText('song', songName, 500, getProperty('songIcon.x')-308, getProperty('songIcon.y')+2, 13, 'right')
    end
    if pref.style == 'disStrum' then
        saraSprite('songIcon', 'saraHUD/songIcon', getMidpointX('healthBar')-215, downscroll and getMidpointY('healthBar')-45 or getMidpointY('healthBar')+15, 0.5)
        saraText('song', songName, 500, getProperty('songIcon.x')+34, getProperty('songIcon.y')+2, 20, 'left')
    end
end

function timerBruh() -- timer
    if pref.style == 'classicTxt' then
        saraText('timer', '0:00 / ' .. formatTime(songLength), 400, 0, downscroll and getProperty('healthBar.y')-40 or getProperty('healthBar.y')+25, 20, 'center')
        screenCenter('timer', 'x')
    end
    if pref.style == 'classicIco' then
        saraSprite('timerIcon', 'saraHUD/timerIcon', getMidpointX('healthBar')+130, downscroll and getMidpointY('healthBar')-45 or getMidpointY('healthBar')+15, 0.5)
        saraText('timer', '0:00 / ' .. formatTime(songLength), 400, getProperty('timerIcon.x')-404, getProperty('timerIcon.y')+2, 20, 'right')
    end
    if pref.style == 'modern' then
        saraSprite('timerIcon', 'saraHUD/timerIcon', getMidpointX('healthBar')+170, downscroll and getMidpointY('healthBar')+15 or getMidpointY('healthBar')-45, 0.5)
        saraText('timer', '0:00 / ' .. formatTime(songLength), 400, getProperty('timerIcon.x')-404, getProperty('timerIcon.y')+2, 20, 'right')
    end
    if pref.style == 'cherry' then
        saraSprite('timerIcon', 'saraHUD/timerIcon', 532, downscroll and 679 or 22, 0.5)
        saraText('timer', '0:00 / ' .. formatTime(songLength), 400, getProperty('timerIcon.x')-204, getProperty('timerIcon.y')+2, 20, 'right')
    end
    if pref.style == 'disStrum' then
        saraSprite('timerIcon', 'saraHUD/timerIcon', getMidpointX('healthBar')+170, downscroll and getMidpointY('healthBar')-45 or getMidpointY('healthBar')+15, 0.5)
        saraText('timer', '0:00 / ' .. formatTime(songLength), 400, getProperty('timerIcon.x')-404, getProperty('timerIcon.y')+2, 20, 'right')
    end
end

function iconsBruh() -- iconPoz
    if pref.style == 'classicIco' or pref.style == 'classicTxt' or pref.style == 'modern' or pref.style == 'disStrum' then
        setProperty('iconP1.x', getMidpointX('healthBar')+224)
        setProperty('iconP2.x', getMidpointX('healthBar')-374)
        setProperty('iconP1.y', getMidpointY('healthBar')-75)
        setProperty('iconP2.y', getMidpointY('healthBar')-75)
    end
    if pref.style == 'cherry' then
        setProperty('iconP1.x', 287)
        setProperty('iconP2.x', 172)

        if pref.hideInfo or pref.extraInfo == 'cherry' then
            setProperty('iconP1.x', 620)
            setProperty('iconP2.x', 510)
        end
    end
end

function underlayBruh() -- laneUnderlay
    if pref.style == 'disStrum' then pref.DADunderlay = false end

    local notew = (getPropertyFromClass('Note', 'swagWidth')-1)*4

    saraGraphic('BFund', getPropertyFromGroup('playerStrums', 0, 'x'), 0, notew, screenWidth, '000000')
    setProperty('BFund.alpha', pref.laneUnderlay)
    setObjectOrder('BFund', getObjectOrder('strumLineNotes') - 1)

    if pref.DADunderlay then
        saraGraphic('DADund', getPropertyFromGroup('opponentStrums', 0, 'x'), 0, notew, screenWidth, '000000')
        setProperty('DADund.alpha', pref.laneUnderlay)
        setObjectOrder('DADund', getObjectOrder('strumLineNotes') - 1)
    end
end

function HBoverlayBruh() -- HBoverlay
    makeLuaSprite('healthBarOver', 'saraHUD/healthBarOver', getProperty('healthBar.x') - 4, getProperty('healthBar.y') - 4.9)
    setObjectCamera('healthBarOver', 'hud'); setScrollFactor('healthBarOver', 0.9, 0.9)
    setProperty('healthBarOver.angle', getProperty('healthBar.angle'))
    setObjectOrder('healthBarOver', getObjectOrder('healthBar') + 1)
    addLuaSprite('healthBarOver', true)
end

function noBopBruh() scaleObject('iconP1', 1, 1); scaleObject('iconP2', 1, 1) end -- disableBop

function hudMissBruh() -- hudMiss
    for i = 1, 6 do missEffect(styleStuff[i]) end
end

function HBcolorsBruh() setHealthBarColors(pref.DADhbColor, pref.BFhbColor) end -- customHBcolors

function infoBopBruh() -- infoBop
    for i = 1, 3 do bop(styleStuff[i], bopX, bopY) end
end

function botplayHideBruh() -- botplHideInfo
    if botPlay then
        for i = 1, 6 do setProperty(styleStuff[i]..'.visible', false) end
    else
        for i = 1, 6 do setProperty(styleStuff[i]..'.visible', true) end
    end
end

function makeArrow() -- funkyArrow
    if pref.style == 'classicIco' or pref.style == 'classicTxt' then
        saraText('HParrow', '+', 0, 0, getProperty('healthBar.y')-18, 36, 'center')
    end
    if pref.style == 'modern' then
        saraText('HParrow', '>', 0, 0, downscroll and getProperty('healthBar.y')-45 or getProperty('healthBar.y')+10, 36, 'center')
        setProperty('HParrow.angle', downscroll and 90 or 270)
    end
    if pref.style == 'disStrum' then
        saraText('HParrow', '>', 0, 0, downscroll and getProperty('healthBar.y')+10 or getProperty('healthBar.y')-45, 36, 'center')
        setProperty('HParrow.angle', downscroll and 270 or 90)
    end
    if pref.style == 'cherry' then
        saraText('HParrow', '>', 0, getProperty('healthBar.x')+255, 0, 36, 'center')
    end
    setProperty('HParrow.alpha', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
end

function arrowBruh() -- funkyArrow
    if pref.style == 'classicIco' or pref.style == 'classicTxt' then
        traceHP('HParrow', 'x', 5.9, 580)
    end
    if pref.style == 'modern' or pref.style == 'disStrum' then
        traceHP('HParrow', 'x', 5.9, 585)
    end
    if pref.style == 'cherry' then
        traceHP('HParrow', 'y', 5.9, 280)
    end
end

function verticalIconsBruh()
    setProperty('iconP1.x', getMidpointX('healthBar')-80)
    setProperty('iconP2.x', getMidpointX('healthBar')-80)
    traceHP('iconP1', 'y', 5.9, 280)
    traceHP('iconP2', 'y', 5.9, 180)
end

function byeHPBruh() -- hpBye (HP Bar Go Bye-Bye -Cherry)
    if getProperty('health') <= 1.99 and getProperty('health') >= 1.94 then
        doTweenAlpha('bruhHP1', 'healthBar', 0, 0.1, 'linear')
        doTweenAlpha('icon1Bye', 'iconP1', 0, 0.1, 'linear')
        doTweenAlpha('icon2Bye', 'iconP2', 0, 0.1, 'linear')
        if pref.HBoverlay then
            doTweenAlpha('bruhHP2', 'healthBarOver', 0, 0.1, 'linear')
        end
        if pref.funkyArrow then
            doTweenAlpha('whatArr', 'HParrow', 0, 0.1, 'linear')
        end

    elseif getProperty('health') <= 1.93 then
        doTweenAlpha('bruhHP1', 'healthBar', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'), 0.1, 'linear')
        doTweenAlpha('icon1Bye', 'iconP1', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'), 0.1, 'linear')
        doTweenAlpha('icon2Bye', 'iconP2', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'), 0.1, 'linear')
        if pref.HBoverlay then
            doTweenAlpha('bruhHP2', 'healthBarOver', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'), 0.1, 'linear')
        end
        if pref.funkyArrow then
            doTweenAlpha('whatArr', 'HParrow', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'), 0.1, 'linear')
        end
    end
end

function updateStuff() -- update
    if pref.HBoverlay then
        setProperty('healthBarOver.alpha', getProperty('healthBar.alpha'))
        setProperty('healthBarOver.visible', getProperty('healthBar.visible'))
    end
    if pref.songName then
        setProperty('song.alpha', getProperty('healthBar.alpha'))
        setProperty('song.visible', getProperty('healthBar.visible'))
        setProperty('songIcon.alpha', getProperty('healthBar.alpha'))
        setProperty('songIcon.visible', getProperty('healthBar.visible'))
    end
    if pref.timer then
        setProperty('timer.alpha', getProperty('healthBar.alpha'))
        setProperty('timer.visible', getProperty('healthBar.visible'))
        setProperty('timerIcon.alpha', getProperty('healthBar.alpha'))
        setProperty('timerIcon.visible', getProperty('healthBar.visible'))
    end
end

-- shortcuts or something (saralib beta lmao)

function saraText(tag, text, width, x, y, tSize, alignment)
    local gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")
    makeLuaText(tag, text, width, x, y)
    setTextSize(tag, tSize)
    setObjectCamera(tag, 'hud')
    setTextAlignment(tag, alignment)
    setTextFont(tag, pref.cFont)
    setProperty(tag .. '.antialiasing', gAA)
    setObjectOrder(tag, 60)
    addLuaText(tag, true)
end

function saraSprite(tag, image, x, y, size)
    makeLuaSprite(tag, image, x, y)
    scaleObject(tag, size, size)
    setObjectCamera(tag, 'hud')
    setObjectOrder(tag, 60)
    addLuaSprite(tag, true)
end

function saraGraphic(tag, x, y, width, height, color)
    makeLuaSprite(tag, nil, x, y)
    makeGraphic(tag, width, height, color)
    setObjectCamera(tag, 'hud')
    addLuaSprite(tag, true)
end

function missEffect(tag)
    setProperty(tag..'.color', getColorFromHex('5f1ea4'))
    doTweenColor(tag, tag, 'FFFFFF', 0.3, 'linear')
end

function bop(tag, scaleX, scaleY)
    setProperty(tag..'.scale.x', scaleX)
    setProperty(tag..'.scale.y', scaleY)
    doTweenX(tag..'BOPx', tag..'.scale', 1, 0.1, 'linear')
    doTweenY(tag..'BOPy', tag..'.scale', 1, 0.1, 'linear')
end

function formatTime(millisecond)
    local seconds = math.floor(millisecond / 1000)
    return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60)  
end

function traceHP(obj, XorY, mult, adjust)
    local hp = getProperty('healthBar.percent')*mult
    setProperty(obj..'.'..XorY, getProperty('healthBar.'..XorY)-hp+adjust)
end