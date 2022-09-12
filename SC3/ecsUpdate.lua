ecsUpdate = {}

local function getTurnDirection(currentheading, desiredheading)
    -- returns a string: "left" or "right"
    local result
    local angledelta = desiredheading - currentheading

    -- determine if cheaper to turn left or right
    local leftdistance = currentheading - desiredheading
    if leftdistance < 0 then leftdistance = 360 + leftdistance end      -- this is '+' because leftdistance is a negative value

    local rightdistance = desiredheading - currentheading
    if rightdistance < 0 then rightdistance = 360 + rightdistance end   -- this is '+' because leftdistance is a negative value

    if leftdistance < rightdistance then
        result = "left"
    elseif rightdistance < leftdistance then
        result = "right"
    else
        result = "none"     -- no turning required
    end
    return result
end

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
            local physEntity
            local requestedthrust = 0
            local requestedturn = 0
            if entity.uid.value == PLAYER.UID then
                -- this is the player so treat it differently
                -- get the requested thrust from CARDS
                requestedthrust = getRequestedThrust()      --! need to factor damaged reverse thrusters
                -- requestedturn = getRequestedTurn()

                physEntity = physics.getPhysEntity(PLAYER.UID)
            else
            end

            if entity.engine.currentHP > 0 then
                -- thrust

                local vectordistance = entity.engine.strength * requestedthrust     -- amount of force
                applyForce(physEntity, vectordistance, dt)
            end

            if entity.sideThrusters.currentHP > 0 then
                -- apply rotation if necessary
                local currentheading = cf.convRadToCompass(physEntity.body:getAngle())
                if PLAYER.STOP_HEADING ~= nil then
                    if currentheading ~= PLAYER.STOP_HEADING then

                        local kp = 0.2
                        local ki = 0.001
                        local kd = 0.1
                        local bias = 0

                        setRps = PLAYER.STOP_HEADING
                        getRps = currentheading

                        value_out_prior = value_out or 0
                        error = setRps - getRps
                        integral = integral_prior+error
                        derivative = error-error_prior

                        value_out = kp*error+ki*integral+kd*derivative+bias

                        error_prior = error
                        integral_prior = integral

                        if value_out > value_out_prior then
                            physEntity.body:applyTorque(entity.sideThrusters.rotation * 1)
                            print(cf.round(value_out), error, physEntity.body:getAngularVelocity(), "turning right")
                        else
                            physEntity.body:applyTorque(entity.sideThrusters.rotation * -1)
                            print(cf.round(value_out), error, physEntity.body:getAngularVelocity(), "turning left")
                        end

    -- print(setRps,getRps,error)

                        if math.abs(error) <= 1 and math.abs(physEntity.body:getAngularVelocity()) <= 0.15 then
                            physEntity.body:setAngle(cf.convCompassToRad(PLAYER.STOP_HEADING))
                            physEntity.body:setAngularVelocity(0)
                            PLAYER.STOP_HEADING = nil
                            error_prior = 0
                            integral_prior = 0
                            value_out_prior = 0
                        end
                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemEngine)
end

return ecsUpdate
