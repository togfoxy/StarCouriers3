comp = {}

local function initialiseShipComponents()
    -- define components here
    -- then give them to the player in functions.establishPlayerECS()

    concord.component("chassis", function(c)
        c.label = "Chassis"
        c.size = love.math.random(2,4)
        c.maxHP = 4000 + love.math.random(1,10) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Vessel frame. Size " .. c.size .. ". Health " .. c.maxHP .. "."
        c.x = 10
        c.y = 10
    end)

    concord.component("engine", function(c)
        c.label = "Main engine"
        c.size = love.math.random(2,4)
        c.strength = 4000 + love.math.random(1,10) * 1000     -- thrust
        c.maxHP = love.math.random(2,4) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.destroyed = false
        c.description = "Main propulsion. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
        c.x = -10
        c.y = 10
    end)
    concord.component("sideThrusters", function(c)
		c.label = "Side thrusters"
        c.size = love.math.random(1,3) + love.math.random(1,3)      -- left + right thrusters so do size twice
        c.strength = PHYSICS_TURNRATE + love.math.random(1,6) * 50      -- rotation strength (angular)
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 2000
        c.destroyed = false
        c.description = "Turns your vessel. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
        c.description = c.description .. "\nStronger thrusters enable faster turning."
    end)
    concord.component("battery", function(c)
        c.label = "Battery"
        c.size = love.math.random(1,3)
        c.capacity = love.math.random(60, 240)   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Powers lasers. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capacity " .. c.maxCapacity .. "."
    end)
    concord.component("oxyTank", function(c)
        c.label = "O2 tank"
        c.size = love.math.random(1,3)
        c.capacity = love.math.random(300, 600)   -- 430   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.destroyed = false
        c.description = "Holds spare oxygen. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capactiy " .. c.capacity .. " seconds."
    end)
    concord.component("oxyGenerator", function(c)
        c.label = "O2 Generator"
        c.size = love.math.random(1,3)
        c.powerNeeds = love.math.random(1,3)        -- how much power per dt
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.destroyed = false
        c.description = "Makes O2 to keep you alive. Size " .. c.size .. ". Health " .. c.maxHP .. ". Draws " .. c.powerNeeds .. " per second."
    end)

end

local function initialiseDeckComponents()
    -- don't forget to :give inside functions.loadDeck()
    -- quadnumber = nil means there is no image/quad

    concord.component("dummy", function(c)
        c.label = nil
    end)
    concord.component("fullThrust", function(c)
        c.label = "Full forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 1.00          -- 100% = full thrust
        c.quadnumber = 3           -- which quad to draw
    end)
    concord.component("halfThrust", function(c)
        c.label = "Half forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.50          -- 100% = full thrust
        c.quadnumber = 4           -- which quad to draw
    end)
    concord.component("quarterThrust", function(c)
        c.label = "Quarter forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.25          -- 100% = full thrust
        c.quadnumber = nil          -- which quad to draw
    end)
    concord.component("fullReverse", function(c)
        c.label = "Full reverse"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = -1.00          -- 100% = full thrust
        c.quadnumber = 12           -- which quad to draw
    end)
    concord.component("halfReverse", function(c)
        c.label = "Half reverse"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = -0.500          -- 100% = full thrust
        c.quadnumber = 8           -- which quad to draw
    end)

    concord.component("turnToNorth", function(c)
        c.label = "Turn to north"
        c.selected = false
        c.targetheading = 0
        c.quadnumber = 6           -- which quad to draw
    end)
    concord.component("turnToNorthEast", function(c)
        c.label = "Turn to north east"
        c.selected = false
        c.targetheading = 45
        c.quadnumber = 7           -- which quad to draw
    end)
    concord.component("turnToEast", function(c)
        c.label = "Turn to east"
        c.selected = false
        c.targetheading = 90
        c.quadnumber = 2           -- which quad to draw
    end)
    concord.component("turnToSouthEast", function(c)
        c.label = "Turn to south east"
        c.selected = false
        c.targetheading = 135
        c.quadnumber = 11           -- which quad to draw
    end)
    concord.component("turnToSouth", function(c)
        c.label = "Turn to south"
        c.selected = false
        c.targetheading = 180
        c.quadnumber = 10           -- which quad to draw
    end)
    concord.component("turnToSouthWest", function(c)
        c.label = "Turn to south west"
        c.selected = false
        c.targetheading = 225
        c.quadnumber = 9           -- which quad to draw
    end)
    concord.component("turnToWest", function(c)
        c.label = "Turn to west"
        c.selected = false
        c.targetheading = 270
        c.quadnumber = 1           -- which quad to draw
    end)
    concord.component("turnToNorthWest", function(c)
        c.label = "Turn to north west"
        c.selected = false
        c.targetheading = 315
        c.quadnumber = 5           -- which quad to draw
    end)

end

function comp.init()

    -- common components
    concord.component("uid", function(c)
        c.value = cf.Getuuid()
    end)

    concord.component("drawable", function(c)
        c.imageEnum = 0     -- needs to be set after instantiating
        c.x = 0             -- position relative to vessel centre
        c.y = 0
    end)

    initialiseShipComponents()
    initialiseDeckComponents()          -- deck of cards

end

return comp
