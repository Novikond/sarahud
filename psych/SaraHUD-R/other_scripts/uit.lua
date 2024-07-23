-- > UI Tools (UIT) < -- [by Novikond]

uit = {
    graphics = {
        text = function(tag, text, x, y, width, alignment) -- draw a text
            local exampleText = 'The quick brown fox jumps over the lazy dog. 1234567890'
            makeLuaText(tag, text or exampleText, width or 0, x or 0, y or 0)
            setTextAlignment(tag, alignment or 'left')
            setObjectCamera(tag, 'hud')
            setTextSize(tag, 18)
            setProperty(tag .. '.antialiasing', true)
            setTextFont(tag, 'PhantomMuff.ttf')
            setObjectOrder(tag, getObjectOrder('healthBar') + 100)
            addLuaText(tag, true)
        end,

        img = function(tag, image, x, y, scale) -- draw an image
            local exampleSprite = 'missingSprite'
            makeLuaSprite(tag, image or exampleSprite, x or 0, y or 0) 
            setObjectCamera(tag, 'hud')
            scaleObject(tag, scale or 1, scale or 1)
            setObjectOrder(tag, getObjectOrder('healthBar') + 100)
            addLuaSprite(tag, true)
        end,

        obj = function(tag, x, y, width, height, color) -- draw a simple rectangle
            makeLuaSprite(tag, nil, x or 0, y or 0)
            makeGraphic(tag, width or 100, height or 100, color or '000000')
            setObjectCamera(tag, 'hud')
            addLuaSprite(tag, true)
        end,

        textAtlas = function(tag, image, characterMap, text, x, y, scale) -- object to change probably, poorly made replacement for haxe function
            local offsetX = x or 0
            for i = 1, #text do
                local char = text:sub(i, i)
                local charData = characterMap[char]
                if charData then
                    makeAnimatedLuaSprite(tag .. '-letter-' .. i, image, offsetX, y or 0)
                    addAnimationByPrefix(tag .. '-letter-' .. i, tag .. '-anim-' .. i, characterMap[char][1], 0, false)
                    setObjectCamera(tag .. '-letter-' .. i, 'hud')
                    scaleObject(tag .. '-letter-' .. i, scale or 1, scale or 1)
                    setObjectOrder(tag .. '-letter-' .. i, getObjectOrder('healthBar') + 100)
                    addLuaSprite(tag .. '-letter-' .. i, true)

                    offsetX = offsetX + getProperty(tag .. '-letter-' .. i .. '.width') + charData[2]
                end
            end
        end
    },

    effect = {
        color = function(tag, color, speed, easeType) -- color shift effect
            setProperty(tag .. '.color', getColorFromHex(color))
            doTweenColor(tag .. '-effect-blink', tag, 'ffffff', (speed or 0.2) / playbackRate, easeType or 'linear') -- not using startTween() cuz buggy
        end,

        alpha = function(tag, alphaFrom, alphaTo, speed, options) -- alpha shift effect
            setProperty(tag .. '.alpha', alphaFrom)
            startTween(tag .. '-effect-alpha', tag, {alpha = alphaTo}, (speed or 0.2) / playbackRate, options or nil)
        end,

        bop = function(tag, scaleX, scaleY, speed, options) -- object scale effect
            setProperty(tag .. '.scale.x', scaleX)
            setProperty(tag .. '.scale.y', scaleY)
            startTween(tag .. '-effect-bop-x', tag .. '.scale', {x = 1}, (speed or 0.2) / playbackRate, options or nil)
            startTween(tag .. '-effect-bop-y', tag .. '.scale', {y = 1}, (speed or 0.2) / playbackRate, options or nil)
        end,

        move = function(tag, ogX, ogY, moveX, moveY, speed, options) -- X and Y shift effect
            setProperty(tag .. '.x', ogX + moveX)
            setProperty(tag .. '.y', ogY + moveY)
            startTween(tag .. '-effect-shift-x', tag, {x = ogX}, (speed or 0.2) / playbackRate, options or nil)
            startTween(tag .. '-effect-shift-y', tag, {y = ogY}, (speed or 0.2) / playbackRate, options or nil)
        end
    },

    util = {
        formatTime = function(millisecond) -- converts millisecond to minutes/seconds
            local seconds = math.floor(millisecond / 1000)
            return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60) 
        end,

        floorDecimal = function(value, decimals) -- port of "floorDecimal" from Psych's source code to lua
            if decimals < 1 then return math.floor(value) end

            local tempMult = 1
            for i = 1, decimals do tempMult = tempMult * 10 end
        
            local newValue = math.floor(value * tempMult)
            return newValue / tempMult
        end
    }
}

return uit