--will finish later

function onCreate()
	if version ~= '0.7.3' and getModSetting('outdateCheck', 'SaraHUD') then
		setVar('shud_outdated', true)
		bruh = true
	end

	if not checkFileExists(getTextFromFile('data/SHUDlibs.txt') .. 'saraTools.lua') then
		setVar('shud_noLibs', true)
		bruh = true
	else
		saraTools = require('mods/' .. getTextFromFile('data/SHUDlibs.txt') .. 'saraTools')
	end

	if bruh then 
		addLuaScript('other_scripts/error.lua')
	end

	if getModSetting('rasmasa', 'SaraHUD') and not bruh then
		addLuaScript('other_scripts/rasmasa.lua')
	end
end