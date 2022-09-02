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
                local targetheading = fun.getDesiredHeading()                    -- returns desired compass heading
                if targetheading == nil then targetheading = currentheading end

                local kp = 0.1
                local ki = 0.1
                local kd = 0.1
                local error = targetheading - currentheading
                integral = integral + (error * dt)
                derivative = (error - previous_error) / dt
                local output = (kp * error) + (ki * integral) + (kd * derivative)
                previous_error = error

            print("PID output:" .. output)

                local turndirection = getTurnDirection(currentheading, targetheading)
                if output < 25 then turndirection = "left" end
                if output > 25 then turndirection = "right" end
                if output == 0 then turndirection = "none" end

                -- if dt < GAME_TIMER_DEFAULT then
                --     -- turn towards desired heading
                -- else
                --     -- start the counter turn
                --     if turndirection == "left" then
                --         turndirection = "right"
                --     elseif turndirection == "right" then
                --         turndirection = "left"
                --     else
                --     end
                -- end

                local turnpower = math.abs(targetheading - currentheading)
                turnpower = turnpower / 90        -- arbitrary number
                if turnpower > 1 then turnpower = 1 end

                turnpower = 1

                if turndirection == "left" then
                    physEntity.body:applyTorque(entity.sideThrusters.rotation * turnpower * -1)
                    -- print("Applying left hand turn", currentheading, targetheading, turnpower)
                elseif turndirection == "right" then
                    physEntity.body:applyTorque(entity.sideThrusters.rotation * turnpower  * 1)
                    -- print("Applying right hand turn", currentheading, targetheading, turnpower)
                else
                    physEntity.body:setAngularVelocity(0)
                end

                -- error = setpoint - input
                -- integral = integral + error * dt
                -- derivative = (error - previous error) / dt
                -- output = kp*error + ki*integral + kd*derivate
                -- previous error = error


            end
        end
    end
    ECSWORLD:addSystems(systemEngine)
end

return ecsUpdate
