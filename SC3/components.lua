comp = {}

local function initialiseShipComponents()

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
        c.description = "Main propulsion. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
        c.x = -10
        c.y = 10
    end)
    concord.component("sideThrusters", function(c)
		c.label = "Side thrusters"
        c.size = love.math.random(1,3) + love.math.random(1,3)      -- left + right thrusters so do size twice
        c.rotation = PHYSICS_TURNRATE + love.math.random(1,6) * 50      -- rotation strength (angular)
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 2000
        c.description = "Turns your vessel. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.rotation .. "."
        c.description = c.description .. "\nStronger thrusters enable faster turning."
    end)


end

local function initialiseDeckComponents()
    -- don't forget to :give inside functions.loadDeck()

    concord.component("dummy", function(c)
        c.label = nil
    end)
    concord.component("fullThrust", function(c)
        c.label = "Full forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 1.00          -- 100% = full thrust
        c.quadnumber = 2           -- which quad to draw
    end)
    concord.component("halfThrust", function(c)
        c.label = "Half forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.50          -- 100% = full thrust
        c.quadnumber = 6           -- which quad to draw
    end)
    concord.component("quarterThrust", function(c)
        c.label = "Quarter forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.25          -- 100% = full thrust
        c.quadnumber = 10           -- which quad to draw
    end)
    concord.component("fullReverse", function(c)
        c.label = "Full reverse"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = -1.00          -- 100% = full thrust
        c.quadnumber = 4           -- which quad to draw
    end)

    concord.component("turnToNorth", function(c)
        c.label = "Turn to north"
        c.selected = false
        c.targetheading = 0
        c.quadnumber = nil           -- which quad to draw
    end)
    concord.component("turnToNorthEast", function(c)
        c.label = "Turn to north east"
        c.selected = false
        c.targetheading = 45
        c.quadnumber = nil           -- which quad to draw
    end)







    -- concord.component("fullPortTurn", function(c)
    --     c.label = "Full turn to port"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = -1          -- this is negative so turns counter clockwise
    --     c.quadnumber = 1           -- which quad to draw
    -- end)
    -- concord.component("halfPortTurn", function(c)
    --     c.label = "Half turn to port"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = -0.5          -- this is negative so turns counter clockwise
    --     c.quadnumber = 5           -- which quad to draw
    -- end)
    -- concord.component("quarterPortTurn", function(c)
    --     c.label = "Quarter turn to port"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = -0.25          -- this is negative so turns counter clockwise
    --     c.quadnumber = 9           -- which quad to draw
    --
    -- end)
    -- concord.component("fullStarboardTurn", function(c)
    --     c.label = "Full turn to starboard"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = 1          -- this is negative so turns counter clockwise
    --     c.quadnumber = 3           -- which quad to draw
    -- end)
    --
    -- concord.component("halfStarboardTurn", function(c)
    --     c.label = "Half turn to starboard"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = 0.5          -- this is negative so turns counter clockwise
    --     c.quadnumber = 7           -- which quad to draw
    -- end)
    -- concord.component("quarterStarboardTurn", function(c)
    --     c.label = "Quarter turn to starboard"
    --     c.x = 0     -- used for drawing and positioning and detecting mouse clicks
    --     c.y = 0
    --     c.selected = false      -- true if clicked and ready to play
    --     c.rotation = 0.25          -- this is negative so turns counter clockwise
    --     c.quadnumber = 11           -- which quad to draw
    -- end)
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
