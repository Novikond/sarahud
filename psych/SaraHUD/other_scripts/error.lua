local make_text = function(text)
    makeLuaText('hey', text, 0, 0, 0)
    setObjectCamera('hey', 'other')
    setTextSize('hey', 20)
    screenCenter('hey') -- idk why it's not centered enough
    setProperty('hey.x', getProperty('hey.x') - 50)
    addLuaText('hey', true)
end

local errorType = { -- yay or nay
    ['outdated'] = false,
    ['noLibs'] = false
}

local errorsState = { -- messages
    ['outdated'] = function()
        errorType['noLibs'] = false

        local buh = [[
        Your Psych Engine version is out of date. Update to 0.7.3 to use SaraHUD.

        You can download the latest version of Psych Engine on the GameBanana page.

        If you wish to stop seeing this message, go to the mod's settings and disable version checking.


        Press <TAB> to open the GameBanana page.

        Press <ENTER> to exit the song.
        ]]

        make_text(buh)
    end,
    ['noLibs'] = function()
        local buh = [[
        Failed to load the SaraTools library, check that all files are installed correctly.

        Lost? Read through the guide on SaraHUD's GameBanana page.


        Press <TAB> to open the GameBanana page.

        Press <ENTER> to exit the song.
        ]]

        make_text(buh)
    end
}

local errorsLinks = {
    ['outdated'] = function()
        os.execute('start https://gamebanana.com/mods/309789')
    end,
    ['noLibs'] = function()
        os.execute('start https://gamebanana.com/mods/371851')
    end
}

function onCreate()
    for i, _ in pairs(errorType) do
        if getVar('shud_' .. i) then errorType[i] = true end
    end
end

function onCountdownTick(h)
    if h == 3 then
        for i, _ in pairs(errorType) do
            if errorType[i] then openCustomSubstate(i .. 'State', true) end
        end
    end
end

function onCustomSubstateCreatePost()
    makeLuaSprite('h', nil, 0, 0)
	makeGraphic('h', screenWidth, screenHeight, '000000')
	setObjectCamera('h', 'other')
	addLuaSprite('h', true)

    for i, _ in pairs(errorType) do
        if errorType[i] then errorsState[i]() end
    end
end

function onCustomSubstateUpdatePost()
    if keyboardJustPressed('ENTER') then
        exitSong()
    end
    if keyboardJustPressed('TAB') then
        for i, _ in pairs(errorType) do
            if errorType[i] then errorsLinks[i]() end
        end
    end
end