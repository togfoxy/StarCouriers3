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
end

local function initialiseDeckComponents()

    concord.component("dummy", function(c)
        c.label = nil
    end)
    concord.component("fullThrust", function(c)
        c.label = "Full forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 1.00          -- 100% = full thrust
    end)
    concord.component("halfThrust", function(c)
        c.label = "Half forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.50          -- 100% = full thrust
    end)
    concord.component("quarterThrust", function(c)
        c.label = "Quarter forward thrust"
        c.x = 0     -- used for drawing and positioning and detecting mouse clicks
        c.y = 0
        c.selected = false      -- true if clicked and ready to play
        c.thrust = 0.25          -- 100% = full thrust
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
