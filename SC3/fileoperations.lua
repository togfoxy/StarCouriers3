fileops = {}

function fileops.saveTutorial()
    -- ensures tutorial messages are displayed only once and not once per session
    local savedir = love.filesystem.getSourceBaseDirectory( )
    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/Source/savedata/"
    end

    local savefile
    savefile = savedir .. "tutorial.dat"
    local serialisedString = bitser.dumps(tutmsg)
    local success, message = nativefs.write(savefile, serialisedString)

    print(success, message)

end


return fileops
