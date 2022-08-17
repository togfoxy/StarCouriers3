comp = {}

function comp.init()

    concord.component("uid", function(c)
        c.value = cf.Getuuid()
    end)

    concord.component("drawable", function(c)
        c.imageEnum = 0     -- needs to be set after instantiating
        c.x = 0             -- position relative to vessel centre
        c.y = 0
    end)

    concord.component("chassis", function(c)
		c.label = "Chassis"
        c.size = love.math.random(2,4)
		c.maxHP = 4000 + love.math.random(1,10) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Vessel frame. Size " .. c.size .. ". Health " .. c.maxHP .. "."
    end)

    concord.component("engine", function(c)
    c.label = "Main engine"
    c.size = love.math.random(2,4)
    c.strength = 4000 + love.math.random(1,10) * 1000     -- thrust
    c.maxHP = love.math.random(2,4) * 1000
    c.currentHP = c.maxHP
    c.purchasePrice = 1000
    c.description = "Main propulsion. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
end)

end

return comp
