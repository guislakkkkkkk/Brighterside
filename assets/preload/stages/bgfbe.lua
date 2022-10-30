
math.randomseed( os.time() )

function onCreatePost()
	makeLuaSprite('bgw1','weekbs/fleshbackground',-393.15, -395.45)
    makeLuaSprite('bgw2','weekbs/fleshtendons',-393.15, -395.45)
    makeLuaSprite('bgw3','weekbs/fleshchunkbackleft',-393.15, -395.45)
    makeLuaSprite('bgw4','weekbs/fleshright',-373.15, -395.45)
    makeLuaSprite('bgw5','weekbs/fleshforeground',-393.15, -395.45)

    makeAnimatedLuaSprite('bgw6','weekbs/minionleftright',600, -200)
    addAnimationByPrefix('bgw6', 'idle dance')
    objectPlayAnimation('bgw6', 'idle dance')

    makeAnimatedLuaSprite('bgw7','weekbs/minionupdown',900, -200)
    addAnimationByPrefix('bgw7', 'idle dance')
    objectPlayAnimation('bgw7', 'idle dance')
    scaleObject('bgw7', 0.5, 0.5)

    makeAnimatedLuaSprite('pit', 'weekbs/minionpit', -750, -400) -- -725
    addAnimationByPrefix('pit', 'idle')
    objectPlayAnimation('pit', 'idle')

    makeAnimatedLuaSprite('bigminion', 'weekbs/bigminion', -775, -100) -- -775, -800
    addAnimationByPrefix('bigminion', 'bounce')
    objectPlayAnimation('bigminion', 'bounce')

    addLuaSprite('bgw1',false)
	scaleObject('bgw1', 1.2, 1)
    setScrollFactor('bgw1', 1.15, 1)

    addLuaSprite('bigminion', false)
    scaleObject('bigminion', 1, 1)
	
    addLuaSprite('bgw2',false)
	scaleObject('bgw2', 1.2, 1)
	
    addLuaSprite('bgw3',false)
	scaleObject('bgw3', 1.2, 1)
	
    addLuaSprite('bgw4',false)
	scaleObject('bgw4', 1.2, 1)
    setScrollFactor('bgw4', 1.15, 1)

    scaleObject('bgw6', 0.5, 0.5)
    scaleObject('bg7', 0.75, 0.75)

    setScrollFactor('bgw6', 1.15, 1)
    setScrollFactor('bgw7', 1.15, 1)

    setProperty('bgw6.alpha', 0.000001)
    setProperty('bgw7.alpha', 0.000001)

    addLuaSprite('bgw6', false)
    addLuaSprite('bgw7', false)

    addLuaSprite('pit', false)
	scaleObject('pit', 1.5, 1.5)
    updateHitbox('pit')
	
    addLuaSprite('bgw5',false)
	scaleObject('bgw5', 1.2, 1)
	
    makeAnimatedLuaSprite('runner1','weekbs/runningminion1', 2100, 650)
    addAnimationByPrefix('runner1', 'runningminion1 run')
	scaleObject('runner1', 0.5, 0.5)
	updateHitbox('runner1')
	addLuaSprite('runner1', true)
	
	makeAnimatedLuaSprite('runner2','weekbs/runminion2', -1250, 600)
    addAnimationByPrefix('runner2', 'runminion2 run')
	scaleObject('runner2', 0.5, 0.5)
	updateHitbox('runner2')
	addLuaSprite('runner2', true)
end

function onStepHit()
    if curStep == 2178 then
        addLuaSprite('bgw6', false)
        addAnimationByPrefix('bgw6', false)
    end
    if curStep == 2175 then
        setProperty('defaultCamZoom',0.46)
    end
	if curStep == 2224 then
		runTimer('runningTimer1', 0, 1)

        setProperty('bgw6.alpha', 1)
        setProperty('bgw7.alpha', 1)

        doTweenY('pitTweenY', 'pit', -725, 1, 'sineOut')

        doTweenY('bigTweenY', 'bigminion', -800, 7, 'circOut')
	end
	if curStep == 2230 then
		runTimer('runningTimer2', 0, 1)
	end
end

function onTweenCompleted(tag)
	if tag == 'running1X' then
		setProperty('runner1.x', 2100)
		setProperty('runner1.y', 650)
		
		runTimer('runningTimer1', 7 + math.random(-100, 100)/100, 1)
	elseif tag == 'running2X' then
		setProperty('runner2.x', -1250)
		setProperty('runner2.y', 600)
		
        runTimer('runningTimer2', 7 + math.random(-100, 100)/100, 1)
	end
end

function onTimerCompleted(tag)
	if tag == 'runningTimer1' then
		doTweenX('running1X', 'runner1', -1000, 1.5, 'linear')
		doTweenY('running1Y', 'runner1', 550, 1.5, 'linear')
		
		runTimer('runningTimer1', 7 + math.random(-100, 100)/100, 1)
	elseif tag == 'runningTimer2' then
		doTweenX('running2X', 'runner2', 2200, 1.5, 'linear')
		doTweenY('running2Y', 'runner2', 700, 1.5, 'linear')
		
		runTimer('runningTimer2', 7 + math.random(-100, 100)/100, 1)
	end
end

