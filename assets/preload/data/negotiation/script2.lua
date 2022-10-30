local showdebug = false

local angleshit = 1.45;
local anglevar = 1.45;

local noteDancingEnabled = true;
local noteDanceDefaultHeight = 5;
local noteDanceLRSwitch = true;
local noteDanceSide = 2; -- 0 left	1 right		2 both
local noteDanceCrochet = 0.5;
local noteDanceStyle = 'A'
local lastForcedNoteDanceBeat = 0

local noteDanceIntense = false;

local knock_notehandle_array = {-1,-0.5,0.5,1}

local phase = 0

--local LUNATIC = (difficulty == 4)

local function knock_screen(manualvar,manualCrochet,handleFromNote)
	--triggerEvent('Add Camera Zoom','0.01','0.01')
	
	if not handleFromNote then
		if angleshit > 0 then
			angleshit = -manualvar or -anglevar
		else
			angleshit = manualvar or anglevar
		end
	else
		angleshit = knock_notehandle_array[handleFromNote+1]
	end
	
	local crochetMult = manualCrochet or 0.006
	
	local ease
	
	if not handleFromNote then
		ease = 'elasticOut'
	else
		ease = 'circOut'
	end
	
	setProperty('camHUD.angle',-angleshit*2.5)
	setProperty('camGame.angle',angleshit*3)
	doTweenAngle('turn', 'camHUD', 0, stepCrochet*crochetMult, 'backOut')
	doTweenAngle('tt', 'camGame', 0, stepCrochet*crochetMult, 'backOut')
end

jitterResetTime = 0
animationCounter = 0
modchartBeatOffset = 4*6
modchartStepOffset = modchartBeatOffset * 4

nPos = {}

function nTween(dir,tweenName,strumData,goal,crochet,ease)
	if dir == 'x' then
		noteTweenX(tweenName,strumData,goal,crochet,ease)
	elseif dir == 'y' then
		noteTweenY(tweenName,strumData,goal,crochet,ease)
	elseif dir == 'a' then
		noteTweenAngle(tweenName,strumData,goal,crochet,ease)
	end
end

forcedMiddlescroll = true

function onCreatePost()
	jitterResetTime = stepCrochet*2
end

function onCountdownTick(count)
	if count == 0 then
		local mscroll = 0
		local offscreen = 0
		if forcedMiddlescroll then
			mscroll = screenWidth/4
			offscreen = -screenWidth*100
		end
		notePos = {
		['p0x'] = {'x', 'playerStrumX0', 4, defaultPlayerStrumX0-mscroll},
		['p1x'] = {'x', 'playerStrumX1', 5, defaultPlayerStrumX1-mscroll},
		['p2x'] = {'x', 'playerStrumX2', 6, defaultPlayerStrumX2-mscroll},
		['p3x'] = {'x', 'playerStrumX3', 7, defaultPlayerStrumX3-mscroll},
		['o0x'] = {'x', 'opponentStrumX0', 0, defaultOpponentStrumX0-offscreen},
		['o1x'] = {'x', 'opponentStrumX1', 1, defaultOpponentStrumX1-offscreen},
		['o2x'] = {'x', 'opponentStrumX2', 2, defaultOpponentStrumX2-offscreen},
		['o3x'] = {'x', 'opponentStrumX3', 3, defaultOpponentStrumX3-offscreen},
		['p0y'] = {'y', 'playerStrumY0', 4, defaultPlayerStrumY0},
		['p1y'] = {'y', 'playerStrumY1', 5, defaultPlayerStrumY1},
		['p2y'] = {'y', 'playerStrumY2', 6, defaultPlayerStrumY2},
		['p3y'] = {'y', 'playerStrumY3', 7, defaultPlayerStrumY3},
		['o0y'] = {'y', 'opponentStrumY0', 0, defaultOpponentStrumY0},
		['o1y'] = {'y', 'opponentStrumY1', 1, defaultOpponentStrumY1},
		['o2y'] = {'y', 'opponentStrumY2', 2, defaultOpponentStrumY2},
		['o3y'] = {'y', 'opponentStrumY3', 3, defaultOpponentStrumY3},
		
		['p0a'] = {'a', 'playerStrumAngle0', 4, 0},
		['p1a'] = {'a', 'playerStrumAngle1', 5, 0},
		['p2a'] = {'a', 'playerStrumAngle2', 6, 0},
		['p3a'] = {'a', 'playerStrumAngle3', 7, 0},
		['o0a'] = {'a', 'opponentStrumAngle0', 0, 0},
		['o1a'] = {'a', 'opponentStrumAngle1', 1, 0},
		['o2a'] = {'a', 'opponentStrumAngle2', 2, 0},
		['o3a'] = {'a', 'opponentStrumAngle3', 3, 0},
		}
		
		noteTweenX('setP0X',4,defaultPlayerStrumX0-mscroll,0.01,'linear')
		noteTweenX('setP1X',5,defaultPlayerStrumX1-mscroll,0.01,'linear')
		noteTweenX('setP2X',6,defaultPlayerStrumX2-mscroll,0.01,'linear')
		noteTweenX('setP3X',7,defaultPlayerStrumX3-mscroll,0.01,'linear')
		noteTweenX('setO0X',0,defaultOpponentStrumX0-offscreen,0.01,'linear')
		noteTweenX('setO1X',1,defaultOpponentStrumX1-offscreen,0.01,'linear')
		noteTweenX('setO2X',2,defaultOpponentStrumX2-offscreen,0.01,'linear')
		noteTweenX('setO3X',3,defaultOpponentStrumX3-offscreen,0.01,'linear')
	end
end

function has(x, v)
    for inx, val in ipairs(x) do
        if val == v then
            return true
        end
    end
    return false
end

function rand_xy()
	if math.random(0,1) == 0 then
		return 'x'
	else
		return 'y'
	end
end

function rand_posneg(x)
	if math.random(0,1) == 0 then
		return x
	else
		return x*-1
	end
end

local function noteDanceFunc(forceDance,customheight,ease,customtime,customdirection)
	if noteDancingEnabled == false and forceDance ~= true then
		return
	elseif forceDance == true then
		lastForcedNoteDanceBeat = curBeat
	end
	
	local calledNoteDanceHeight = customheight or noteDanceDefaultHeight
	
	local calledNoteDanceCrochet = customtime or noteDanceCrochet
	
	local thisEase = ease or 'elasticOut'
	
	noteDanceLRSwitch = not noteDanceLRSwitch
	
	local noteDancingDirection = customdirection or 'y'
	
	if noteDanceIntense then
		noteDanceDefaultHeight = 40;
		knock_screen()
	end
	
	local styleArray = {
	['guide'] = {'0','1','2','3'},
	['reset'] = {{0,0,0,0},{0,0,0,0}},
	['A'] = {{0,1,0,1},{1,0,1,0}},
	['B'] = {{0,1,1,0},{0,1,1,0}},
	['C'] = {{-3,-1.25,1.25,3},{0,0,0,0}}
	}
	
	local function performByArray(sideKey)
		for inx = 1,4,1 do
		
			local nDKstr = sideKey..tostring(inx-1)..noteDancingDirection
			local nDK = notePos[nDKstr]
			
			--if sideKey == 'p' and inx == 1 then debugPrint(nDK) end
			
			local thisStyleArrayIndex = 1
			if noteDanceLRSwitch == true then
				thisStyleArrayIndex = 2
			end
			
			nTween(noteDancingDirection, nDK[2], nDK[3], nDK[4] + (calledNoteDanceHeight * styleArray[noteDanceStyle][thisStyleArrayIndex][inx]), calledNoteDanceCrochet, thisEase)
		end

	end
	
	if noteDanceSide == 0 or noteDanceSide == 2 then
		--debugPrint('do')
		performByArray('p')
		--debugPrint('did')
	end
	
	if noteDanceSide == 1 or noteDanceSide == 2 then
		performByArray('o')
	end
	
end

function jitter(data,ease)
	--debugPrint('JITTERING')
	
	for inx = 1,4,1 do
		math.randomseed(inx*getSongPosition())
		local ndir = rand_xy()
		math.randomseed(inx*curStep/curBeat)
		local nmag = rand_posneg(25)
		math.randomseed(inx*curBeat/curStep)
		local amag = rand_posneg(90) + rand_posneg(90)
		
		local nDictKey = tostring(inx-1)..ndir
		local nDictKeyAngular = tostring(inx-1)..'a'
		
		local p = notePos['p'..nDictKey]
		local o = notePos['o'..nDictKey]
		
		local pA = notePos['p'..nDictKeyAngular]
		local oA = notePos['o'..nDictKeyAngular]
		
		if ndir == 'y' then
			nmag = nmag / 2
		end
		
		nTween(pA[1],pA[2],pA[3],pA[4]+amag,0.1,'quartOut')
		nTween(oA[1],oA[2],oA[3],oA[4]+amag,0.1,'quartOut')
		
		nTween(p[1],p[2],p[3],p[4]+nmag,0.2,'backOut')
		nTween(o[1],o[2],o[3],o[4]+nmag,0.2,'backOut')
	end
	--debugPrint('finished jitter')
end

stepMap = {
['beatDance'] = {0,1,3,4,6,8,10,11,13,14},
['steady'] = {0,2,4,6,8,10,12,14},
['steadySub'] = {0,4,8,12},
['claps'] = {4,12},
}

function onBeatHit()
	
	local curSection = math.floor(curBeat/4)
	local curStepOnSection = curStep - (curSection*16)

	if curBeat >= 16 + modchartBeatOffset then
		triggerEvent('Add Camera Zoom','0.025','0.035')
		triggerEvent('Cam Speed','2.5','')
		if curBeat == 48 + modchartBeatOffset then
			noteDanceEnabled = false
			phase = 1
		elseif curBeat == 80 + modchartBeatOffset then
			phase = 0
		elseif curBeat > 112 + modchartBeatOffset and has(stepMap['claps'],curStepOnSection) then
		end
	end
end

function onStepHit()
	
	local curSection = math.floor(curBeat/4)
	local curStepOnSection = curStep - (curSection*16)
	
	if curStep < modchartStepOffset or curStep >= 575 + modchartStepOffset then return end
	
	if curStep <= 60 + modchartStepOffset or curStep >= 64 + modchartStepOffset then
	
		if curBeat >= 80 + modchartBeatOffset then
			
			if curBeat == 80 + modchartBeatOffset then
				noteDancingEnabled = false
				noteDanceFunc(true, 0, 'backOut', 1, 'x')
			end
			
			if has(stepMap['steady'],curStepOnSection) and curBeat < 112 then
				noteDanceFunc(false,nil,'backOut',0.2)
				if has(stepMap['steadySub'],curStepOnSection) then
					knock_screen(0.4,2)
					triggerEvent('Add Camera Zoom','0.015','0.025')
				end
				
			end
			
		elseif has(stepMap['beatDance'],curStepOnSection) and curBeat < 16 + modchartBeatOffset then
		
			if curBeat < 48 then
				noteDanceFunc(false,nil,'backOut',0.1)
			end
			
		end
		
		if curBeat >= 16 + modchartBeatOffset and has(stepMap['claps'],curStepOnSection) then
			
			if curBeat >= 112 then
				noteDanceStyle = 'C'
				noteDanceFunc(true,40,'sineOut',0.2,'x')
			else
				noteDanceFunc(false,20,'backOut',0.35)
			end
			
			
			if curStep >= 64 + modchartStepOffset then
			
				triggerEvent('Add Camera Zoom','0.025','0.035')
				
			end
			
		end
		
		if has(stepMap['steadySub'],curStepOnSection) and curBeat >= 16 then
		
			if curBeat == 16 then
			
				noteDanceDefaultHeight = 20;
				
			end
			
			knock_screen(0.5,0.01)
		end
		
	elseif curStep > 60 + modchartStepOffset and curStep < 64 + modchartStepOffset then
		noteDanceFunc(true,0,'sineOut',0.35)
	end
end

function onSongStart()
	noteDanceFunc(true)
	--debugPrint(notePos['p0x'][1])
end

function opponentNoteHit(id, data, noteType, sustain)
	if phase == 1 and sustain == false then
		jitter(data)
	end
end

function goodNoteHit(id, data, noteType, sustain)
	if phase == 1 and sustain == false then
		jitter(data)
	end
end


function onUpdatePost(elapsed)
	if curBeat >= 12 + modchartBeatOffset and curBeat < 15 + modchartBeatOffset then
		local curSection = math.floor(curBeat/4)
		local curStepOnSection = curStep - (curSection*16)
		
		local push = curStepOnSection / 1600
		triggerEvent('Add Camera Zoom',tostring(push*1.5),tostring(push*3))
	elseif curBeat >= 80 + modchartBeatOffset and curBeat < 112 + modchartBeatOffset then
		local songpos = getSongPosition()/1000
		local currentBeat = (songpos)*(bpm/60)
		for i_,v in ipairs({'p','o'}) do
			for inx = 1,4,1 do
				local nDKy = notePos[v..tostring(inx-1)..'y']
				local nDKa = notePos[v..tostring(inx-1)..'a']
				
				local mathop1 = math.sin
				local mathop2 = math.cos
				
				if v ~= 'p' then
					mathop1 = math.cos
					mathop2 = math.sin
				end
				
				local waveY = math.abs(mathop1((currentBeat+(inx-1)*0.25)*math.pi))
				local waveA = mathop2((currentBeat+(inx-1)*0.25)*math.pi)
				
				if downscroll then waveY = -waveY end
				
				if v ~= 'p' then
					waveA = -waveA
				end

				nTween('y',nDKy[2],nDKy[3],nDKy[4]+(waveY*50),0.01)
				nTween('a',nDKa[2],nDKa[3],nDKa[4]+(waveA*20),0.01)
			end
		end
	elseif curBeat >= 80 + modchartBeatOffset and curBeat < 143 + modchartBeatOffset then
		local songpos = getSongPosition()/1000
		local currentBeat = (songpos)*(bpm/60)
		local currentSection = currentBeat/4
		
		for i_,v in ipairs({'p','o'}) do
			for inx = 1,4,1 do
				local nDKa = notePos[v..tostring(inx-1)..'a']
				local nDKx = notePos[v..tostring(inx-1)..'x']
				local nDKy = notePos[v..tostring(inx-1)..'y']
				
				local mathop1 = math.sin
				local mathop2 = math.cos
				
				if v ~= 'p' then
					mathop1 = math.cos
					mathop2 = math.sin
				end
				
				local waveY = math.abs(mathop1((currentBeat+(inx-1)*0.25)*math.pi))
				local waveX = mathop2((currentSection+(inx-1)*0.25)*math.pi)
				
				if downscroll then waveY = -waveY end
				
				nTween('a',nDKa[2],nDKa[3],(currentBeat*50),0.01)
				nTween('y',nDKy[2],nDKy[3],nDKy[4]+(waveY*50),0.01)
				--nTween('x',nDKx[2],nDKx[3],nDKx[4]-(waveX*(screenWidth/16)),0.01)
			end
		end
	elseif curBeat > 143 + modchartBeatOffset then
		for i_,v in ipairs({'p','o'}) do
			for inx = 1,4,1 do
				local nDKa = notePos[v..tostring(inx-1)..'a']
				local nDKx = notePos[v..tostring(inx-1)..'x']
				local nDKy = notePos[v..tostring(inx-1)..'y']
				
				nTween('a',nDKa[2],nDKa[3],nDKa[4],0.5+(inx/2),'backOut')
				nTween('y',nDKy[2],nDKy[3],nDKy[4],0.5+(inx/4),'backOut')
				nTween('x',nDKx[2],nDKx[3],nDKx[4],0.5+(inx/6),'backOut')
			end
		end
	end
end

fading_in = false