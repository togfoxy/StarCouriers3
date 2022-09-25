functions = {}

function functions.establishPlayerECS()
    -- add player
    local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")

    :give("chassis")
    :give("engine")
    :give("sideThrusters")
    :give("battery")
    :give("oxyTank")
    :give("oxyGenerator")
    :give("crewQuarters")

    table.insert(ECS_ENTITIES, entity)
    PLAYER.UID = entity.uid.value 		-- store this for easy recall

    -- debug
    -- PLAYER.WEALTH = 10000
    -- entity.chassis.currentHP = 0
    -- entity.battery.capacity = 10

end

function functions.loadDeck()
    -- load up the deck of cards with all permissible actions
    -- add the "dummy" card at the end to flag deck construction is complete
    -- assumes the deck is already empty
    -- the deck is a single entity with a lot of components
    assert(ECS_DECK ~= {})

    -- add player
    local thisdeck = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")
    :give("dummy")      -- this is to signal deck construction is complete

    -- scan the player vessel and add cards for each component
    local entity = fun.getEntity(PLAYER.UID)
    local allComponents = entity:getComponents()
    for _, component in pairs(allComponents) do

        if component.label == "Side thrusters" then
            thisdeck:give("turnToNorth")
            thisdeck:give("turnToNorthEast")
            thisdeck:give("turnToEast")
            thisdeck:give("turnToSouthEast")
            thisdeck:give("turnToSouth")
            thisdeck:give("turnToSouthWest")
            thisdeck:give("turnToWest")
            thisdeck:give("turnToNorthWest")
        end
    end
    table.insert(ECS_DECK, thisdeck)

    thisdeck = nil
    thisdeck = concord.entity(ECSWORLD)
    for _, component in pairs(allComponents) do
        if component.label == "Main engine" then
            -- add the engine cards to the deck
            thisdeck:give("fullThrust")
            thisdeck:give("halfThrust")
            thisdeck:give("quarterThrust")
            thisdeck:give("halfReverse")
            thisdeck:give("fullStop")
        end
    end
    table.insert(ECS_DECK, thisdeck)
    print("Deck prepared.")
end

function functions.loadAudio()
    -- AUDIO[enum.audioEngine] = love.audio.newSource("assets/audio/engine.ogg", "static")
	-- AUDIO[enum.audioLowFuel] = love.audio.newSource("assets/audio/lowFuel.ogg", "static")
	-- AUDIO[enum.audioWarning] = love.audio.newSource("assets/audio/507906__m-cel__warning-sound.ogg", "static")
	-- AUDIO[enum.audioMiningLaser] = love.audio.newSource("assets/audio/223472__parabolix__underground-machine-heart-loop.mp3", "static")
	-- AUDIO[enum.audioRockExplosion] = love.audio.newSource("assets/audio/cannon_hit.ogg", "static")
	AUDIO[enum.audioRockScrape1] = love.audio.newSource("assets/audio/metalscrape1.mp3", "static")
	AUDIO[enum.audioRockScrape2] = love.audio.newSource("assets/audio/metalscrape2.mp3", "static")
	-- AUDIO[enum.audioDing] = love.audio.newSource("assets/audio/387232__steaq__badge-coin-win.wav", "static")
	-- AUDIO[enum.audioWrong] = love.audio.newSource("assets/audio/wrong.mp3", "static")

	-- bground music - asteroids
	-- AUDIO[enum.audioBGSkismo] = love.audio.newSource("assets/music/Reflekt.mp3", "stream")

	-- bground music - shop
	-- AUDIO[enum.audioBGEric1] = love.audio.newSource("assets/music/Urban-Jungle-2061.mp3", "stream")
	-- AUDIO[enum.audioBGEric2] = love.audio.newSource("assets/music/World-of-Automatons.mp3", "stream")

	-- AUDIO[enum.audioRockExplosion]:setVolume(0.5)
	AUDIO[enum.audioRockScrape1]:setVolume(0.5)
	AUDIO[enum.audioRockScrape2]:setVolume(0.5)
	-- AUDIO[enum.audioBGSkismo]:setVolume(0.5)
	-- AUDIO[enum.audioBGEric1]:setVolume(0.5)
	-- AUDIO[enum.audioDing]:setVolume(0.5)
end

function functions.loadImages()

    IMAGES[enum.imagesStarbase] = love.graphics.newImage("assets/images/starbase.png")

    -- quads
    IMAGES[enum.quadsArrows] = love.graphics.newImage("assets/images/arrows3.png")
    QUAD_ARROWS = cf.fromImageToQuads(IMAGES[enum.quadsArrows], 72, 104)

end

function functions.loadFonts()
    FONT[enum.fontDefault] = love.graphics.newFont("assets/fonts/Vera.ttf", 12)
    FONT[enum.fontHeavyMetalLarge] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf")
    FONT[enum.fontTech18] = love.graphics.newFont("assets/fonts/CorporateGothicNbpRegular-YJJ2.ttf", 24)
end

function functions.killECSEntity(entity)
	-- does NOT kill the physics entity

	-- remove the entity from the arrary
    for i = 1, #ECS_ENTITIES do
        if ECS_ENTITIES[i] == entity then
            table.remove(ECS_ENTITIES, i)
            break
        end
    end
	-- destroy the entity
    entity:destroy()
end

function functions.InitialiseGame()
	-- do all the stuff that starts the game

	for k, entity in pairs(ECS_ENTITIES) do
		fun.killECSEntity(entity)
	end

	for k, physEntity in pairs(PHYSICS_ENTITIES) do
		physics.killPhysicsEntity(physEntity)
	end

	ECS_ENTITIES = {}
    ECS_DECK = {}       -- deck of cards
	PHYSICS_ENTITIES = {}
	SHOPWORLD = {}
	ECSWORLD = {}

	SHOPWORLD = concord.world()
	ECSWORLD = concord.world()

    ecsDraw.init()
    ecsUpdate.init()

	physics.establishPhysicsWorld()		-- creates borders, starbase and player vessel and player physics
    NUMBER_OF_ASTEROIDS = STARTING_ASTEROIDS + GAME_STAGE
	for i = 1, NUMBER_OF_ASTEROIDS do
		physics.createAsteroid()
	end
	local x1, y1 = physics.getPhysEntityXY(PLAYER.UID)     -- assumes the physical world is established
	cam = Camera.new(x1, y1, 1)		-- this is a global cam

	RECEIPT = {}
	local item = {}
	item.description = "Opening balance"
	item.amount = 0
	table.insert(RECEIPT, item)

    GAME_STAGE = 1

	TRANSLATEX = (x1 * BOX2D_SCALE)
	TRANSLATEY = (y1 * BOX2D_SCALE)
    ZOOMFACTOR = 0.4

end

function functions.getEntity(uid)
    assert(uid ~= nil)
    for k,v in pairs(ECS_ENTITIES) do
        if v.uid.value == uid then
            return v
        end
    end
    return nil
end

function functions.getEntitySize(entity)
    -- receives an ECS entity and calculates the size of all components
    local totalsize = 0
    local allComponents = entity:getComponents()
	for ComponentClass, Component in pairs(allComponents) do
	   if Component.size ~= nil then
           totalsize = totalsize + Component.size
	   end
   end
   return totalsize
end

function functions.getRandomComponent(entity)
	-- get a random component from entity
	-- probability of getting a 'hit' depends on the size of each component

	local entitysize = cf.round(fun.getEntitySize(entity))
	local rndnum = love.math.random(1, entitysize)

	local allComponents = entity:getComponents()
	for ComponentClass, Component in pairs(allComponents) do
		if Component.size ~= nil then
			if Component.size > 0 then
				if Component.size >= rndnum	then
					return Component
				else
					rndnum = rndnum - Component.size
				end
			end
		end
   end
   error("Program flow should not have reached here")
end

function functions.getDesiredHeading()
    -- returns the compass heading of the first card it finds
    -- multiple cards are ignored
    -- returns nil if no cards are selected

    local result = nil
    local allComponents = ECS_DECK[1]:getComponents()
    for _, card in pairs(allComponents) do
        if card.selected then
            if card.targetheading ~= nil then
                return card.targetheading
            end
        end
    end
end

function functions.resetStage()
    local physEntity = physics.getPhysEntity(PLAYER.UID)
    physEntity.body:setPosition(PLAYER_START_X, PLAYER_START_Y)

    -- ensure there is no rotation
    physEntity.body:setAngularVelocity(0)
    physEntity.body:setAngle( 0 )		-- north or 'up'

    local x1, y1 = physEntity.body:getPosition()

    TRANSLATEX = (x1 * BOX2D_SCALE)
    TRANSLATEY = (y1 * BOX2D_SCALE)
    ZOOMFACTOR = 0.4

    GAME_STAGE = GAME_STAGE + 1

    --! move this asteroid destroy/create into a new function
    -- need to delete all physics objects where temptable.objectType = "Asteroid"
    for i = #PHYSICS_ENTITIES, 1, -1 do
        local udtable = PHYSICS_ENTITIES[i].fixture:getUserData()
        if udtable.objectType == "Asteroid" then
            PHYSICS_ENTITIES[i].body:destroy()
            table.remove(PHYSICS_ENTITIES, i)
        end
    end
    -- need to create asteroids
    NUMBER_OF_ASTEROIDS = STARTING_ASTEROIDS + GAME_STAGE        -- not even sure why there is a global here
    for i = 1, NUMBER_OF_ASTEROIDS do
        physics.createAsteroid()
    end

    -- clear all the cards to 'unselected'
    for i = 1, #ECS_DECK do
        local allComponents = ECS_DECK[i]:getComponents()
        for _, component in pairs(allComponents) do
            component.selected = false
        end
    end

    -- refill all components with capacity
    local entity = fun.getEntity(PLAYER.UID)
    local allComponents = entity:getComponents()
    for _, component in pairs(allComponents) do
        if component.capacity ~= nil then
            component.capacity = component.maxCapacity
        end
    end

    -- clear the trail
    TRAIL = {}
end

function functions.countCardsSelected()
    -- cycle through all the decks and return the number of cars selected
    local result = 0
    for i = 1, #ECS_DECK do
        local allComponents = ECS_DECK[i]:getComponents()
        for _, component in pairs(allComponents) do
            if component.selected then
                result = result + 1
            end
        end
    end
    return result
end

function functions.playSounds(dt)

    for i = #SOUND, 1, -1 do
        AUDIO[SOUND[i].enum]:play()
        if SOUND[i].duration == nil or SOUND[i].duration <= 0 then
            table.remove(SOUND, i)
        else
            SOUND[i].duration = SOUND[i].duration - dt
        end
    end
end

return functions
