fileops = {}

function fileops.saveTutorial()
    -- ensures tutorial messages are displayed only once and not once per session
    local savedir = love.filesystem.getSourceBaseDirectory()
    -- print("savedir = " .. savedir)

    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/SC3/savedata/"
    end
    -- print("savedir = " .. savedir)

    local savefile
    savefile = savedir .. "tutorial.dat"
    -- print("savefile = " .. savefile)

    local serialisedString = bitser.dumps(tutmsg)
    local success, message = nativefs.write(savefile, serialisedString)

    print(success, message)
end

return fileops
