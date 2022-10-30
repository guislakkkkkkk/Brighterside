local allowCountdown = false
local waitThing = false
local confirmed = 0

function onCreate()
    if isStoryMode then
        screenCenter('imagetag', 'xy')
        setObjectCamera('imagetag', 'other')
        

        makeLuaText('continue', "Press SPACE to Begin Song", 0.8, 520, 220)
        setObjectCamera('continue', 'other')
        addLuaText('continue', true)
    end
end
function onStartCountdown()
    if not waitThing and isStoryMode and not seenCutscene then
        startVideo('ReignCutscene');
        waitThing = true
        return Function_Stop;
    end

    if isStoryMode and not allowCountdown then
        return Function_Stop
    end
    if isStoryMode and allowCountdown then
        return Function_Continue
    end
    return Function_Continue;
end
function onUpdate()
    if     isStoryMode and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and confirmed == 0 then
        allowCountdown = true
        startCountdown();
        doTweenAlpha('imagetag', 'imagetag', 0, 1, sineOut);
        doTweenAlpha('continue', 'continue', 0, 1, sineOut);
        playSound('cancelMenu');
        confirmed = 1
    end
end