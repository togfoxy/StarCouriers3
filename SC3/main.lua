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
fileops = require 'fileoperations'
keymaps = require 'keymaps'
buttons = require 'buttons'
physics = require 'physics'
tut = require 'tutorial'

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	-- a is the first fixture
	-- b is the second fixture

	local udtable1 = a:getUserData()
	local udtable2 = b:getUserData()
	physics.processCollision(udtable1, udtable2, normalimpulse)
end

function love.keyreleased( key, scancode )
	local currentscreen = cf.currentScreenName(SCREEN_STACK)
	if key == "escape" then
		if currentscreen == enum.sceneShop then
			-- prep for next round
			fun.resetStage()
		end
		cf.RemoveScreen(SCREEN_STACK)
    end
	if input:down("centreview") then
		local x1, y1 = physics.getPhysEntityXY(PLAYER.UID)
		TRANSLATEX = (x1 * BOX2D_SCALE)
		TRANSLATEY = (y1 * BOX2D_SCALE)
		ZOOMFACTOR = 0.4
	end
end

function love.keypressed( key, scancode, isrepeat )
	local translatefactor = 5 * (ZOOMFACTOR * 2)		-- screen moves faster when zoomed in

	local shiftpressed = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")	-- either shift key will work
	if shiftpressed then translatefactor = translatefactor * 2 end

	local leftpressed = love.keyboard.isDown("left")
	local rightpressed = love.keyboard.isDown("right")
	local uppressed = love.keyboard.isDown("up")
	local downpressed = love.keyboard.isDown("down")

	-- adjust translatex/y based on keypress combinations
	if leftpressed then TRANSLATEX = TRANSLATEX - translatefactor end
	if rightpressed then TRANSLATEX = TRANSLATEX + translatefactor end
	if uppressed then TRANSLATEY = TRANSLATEY - translatefactor end
	if downpressed then TRANSLATEY = TRANSLATEY + translatefactor end
end

function love.mousereleased( x, y, button, istouch, presses )
	lovelyToasts.mousereleased(x, y, button)

	local mybuttonID
	local rx, ry = res.toGame(x,y)		-- does this need to be applied consistently across all mouse clicks?
	local currentScreen = cf.currentScreenName(SCREEN_STACK)
	for k, button in pairs(GUI_BUTTONS) do
		if button.scene == currentScreen and button.visible then
			-- get the id of the button that was clicked
			mybuttonID = buttons.getButtonClicked(rx, ry, currentScreen, GUI_BUTTONS)		-- bounding box stuff
			break
		end
	end

	if button == 1 then
		if currentScreen == enum.sceneMainMenu then
			if mybuttonID == enum.buttonNewGame then
				fun.InitialiseGame()
				cf.AddScreen(enum.sceneAsteroids, SCREEN_STACK)
			end
		elseif currentScreen == enum.sceneAsteroids then
			if GAME_MODE == enum.gamemodePlanning then
				-- turn cards green if clicked
				for k,v in pairs(ECS_DECK) do
					local allComponents = v:getComponents()
					for _, component in pairs(allComponents) do
						if component.label ~= nil then
							local cardx = component.x + (CARD_WIDTH / 2)
							local cardy = component.y + (CARD_HEIGHT / 2)
							local mousedist = cf.GetDistance(rx,ry, cardx, cardy)
							if mousedist <= (CARD_WIDTH / 2) then
								component.selected = not component.selected
								-- if target direction has changed then reset PID
								if component.strength ~= nil then
									integral = 0		--! see if this can be removed
									previous_error = 0
								end
							end
						end
					end
				end

				-- end turn button is clicked
				if mybuttonID == enum.buttonEndTurn then
					-- check too many cards aren't clicked
					local entity = fun.getEntity(PLAYER.UID)
					local crewsize = entity.crewQuarters.crewNumber
					if fun.countCardsSelected() <= crewsize + 1 then
						GAME_MODE = enum.gamemodeAction
						buttons.makeButtonInvisible(enum.buttonEndTurn, GUI_BUTTONS)
						GAME_TIMER = GAME_TIMER_DEFAULT

						-- need to work out some rotation details
						local targetheading = fun.getDesiredHeading()                    -- returns desired compass heading
						if targetheading ~= nil then
							-- STOP_HEADING is in radians with two decimal places
							PLAYER.STOP_HEADING = cf.round(cf.convCompassToRad(targetheading),2)
						else
							PLAYER.STOP_HEADING = nil
						end
					else
						--! display a msg that says too many cards selected
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
	lovelyToasts.canvasSize = { SCREEN_WIDTH, SCREEN_HEIGHT }
	lovelyToasts.options.queueEnabled = true
	lovelyToasts.options.tapToDismiss = true
	lovelyToasts.style.backgroundColor = {151,151,151}

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
	keymaps.init()
    comp.init()
	tutorial.init()			-- toast pop ups
	tutorial.load()			-- load tutorial history

	cf.AddScreen(enum.sceneMainMenu, SCREEN_STACK)
end

function love.draw()
    res.start()

    local currentscreen = cf.currentScreenName(SCREEN_STACK)
	if currentscreen == enum.sceneMainMenu then
		draw.mainMenu()
    elseif currentscreen == enum.sceneAsteroids then

		cam:attach()
		draw.asteroids()		-- this includes hud and starbase etc

		cam:detach()

		if GAME_MODE == enum.gamemodePlanning then
			draw.drawCards()		-- includes the end button
			draw.HUD()
		end

		-- debug
		-- draw ship mass and size
		local entity = fun.getEntity(PLAYER.UID)
		local physicsEntity = physics.getPhysEntity(PLAYER.UID)
		local shipmass = cf.round(physicsEntity.body:getMass())
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("Mass: " .. shipmass, 30, SCREEN_HEIGHT - 100)
		love.graphics.print("Size: " .. fun.getEntitySize(entity), 30, SCREEN_HEIGHT - 80)
    end
    lovelyToasts.draw()
    res.stop()
end

function love.update(dt)

    local currentscreen = cf.currentScreenName(SCREEN_STACK)
    if currentscreen == enum.sceneMainMenu then
		--
    elseif currentscreen == enum.sceneAsteroids then
		if GAME_MODE == enum.gamemodePlanning and #ECS_DECK == 0 then
			fun.loadDeck()
		end

		if GAME_MODE == enum.gamemodePlanning then
			--
			tut.displayMessage(2)
			tut.displayMessage(1)
			tut.displayMessage(3)
			tut.displayMessage(4)
			tut.displayMessage(5)

		elseif GAME_MODE == enum.gamemodeAction then
			GAME_TIMER = GAME_TIMER - dt
			ECSWORLD:emit("update", dt)
			PHYSICSWORLD:update(dt) --this puts the world into motion

			-- decrease the trail
			for i = #TRAIL, 1, -1 do
				TRAIL[i].timer = TRAIL[i].timer - dt
				if TRAIL[i].timer <= 0 then
					table.remove(TRAIL, i)
				end
			end

			-- capture the 'trail' for effect
			if love.math.random(1,2) == 1 then		-- only capture every second dot for effect
				local physicsEntity = physics.getPhysEntity(PLAYER.UID)
				local x, y = physicsEntity.body:getPosition()
				local newtrail = {}
				newtrail.x = cf.round(x)
				newtrail.y = cf.round(y)
				newtrail.timer = 15		-- seconds
				table.insert(TRAIL, newtrail)
			end

			if GAME_TIMER <= 0 then
				GAME_MODE = enum.gamemodePlanning
				buttons.makeButtonVisible(enum.buttonEndTurn, GUI_BUTTONS)
			end

		else
			error()
		end

		input:update()     -- baton key maps

		cam:setPos(TRANSLATEX, TRANSLATEY)
		cam:setZoom(ZOOMFACTOR)
    end

    lovelyToasts.update(dt)
    res.update()
end
