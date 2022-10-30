-- script by raltyro uwu
local noteTypeName = "Lock Note"

local selNoteI = 0
local noteGroup = "unspawnNotes"
function setNoteProperty(p, v)
	setPropertyFromGroup(noteGroup, selNoteI, p, v)
end
function getNoteProperty(p)
	return getPropertyFromGroup(noteGroup, selNoteI, p)
end

local prefix = "lockStrumCover"

function onCreate()
	precacheSound("lock")
	
	for i = 1, 4 do
		local tag = prefix .. tostring(i)
		makeLuaSprite(tag, "paralock")
		setObjectCamera(tag, "hud")
	end
	
	for i = 0, getProperty("unspawnNotes.length") - 1 do
		selNoteI = i
		noteGroup = "unspawnNotes"
		if (getNoteProperty("noteType") == noteTypeName) then
			local sus = getNoteProperty("isSustainNote")
			
			setNoteProperty("ignoreNote", getNoteProperty("mustPress"))
			setNoteProperty("hitsoundDisabled", true)
			setNoteProperty("hitCausesMiss", true)
			setNoteProperty("lowPriority", true)
			
			setNoteProperty("missHealth", sus and .115 or .325)
			
			setNoteProperty("texture", "parasitenotes")
			
			setNoteProperty("noMissAnimation", true)
			setNoteProperty("colorSwap.hue", 0)
			setNoteProperty("colorSwap.saturation", 0)
			setNoteProperty("colorSwap.brightness", 0)
			setNoteProperty("noteSplashDisabled", true)
		end
	end
end

local infect = {}
local locked = {0, 0, 0, 0}
local plocked = {0, 0, 0, 0}
local req = false
local dont = false
local last = 0

function fucker(i)
	if (plocked[i] > 0 and locked[i] <= 0) then
		req = true
		removeLuaSprite(prefix .. tostring(i), false)
		setPropertyFromGroup("playerStrums", i - 1, "color", 0xffffff)
	end
end

function onUpdate(dt)
	if (inGameOver) then return end
	
	locked[1] = locked[1] - dt; locked[2] = locked[2] - dt
	locked[3] = locked[3] - dt; locked[4] = locked[4] - dt
	
	fucker(1); fucker(2); fucker(3); fucker(4)
	
	plocked[1] = locked[1]; plocked[2] = locked[2]
	plocked[3] = locked[3]; plocked[4] = locked[4]
	
	if (req) then
		local dickers = 0
		for i = last, getProperty("notes.length") - 1 do
			dickers = dickers + 1
			
			selNoteI = i
			noteGroup = "notes"
			
			if (getNoteProperty("mustPress") and getNoteProperty("noteType") ~= noteTypeName) then
				local id = getNoteProperty("ID")
				local data = getNoteProperty("noteData") + 1
				
				if (locked[data] > 0 and not infect[id] and not getNoteProperty("wasGoodHit")) then
					setNoteProperty("wasGoodHit", true)
					infect[id] = true
				elseif (locked[data] < 0 and infect[id]) then
					setNoteProperty("wasGoodHit", false)
					infect[id] = false
				end
			end
			
			if (dickers > 32) then
				dont = true
				break
			end
		end
	end
	
	if (not dont) then
		last = 0
		req = false
	end
	
	dont = false
	
	local srm = "playerStrums"
	for i,v in pairs(locked) do
		local a = i - 1
		if (v > 0) then
			local tag = prefix .. tostring(i)
			
			local width, height = getPropertyFromGroup(srm, a, "width"), getPropertyFromGroup(srm, a, "height")
			local lwidth, lheight = math.floor(width * 1.1), math.floor(height * 1.1)
			
			setProperty(tag .. ".x", getPropertyFromGroup(srm, a, "x") + (width / 2)); setProperty(tag .. ".y", getPropertyFromGroup(srm, a, "y") + (height / 2))
			setGraphicSize(tag, lwidth, lheight)
			setProperty(tag .. ".offset.x", lwidth / 2.4); setProperty(tag .. ".offset.y", lheight / 2.4)
		end
	end
end

function onSpawnNote(l, dir, type, sus, id)
	if (locked[dir + 1] > 0) then
		selNoteI = l
		noteGroup = "notes"
		
		if (not getNoteProperty("mustPress") or getNoteProperty("noteType") == noteTypeName) then return end
		
		setNoteProperty("wasGoodHit", true)
		infect[id] = true
	end
end

function noteMiss(l, dir, type)
	if (type ~= noteTypeName) then return end
	
	local str = nil
	local lmao = 0
	for i,v in pairs(locked) do
		if (v > 0) then
			str = not str and tostring(i) or str .. "," .. tostring(i)
			lmao = lmao + 1
		end
	end
	
	characterPlayAnim("bf", "hurt", true)
	if (lmao < #locked) then shockRaltAssTillSheMoans(getRandomInt(1, 4, str), true) end
end

-- dont ask
function shockRaltAssTillSheMoans(dick, erect)
	if (locked[dick] > 0) then return end
	
	req = true
	if (erect) then
		playSound("lock")
		locked[dick] = getRandomFloat(4, 6)
		-- stay the dick in the ass, bite raltyro neck, then cum in thru her smooth ass
	end
	
	local tag = prefix .. tostring(dick)
	setPropertyFromGroup("playerStrums", dick - 1, "color", 0xffbebe)
	addLuaSprite(tag, true)
end