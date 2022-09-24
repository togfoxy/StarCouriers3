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

            -- get the requested thrust from CARDS
            if entity.uid.value == PLAYER.UID then
                -- this is the player so treat it differently
                requestedthrust = getRequestedThrust()      --! need to factor damaged reverse thrusters
                physEntity = physics.getPhysEntity(PLAYER.UID)

                if ECS_DECK[1].fullStop.selected then
                    local dx, dy = physEntity.body:getLinearVelocity()
                    if math.abs(dx) > 1 or math.abs(dy) > 1 then
                    else
                        physEntity.body:setLinearVelocity(0,0)
                        requestedthrust = 0
                    end
                end
            else
            end

            -- thrust
            if not entity.engine.destroyed then
                local vectordistance = entity.engine.strength * requestedthrust     -- amount of force
                applyForce(physEntity, vectordistance, dt)
            end

            -- apply rotation if necessary
            if not entity.sideThrusters.destroyed then

                local currentrads = cf.round(physEntity.body:getAngle(),2)
                local desiredrads = PLAYER.STOP_HEADING    -- desired heading
                if desiredrads == nil then
                    desiredrads = currentrads
                end

                while currentrads < (math.pi * -2) do
                    currentrads = currentrads + (math.pi * 2)
                end
                while currentrads > (math.pi * 2) do
                    currentrads = currentrads - (math.pi * 2)
                end

                -- if desired is more than 180 deg away then subtract 360 deg making ship turn left (shorter path)
                if (desiredrads - currentrads) > math.pi then
                    desiredrads = desiredrads - (math.pi * 2)
                end
                -- if desired is less than 180 deg away then add 360 deg making the ship turn right (shorter path)
                if (currentrads - desiredrads) > math.pi then
                    desiredrads = desiredrads + (math.pi * 2)
                end

                -- print(currentrads, desiredrads)
                -- print("*************")

                assert(currentrads < math.pi * 2)
                assert(currentrads > (math.pi * -2))

                assert(desiredrads < math.pi * 3)   -- * 3 = 360 + 180 deg
                assert(desiredrads > (math.pi * -3))

                if PLAYER.STOP_HEADING ~= nil then  -- radians

                    if currentrads ~= PLAYER.STOP_HEADING then

                        local angularvelocity = physEntity.body:getAngularVelocity()
                        local kp = 0.2
                        local ki = 0
                        local kd = 0
                        local bias = 0

                        rotation_value_out_prior = rotation_value_out or 0
                        local error = desiredrads - currentrads
                        local integral = rotation_integral_prior + error
                        local derivative = error - rotation_error_prior

                        rotation_value_out = kp * error + ki * integral + kd * derivative + bias    -- global

                        rotation_error_prior = error
                        rotation_integral_prior = integral

                        if angularvelocity < rotation_value_out then
                            physEntity.body:applyTorque(entity.sideThrusters.strength * 1)
                            -- print("AV: " .. angularvelocity, "Output: " .. rotation_value_out, "turning right")
                        else
                            physEntity.body:applyTorque(entity.sideThrusters.strength * -1)
                            -- print("AV: " .. angularvelocity, "Output: " .. rotation_value_out, "turning left")
                        end

                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemEngine)

    systemOxyTank = concord.system({
    pool = {"oxyTank"}
    })
    function systemOxyTank:update(dt)
        for _, entity in ipairs(self.pool) do
            if entity:has("oxyGenerator") and not entity.oxyGenerator.destroyed and entity:has("battery") and not entity.battery.destroyed then
                -- charge the tank in the generator update function
            else
                -- drain the tank
                entity.oxyTank.capacity = entity.oxyTank.capacity - dt
                if entity.oxyTank.capacity <= 0 then entity.oxyTank.capacity = 0 end
            end
        end
    end
    ECSWORLD:addSystems(systemOxyTank)

    systemOxyGen = concord.system({
    pool = {"oxyGenerator"}
    })
    function systemOxyGen:update(dt)
        for _, entity in ipairs(self.pool) do
            if not entity.oxyGenerator.destroyed and entity:has("battery") and not entity.battery.destroyed then
                if entity.battery.capacity > dt then
                    -- charge the tank
                    entity.oxyTank.capacity = entity.oxyTank.capacity + dt
                    if entity.oxyTank.capacity >= entity.oxyTank.maxCapacity then entity.oxyTank.capacity = entity.oxyTank.maxCapacity end
                    -- drain the battery
                    entity.battery.capacity = entity.battery.capacity - dt
                    if entity.battery.capacity < 0 then entity.battery.capacity = 0 end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemOxyGen)
end

return ecsUpdate
