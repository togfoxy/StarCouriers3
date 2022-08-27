ecsUpdate = {}

local function getRequestedThrust()
    -- loop through the green cards and sum the thrust asked for
    -- rememeber the deck is one entity with lots of components

    local thrust = 0
    local allComponents = ECS_DECK[1]:getComponents()
    for _, component in pairs(allComponents) do
        if component.selected then
            if component.thrust ~= nil then
                thrust = thrust + component.thrust
            end
        end
    end
    if thrust > 1 then thrust = 1 end
    if thrust < -1 then thrust = -1 end
    return thrust
end

local function getRequestedTurn()
    -- returns a number from -1 to 1 meaning full left or full right or in between. 0 means no turn
    local rotation = 0
    local allComponents = ECS_DECK[1]:getComponents()
    for _, component in pairs(allComponents) do
        if component.selected then
            if component.rotation ~= nil then
                rotation = rotation + component.rotation
            end
        end
    end
    if rotation > 1 then rotation = 1 end
    if rotation < -1 then rotation = -1 end
    return rotation
end

local function applyForce(physEntity, vectordistance, dt)
    local x1, y1 = physEntity.body:getPosition()
    local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
    facing = cf.convRadToCompass(facing)

    local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
    local xvector = (x2 - x1) * 20 * dt
    local yvector = (y2 - y1) * 20 * dt

    physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance
end

function ecsUpdate.init()
    systemEngine = concord.system({
    pool = {"engine"}
    })
    function systemEngine:update(dt)
        for _, entity in ipairs(self.pool) do
            local requestedthrust = 0
            local requestedturn = 0
            if entity.uid.value == PLAYER.UID then
                -- this is the player so treat it differently
                -- get the requested thrust from CARDS
                requestedthrust = getRequestedThrust()
                requestedturn = getRequestedTurn()
            else

            end

            if entity.engine.currentHP > 0 then
                -- thrust
                local physEntity = physics.getPhysEntity(PLAYER.UID)
                local vectordistance = entity.engine.strength * requestedthrust     -- amount of force
                applyForce(physEntity, vectordistance, dt)

                -- apply rotation
                -- requestedturn is a number from -1 to 1
                physEntity.body:applyTorque(entity.sideThrusters.rotation * requestedturn)
            end
        end
    end
    ECSWORLD:addSystems(systemEngine)
end

return ecsUpdate
