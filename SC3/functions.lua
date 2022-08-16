functions = {}

function functions.loadAudio()

end

function functions.loadImages()

end

function functions.loadFonts()

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

return functions
