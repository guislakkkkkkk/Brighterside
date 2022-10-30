function onCreate()
    makeAnimatedLuaSprite('PopUp1', 'MinionPU', 0, 0);
    addAnimationByPrefix('PopUp1', '1', 'popup', 12, false);
    addAnimationByPrefix('PopUp1', '2', 'fall', 12, false);
    addAnimationByPrefix('PopUp1', '3', 'throw', 12, false);
    setObjectCamera('PopUp1', 'hud');
    setScrollFactor('PopUp1', 0, 0);
    setProperty('PopUp1.visible', false);
    setProperty('PopUp1.scale.x', 2);
    setProperty('PopUp1.scale.y', 2);
    addLuaSprite('PopUp1', true);

    precacheImage('MinionPU');
end

amountOfInstances = 4;

minionTable = {
    ['x'] = {410, 320.5, 310; n=amountOfInstances},
    ['y'] = {180, 180, 220; n=amountOfInstances}
}

function MinionAppearance(instance)
    if not(instance >= 1 and instance <= amountOfInstances) then
        return;
    end

    if not getProperty('PopUp1.visible') then
        setProperty('PopUp1.visible', true);
    end
    setProperty('PopUp1.x', minionTable['x'][instance]);
    setProperty('PopUp1.y', minionTable['y'][instance]);
    objectPlayAnimation('PopUp1', tostring(instance), true);
end

function onEvent(name, value1, value2)
	if name == 'Minion Popup1' then
        MinionAppearance(tonumber(value1));
    end
end

function onUpdate(elapsed)
    if getProperty('PopUp1.animation.curAnim.finished') then
        setProperty('PopUp1.visible', false);
    end
end