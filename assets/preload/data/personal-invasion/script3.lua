function onCreate()
    function opponentNoteHit(id, direction, noteType)
        setProperty("health", getProperty("health") - 0.015)
        if getProperty("health") < 0.001 then
            setProperty("health", 0.005)
        end
          
            cameraShake("camGame", 0.005, 0.2)
            characterPlayAnim("gf", "scared", true)
        end
    end
