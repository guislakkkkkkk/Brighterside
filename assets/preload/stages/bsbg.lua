
function onCreate()
	-- background shit
	makeLuaSprite('back', 'weekbs/parasite_back', 1700, 490);
	makeLuaSprite('lgiht', 'weekbs/parasite_light_thing', 2750, -290);
	makeLuaSprite('floor', 'weekbs/parasite_floor', 1650, 2790);
	
	-- sprites that only load if Low Quality is turned off
	if not lowQuality then

	end

	addLuaSprite('back', false);
	scaleObject('back', 6, 6)
	addLuaSprite('lgiht', false);
	scaleObject('lgiht', 3.9, 3.8)
	addLuaSprite('floor', false);
	scaleObject('floor', 6, 6)


	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end