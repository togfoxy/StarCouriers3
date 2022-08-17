functions = {}

function functions.establishPlayerECS()
    -- add player
    local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")

    :give("chassis")
    -- :give("engine")
    -- :give("fuelTank")
    -- :give("battery")
    -- :give("oxyGenerator")
    -- :give("cargoHold")

    -- :give("leftThruster")
    -- :give("rightThruster")
    -- :give("reverseThruster")
    -- :give("oxyTank")
    -- :give("solarPanel")
    -- :give("spaceSuit")
    -- :give("SOSBeacon")
    -- :give("Stabiliser")
    -- :give("ejectionPod")

    table.insert(ECS_ENTITIES, entity)
    PLAYER.UID = entity.uid.value 		-- store this for easy recall

    -- debug
    -- PLAYER.WEALTH = 10000
    -- entity.chassis.currentHP = 0
    -- entity.battery.capacity = 10

end

function functions.loadAudio()

end

function functions.loadImages()

    IMAGES[enum.imagesStarbase] = love.graphics.newImage("assets/images/starbase.png")



end

function functions.loadFonts()
    FONT[enum.fontDefault] = love.graphics.newFont("assets/fonts/Vera.ttf", 12)
    FONT[enum.fontHeavyMetalLarge] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf")

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
	PHYSICS_ENTITIES = {}
	SHOPWORLD = {}
	ECSWORLD = {}

	SHOPWORLD = concord.world()
	ECSWORLD = concord.world()

    ecsDraw.init()
    ecsUpdate.init()

	physics.establishPhysicsWorld()		-- creates borders, starbase and player vessel and player physics
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



return functions
