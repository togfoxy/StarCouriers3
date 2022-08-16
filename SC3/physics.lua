physics = {}

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
    PHYSICSBORDER1.body = love.physics.newBody(PHYSICSWORLD, 0 + (FIELD_WIDTH / 2), FIELD_HEIGHT, "static") -- x, y.  The shape comes next
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
    starbase.body = love.physics.newBody(PHYSICSWORLD, FIELD_WIDTH / 2, (FIELD_HEIGHT) - 35, "static")
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

function physics.establishPhysicsWorld()
	love.physics.setMeter(1)
	PHYSICSWORLD = love.physics.newWorld(0,0,false)
	PHYSICSWORLD:setCallbacks(beginContact,_,_,postSolve)

	establishWorldBorders()
    establishStarbase()
	-- establishPlayerVessel()
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

function physics.getPhysEntityXY(uid)
    -- returns a body x/y from an ECS UID
    assert(uid ~= nil)

    local physEntity = fun.getPhysEntity(uid)
    if physEntity ~= nil then
        -- return physEntity.body:getX(), physEntity.body:getY()
		return physEntity.body:getPosition()
    else
        return nil
    end
end



return physics
