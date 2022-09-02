functions = {}

function functions.establishPlayerECS()
    -- add player
    local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")

    :give("chassis")
    :give("engine")
    :give("sideThrusters")
    :give("fullReverse")

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
        if component.label == "Main engine" then
            -- add the engine cards to the deck
            thisdeck:give("fullThrust")
            thisdeck:give("halfThrust")
            thisdeck:give("quarterThrust")
            thisdeck:give("fullReverse")

        end
        if component.label == "Side thrusters" then
            thisdeck:give("fullPortTurn")
            thisdeck:give("halfPortTurn")
            thisdeck:give("quarterPortTurn")
            thisdeck:give("fullStarboardTurn")
            thisdeck:give("halfStarboardTurn")
            thisdeck:give("quarterStarboardTurn")
        end
    end
    table.insert(ECS_DECK, thisdeck)
    print("Deck prepared.")
end

function functions.loadAudio()

end

function functions.loadImages()

    IMAGES[enum.imagesStarbase] = love.graphics.newImage("assets/images/starbase.png")

    -- quads
    IMAGES[enum.quadsArrows] = love.graphics.newImage("assets/images/arrows2.png")
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
    NUMBER_OF_ASTEROIDS = GAME_STAGE        -- not even sure why there is a global here
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


return functions
