GAME_VERSION = "0.01"

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
draw = require 'draw'
constants = require 'constants'
comp = require 'components'
ecsDraw = require 'ecsDraw'
ecsUpdate = require 'ecsUpdate'
-- fileops = require 'fileoperations'
-- keymaps = require 'keymaps'
buttons = require 'buttons'
physics = require 'physics'

function love.keyreleased( key, scancode )
	if key == "escape" then
		cf.RemoveScreen(SCREEN_STACK)
    end
end

function love.mousereleased( x, y, button, istouch, presses )

	if button == 1 then
		local currentScreen = cf.currentScreenName(SCREEN_STACK)
		if currentScreen == enum.sceneMainMenu then
			local rx, ry = res.toGame(x,y)		-- does this need to be applied consistently across all mouse clicks?
			for k, button in pairs(GUI_BUTTONS) do
				if button.scene == enum.sceneMainMenu and button.visible then
					-- get the id of the button that was clicked
					local mybuttonID = buttons.getButtonClicked(rx, ry, currentScreen, GUI_BUTTONS)		-- bounding box stuff
					if mybuttonID == enum.buttonNewGame then
						fun.InitialiseGame()
						cf.AddScreen(enum.sceneAsteroids, SCREEN_STACK)
						break
					-- elseif mybuttonID == enum.buttonSaveGame then
					-- 	fileops.saveGame()
					-- 	break
					-- elseif mybuttonID == enum.buttonLoadGame then
					-- 	fileops.loadGame()
					-- 	cf.AddScreen(enum.sceneAsteroid, SCREEN_STACK)
					-- 	break
					-- elseif mybuttonID == enum.buttonCredits then
					-- 	cf.AddScreen(enum.sceneCredits, SCREEN_STACK)
					end
				end
			end
		end
	end
end

function love.wheelmoved(x, y)
	if y > 0 then
		-- wheel moved up. Zoom in
		ZOOMFACTOR = ZOOMFACTOR + 0.1
		if ZOOMFACTOR == 0.6 then ZOOMFACTOR = 0.7 end
	end
	if y < 0 then
		ZOOMFACTOR = ZOOMFACTOR - 0.1
		if ZOOMFACTOR == 0.6 then ZOOMFACTOR = 0.5 end
	end
	if ZOOMFACTOR < 0.1 then ZOOMFACTOR = 0.1 end
	--if ZOOMFACTOR > 4 then ZOOMFACTOR = 4 end
	print("Zoom factor is now ".. ZOOMFACTOR)

	-- delete the bubbles to stop them being drawn funny on zoom change
	-- BUBBLE = {}
end

function love.mousemoved( x, y, dx, dy, istouch )
	if love.mouse.isDown(3) then
		TRANSLATEX = TRANSLATEX - (dx * 3)
		TRANSLATEY = TRANSLATEY - (dy * 3)
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

	buttons.load()			-- the buttons that are displayed on different gui's
	-- keymaps.init()
    comp.init()

	cf.AddScreen(enum.sceneMainMenu, SCREEN_STACK)
end

function love.draw()
    res.start()

    local currentscreen = cf.currentScreenName(SCREEN_STACK)
	if currentscreen == enum.sceneMainMenu then
		draw.mainMenu()
    elseif currentscreen == enum.sceneAsteroids then
		draw.asteroids()		-- this includes hud and starbase etc
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

		cam:setPos(TRANSLATEX, TRANSLATEY)
		cam:setZoom(ZOOMFACTOR)
    end

    lovelyToasts.update(dt)
    res.update()
end
