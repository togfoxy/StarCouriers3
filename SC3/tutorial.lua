tutorial = {}

function tutorial.init()

    tutmsg = {}             --! should be upper case for globals
    for i = 1, 50 do
        tutmsg[i] = {}
    end

    tutmsg[1].txt = "Click the END TURN button after" .. "\n" .. "you have selected cards to play"
    tutmsg[1].duration = 1000
    tutmsg[1].x = 1750
    tutmsg[1].y = 875
    tutmsg[1].display = true

    tutmsg[2].txt = "Select one or two cards to play"
    tutmsg[2].duration = 1000
    tutmsg[2].x = 450
    tutmsg[2].y = 575
    tutmsg[2].display = true

    tutmsg[3].txt = "Avoid the asteroids and get to the top space station"
    tutmsg[3].duration = 1000
    tutmsg[3].position = "middle"
    -- tutmsg[3].x = 450
    -- tutmsg[3].y = 575
    tutmsg[3].display = true

    tutmsg[4].txt = "Turning and moving might be slow. Plan ahead"
    tutmsg[4].duration = 1000
    tutmsg[3].position = "middle"
    -- tutmsg[4].x = 450
    -- tutmsg[4].y = 575
    tutmsg[4].display = true

    tutmsg[5].txt = "You can upgrade performance in the shop (not working)"
    tutmsg[5].duration = 1000
    tutmsg[5].position = "middle"
    -- tutmsg[5].x = 450
    -- tutmsg[5].y = 575
    tutmsg[5].display = true


end

function tutorial.displayMessage(msgNumber)
    -- input: the tutorial message number to display

    if tutmsg[msgNumber].display then
        lovelyToasts.show(tutmsg[msgNumber].txt, tutmsg[msgNumber].duration, tutmsg[msgNumber].position, tutmsg[msgNumber].x, tutmsg[msgNumber].y)
        tutmsg[msgNumber].display = false
        fileops.saveTutorial()
    end

end

function tutorial.load()
    -- loads the tutorial history from file to prevent old tut msgs appearing every session
    fileops.loadTutorial()
end


return tutorial
