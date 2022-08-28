physics = {}

local function establishPlayerVessel()
	-- add player
	local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")

	:give("chassis")
	:give("engine")
	:give("fuelTank")
	:give("miningLaser")
	:give("battery")
	:give("oxyGenerator")
	:give("cargoHold")

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


	local shipsize = fun.getEntitySize(entity)
	-- DEBUG_VESSEL_SIZE = 10
	-- shipsize = DEBUG_VESSEL_SIZE

	local physicsEntity = {}
    physicsEntity.body = love.physics.newBody(PHYSICSWORLD, PHYSICS_WIDTH / 2, (PHYSICS_HEIGHT) - 75, "dynamic")
	physicsEntity.body:setLinearDamping(0)
	-- physicsEntity.body:setMass(500)		-- kg		-- made redundant by newFixture
	physicsEntity.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	-- physicsEntity.shape = love.physics.newPolygonShape(PLAYER.POINTS)
	physicsEntity.fixture = love.physics.newFixture(physicsEntity.body, physicsEntity.shape, PHYSICS_DENSITY)		-- the 1 is the density
	physicsEntity.fixture:setRestitution(0.1)		-- between 0 and 1
	physicsEntity.fixture:setSensor(false)

	local temptable = {}
	temptable.uid = entity.uid.value
	temptable.objectType = "Player"						-- other type is "Pod"
	physicsEntity.fixture:setUserData(temptable)		-- links the physics object to the ECS entity


    table.insert(PHYSICS_ENTITIES, physicsEntity)

	print("Ship mass is " .. physicsEntity.body:getMass())
	print("Ship size is " .. shipsize)
end

function physics.killPhysicsEntity(physEntity)
	-- used on rocks and other things
	-- receives a physics entity

    -- unit test
    local physicsOrigsize = #PHYSICS_ENTITIES
    --
    -- destroy the body then remove empty body from the array
    for i = 1, #PHYSICS_ENTITIES do		-- needs to be a for i loop so we can do a table remove
        if PHYSICS_ENTITIES[i] == physEntity then
            PHYSICS_ENTITIES[i].body:destroy()
            table.remove(PHYSICS_ENTITIES, i)
            break
        end
    end

    -- unit test
    assert(#PHYSICS_ENTITIES < physicsOrigsize)
end

local function establishWorldBorders()
	-- bottom border
	local PHYSICSBORDER1 = {}
    PHYSICSBORDER1.body = love.physics.newBody(PHYSICSWORLD, (FIELD_WIDTH / 2), FIELD_HEIGHT, "static") -- x, y.  The shape comes next
    PHYSICSBORDER1.shape = love.physics.newRectangleShape(FIELD_WIDTH, 5) --make a rectangle with a width and a height
    PHYSICSBORDER1.fixture = love.physics.newFixture(PHYSICSBORDER1.body, PHYSICSBORDER1.shape) --attach shape to body
	PHYSICSBORDER1.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER1.fixture:setUserData(temptable)
	-- top border
	local PHYSICSBORDER2 = {}
    PHYSICSBORDER2.body = love.physics.newBody(PHYSICSWORLD, 0 + (FIELD_WIDTH / 2), 0, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER2.shape = love.physics.newRectangleShape(FIELD_WIDTH, 5) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER2.fixture = love.physics.newFixture(PHYSICSBORDER2.body, PHYSICSBORDER2.shape) --attach shape to body
	PHYSICSBORDER2.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER2.fixture:setUserData(temptable)
	-- left border
	local PHYSICSBORDER3 = {}
    PHYSICSBORDER3.body = love.physics.newBody(PHYSICSWORLD, 0, 0 + (FIELD_HEIGHT / 2), "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER3.shape = love.physics.newRectangleShape(5, FIELD_HEIGHT) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER3.fixture = love.physics.newFixture(PHYSICSBORDER3.body, PHYSICSBORDER3.shape) --attach shape to body
	PHYSICSBORDER3.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER3.fixture:setUserData(temptable)
	-- right border
	local PHYSICSBORDER4 = {}
    PHYSICSBORDER4.body = love.physics.newBody(PHYSICSWORLD, FIELD_WIDTH, 0 + (FIELD_HEIGHT / 2), "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER4.shape = love.physics.newRectangleShape(5, FIELD_HEIGHT) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER4.fixture = love.physics.newFixture(PHYSICSBORDER4.body, PHYSICSBORDER4.shape) --attach shape to body
	PHYSICSBORDER4.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER4.fixture:setUserData(temptable)

	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER1)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER2)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER3)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER4)
end

local function establishStarbase()
    -- add starbase
    local starbase = {}
    starbase.body = love.physics.newBody(PHYSICSWORLD, FIELD_WIDTH / 2, 75, "static")
    -- physicsEntity.body:setLinearDamping(0)
    starbase.body:setMass(5000)

    starbase.shape = love.physics.newPolygonShape(-250,-19,250,-19,250,20,-250,20)

    starbase.fixture = love.physics.newFixture(starbase.body, starbase.shape) --attach shape to body
    starbase.fixture:setRestitution(0)		-- between 0 and 1
    starbase.fixture:setSensor(false)
    local temptable = {}
    temptable.uid = cf.Getuuid()
    temptable.objectType = "Starbase"
    starbase.fixture:setUserData(temptable)

    table.insert(PHYSICS_ENTITIES, starbase)
end

local function establishPlayerPhysics()
    local entity = fun.getEntity(PLAYER.UID)
    local shipsize = fun.getEntitySize(entity)
	-- DEBUG_VESSEL_SIZE = 10
	-- shipsize = DEBUG_VESSEL_SIZE

	local physicsEntity = {}
    physicsEntity.body = love.physics.newBody(PHYSICSWORLD, PLAYER_START_X, PLAYER_START_Y, "dynamic")
	physicsEntity.body:setLinearDamping(0)
	physicsEntity.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	physicsEntity.fixture = love.physics.newFixture(physicsEntity.body, physicsEntity.shape, PHYSICS_DENSITY)		-- the 1 is the density
	physicsEntity.fixture:setRestitution(0.1)		-- between 0 and 1
	physicsEntity.fixture:setSensor(false)

	local temptable = {}
	temptable.uid = PLAYER.UID
	temptable.objectType = "Player"						-- other type is "Pod"
	physicsEntity.fixture:setUserData(temptable)		-- links the physics object to the ECS entity
    table.insert(PHYSICS_ENTITIES, physicsEntity)

	print("Ship mass is " .. physicsEntity.body:getMass())
	print("Ship size is " .. shipsize)

end

function physics.establishPhysicsWorld()
	love.physics.setMeter(1)
	PHYSICSWORLD = love.physics.newWorld(0,0,false)
	PHYSICSWORLD:setCallbacks(beginContact,_,_,postSolve)

	establishWorldBorders()
    establishStarbase()
    fun.establishPlayerECS()
    establishPlayerPhysics()
end

function physics.createAsteroid()
	-- creates one asteroid in a random location

	-- determine physics x/y of origin/object
	local x0 = love.math.random(100, FIELD_WIDTH - 100)
	local y0 = love.math.random(100, FIELD_HEIGHT - FIELD_SAFEZONE - 100)      --! not sure why the -100

	-- determine number of segments
	local numsegments = love.math.random(4,8)
	local x = {}
	local y = {}

	-- determine x/y for each point
	local asteroidpoints = {}

	-- first point is random heading and distance from origin
	local bearing = love.math.random(0,359)
	local distance = love.math.random(5,20)		-- physics metres
	x[1], y[1] = cf.AddVectorToPoint(x0, y0, 0, distance)

	-- need to get x/y relative to body origin/position
	table.insert(asteroidpoints, x[1] - x0)
	table.insert(asteroidpoints, y[1] - y0)

	-- keep adding vectors in a clockwise direction
	local bestangle = 360 / numsegments		-- use this number to form a perfect polygon
	local segmentheading = 0				-- first point is pointing north.
	for i = 2, (numsegments) do
		local angleAdjustment = love.math.random(0, 10)		-- get a random angleAdjustment
		local angle = cf.adjustHeading(bestangle, angleAdjustment)

		segmentheading = cf.adjustHeading(segmentheading, angle)
		x[i],y[i] = cf.AddVectorToPoint(x[i-1], y[i-1], segmentheading, distance)

		table.insert(asteroidpoints, x[i] - x0)
		table.insert(asteroidpoints, y[i] - y0)
	end

	-- create physical object
	local asteroid = {}
    asteroid.body = love.physics.newBody(PHYSICSWORLD, x0, y0, "dynamic")
	asteroid.body:setLinearDamping(0)
	asteroid.shape = love.physics.newPolygonShape(asteroidpoints)
	asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, PHYSICS_DENSITY)		-- the 1 is the density
	asteroid.fixture:setRestitution(0.1)		-- between 0 and 1
	asteroid.fixture:setSensor(false)
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Asteroid"
	asteroid.originalMass = asteroid.body:getMass()
	asteroid.currentMass = asteroid.originalMass

	local rndnum = love.math.random(1, 100)
	if rndnum == 1 then
		temptable.oreType = enum.oreTypeGold	-- gold
	elseif rndnum == 2 or rndnum == 3 then
		temptable.oreType = enum.oreTypeSilver	-- silver
	elseif rndnum >= 4 and rndnum <= 6 then
		temptable.oreType = enum.oreTypeBronze	-- bronze
	else
		-- normal ore
		temptable.oreType = 0
	end
	temptable.isVisible = true
	asteroid.fixture:setUserData(temptable)

    table.insert(PHYSICS_ENTITIES, asteroid)
end

function physics.getPhysEntity(uid)
    -- gets a phyisics item from an ECS UID
    -- can then access body, fixture, shape etc.
    assert(uid ~= nil)
    for i = 1, #PHYSICS_ENTITIES do
		local udtable = PHYSICS_ENTITIES[i].fixture:getUserData()
		if udtable.uid == uid then
            return PHYSICS_ENTITIES[i]
        end
    end
    return nil
end

function physics.getPhysEntityXY(uid)
    -- returns a body x/y from an ECS UID
    assert(uid ~= nil)

    local physEntity = physics.getPhysEntity(uid)
    if physEntity ~= nil then
        -- return physEntity.body:getX(), physEntity.body:getY()
		return physEntity.body:getPosition()
    else
        return nil
    end
end

function physics.cancelAngularVelocity(uid)
	local physEntity = physics.getPhysEntity(uid)
    if physEntity ~= nil then
		physEntity.body:setAngularVelocity(0)
	end
end

function physics.processCollision(userdatatable1, userdatatable2, impactspeed)

	local uid1 = userdatatable1.uid
	local uid2 = userdatatable2.uid

	if userdatatable1.objectType == "Border" or userdatatable2.objectType == "Border" then
		-- collision is with border. Do nothing.
	elseif userdatatable1.objectType == "Starbase" or userdatatable2.objectType == "Starbase" then
		-- go to shop
		TRANSLATEX = SCREEN_WIDTH / 2
		TRANSLATEY = SCREEN_HEIGHT / 2
		ZOOMFACTOR = 1
		local physEntity = physics.getPhysEntity(PLAYER.UID)
		local entity = fun.getEntity(PLAYER.UID)
		physEntity.body:setLinearVelocity( 0, 0)

		physEntity.fixture:setSensor(false)

		GAME_TIMER = 0
		GAME_MODE = enum.gamemodePlanning

		-- -- get credit for items in hold
		-- if entity:has("cargoHold") then
		-- 	if entity.cargoHold.currentHP > 0 then
		-- 		local profit = cf.round(entity.cargoHold.currentAmount)
		-- 		if PLAYER.WEALTH == nil then PLAYER.WEALTH = 0 end
		-- 		PLAYER.WEALTH = PLAYER.WEALTH + profit
		-- 		entity.cargoHold.currentAmount = 0
		--
		-- 		local item = {}
		-- 		item.description = "Income"
		-- 		item.amount = profit
		-- 		table.insert(RECEIPT, item)
		-- 	end
		-- end

		-- -- refill consumerables
		-- local allComponents = entity:getComponents()
		-- for _, component in pairs(allComponents) do
		-- 	if component.capacity ~= nil then
		-- 		component.capacity = component.maxCapacity
		-- 	end
		-- end
		-- if entity:has("spaceSuit") then entity.spaceSuit.O2capacity = entity.spaceSuit.maxO2Capacity end
		-- if entity:has("SOSBeacon") then entity.SOSBeacon.activated = false end

		-- AUDIO[enum.audioBGSkismo]:stop()

		-- local temptable = physEntity.fixture:getUserData()
		-- if temptable.objectType == "Pod" then
		-- 	temptable.objectType = "Player"
		-- end

		-- -- re-activate alarm sounds
		-- ALARM_OFF_TIMER = 0

		cf.AddScreen(enum.sceneShop, SCREEN_STACK)
	else
		--! make this a function
		-- collision with asteroids and players
		physicsEntity1 = physics.getPhysEntity(uid1)
		physicsEntity2 = physics.getPhysEntity(uid2)
		assert(physicsEntity1 ~= nil)
		assert(physicsEntity2 ~= nil)

		local mass1 = physicsEntity1.body:getMass( )
		local mass2 = physicsEntity2.body:getMass( )
		local totalmass = mass1 + mass2
		local rndnum = love.math.random(1, totalmass)
		if rndnum <= mass1 then
			-- damage object1
			if userdatatable1.objectType == "Player" or userdatatable1.objectType == "Pod" then
				local entity = fun.getEntity(uid1)
				local component = fun.getRandomComponent(entity)
	print(component.currentHP, impactspeed)
							component.currentHP = component.currentHP - impactspeed
	print(component.currentHP)
				print(component.label .. " is damaged.")
				if component.currentHP <= 0 then
					component.currentHP = 0
				end
				local rndscrape = love.math.random(1,2)
				if rndscrape == 1 then
					SOUND.scrape1 = true
				else
					SOUND.scrape2 = true
				end
			end
		else
			-- damage object2
			if userdatatable2.objectType == "Player" or userdatatable2.objectType == "Pod" then
				local entity = fun.getEntity(uid2)
				local component = fun.getRandomComponent(entity)
	print(component.currentHP, impactspeed)
				component.currentHP = component.currentHP - impactspeed
	print(component.currentHP)
				print(component.label .. " is damaged.")
				if component.currentHP <= 0 then
					component.currentHP = 0
				end
				local rndscrape = love.math.random(1,2)
				if rndscrape == 1 then
					SOUND.scrape1 = true
				else
					SOUND.scrape2 = true
				end
			end
		end
	end



end



return physics
