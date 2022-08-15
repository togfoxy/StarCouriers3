GAME_VERSION = "0.04"

inspect = require 'lib.inspect'
-- https://github.com/kikito/inspect.lua

res = require 'lib.resolution_solution'
-- https://github.com/Vovkiv/resolution_solution

Camera = require 'lib.cam11.cam11'
-- https://notabug.org/pgimeno/cam11

concord = require 'lib.concord'
-- https://github.com/Tjakka5/Concord

bitser = require 'lib.bitser'
-- https://github.com/gvx/bitser

nativefs = require 'lib.nativefs'
-- https://github.com/megagrump/nativefs

lovelyToasts = require 'lib.lovelyToasts'
-- https://github.com/Loucee/Lovely-Toasts

baton = require 'lib.baton'
-- https://github.com/tesselode/baton


cf = require 'lib.commonfunctions'
fun = require 'functions'
-- draw = require 'draw'
constants = require 'constants'
-- comp = require 'components'
-- ecsDraw = require 'ecsDraw'
-- ecsUpdate = require 'ecsUpdate'
-- fileops = require 'fileoperations'
-- keymaps = require 'keymaps'
-- buttons = require 'buttons'

function love.keyreleased( key, scancode )
	if key == "escape" then
		cf.RemoveScreen(SCREEN_STACK)
    end
end

function love.load()

	constants.load()

	res.setGame(SCREEN_WIDTH, SCREEN_HEIGHT)

	if love.filesystem.isFused( ) then
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    else
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    end

	love.window.setTitle("Star Couriers 3 " .. GAME_VERSION)
	love.keyboard.setKeyRepeat(true)

	fun.loadAudio()
	fun.loadImages()
	fun.loadFonts()

	-- buttons.loadButtons()			-- the buttons that are displayed on different gui's
	-- keymaps.init()
    -- cmp.init()

	cf.AddScreen(enum.sceneMainMenu, SCREEN_STACK)
end

function love.draw()
    res.start()

    local currentscreen = cf.currentScreenName(SCREEN_STACK)
	if currentscreen == enum.sceneMainMenu then

    elseif currentscreen == enum.sceneAsteroids then

    end
    lovelyToasts.draw()
    res.stop()
end

function love.update(dt)

    local currentscreen = cf.currentScreenName(SCREEN_STACK)
    if currentscreen == enum.sceneMainMenu then

    elseif currentscreen == enum.sceneAsteroids then
        ECSWORLD:emit("update", dt)
        PHYSICSWORLD:update(dt) --this puts the world into motion











		-- input:update()     -- baton key maps
    end

    lovelyToasts.update(dt)
    res.update()
end
