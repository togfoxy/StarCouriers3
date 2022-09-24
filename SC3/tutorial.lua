tutorial = {}

function tutorial.init()

    tutmsg = {}
    for i = 1, 50 do
        tutmsg[i] = {}
    end

    tutmsg[1].txt = "Click the END TURN button after" .. "\n" .. "you have selected cards to play"
    tutmsg[1].duration = 1000
    tutmsg[1].x = 1750
    tutmsg[1].y = 875
    tutmsg[1].display = true

end
return tutorial
