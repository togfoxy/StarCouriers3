ecsDraw = {}

local function drawPolygon(body)
    for _, fixture in pairs(body:getFixtures()) do
        local shape = fixture:getShape()
        local points = {body:getWorldPoints(shape:getPoints())}
        for i = 1, #points do
            points[i] = points[i] * BOX2D_SCALE
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.polygon("line", points)
    end
end

local function drawVelocity(str, x1, y1)
    -- x1, y1 = the position of the entity
    -- input string and screen coordinates
    -- doesn't use entity etc

    -- print the text
    drawx = x1 + 150
    drawy = y1 - 115
    love.graphics.setFont(FONT[enum.fontDefault])
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(str, drawx, drawy)

    -- draw a cool line
    x2, y2 = cf.AddVectorToPoint(x1,y1,45,75)
    x3, y3 = cf.AddVectorToPoint(x2,y2,45,75)
    x4, y4 = cf.AddVectorToPoint(x3,y3,90,35)

    love.graphics.line(x2,y2,x3,y3,x4,y4)
end

function ecsDraw.init()
    systemDraw = concord.system({
    pool = {"drawable"}
    })
-- define same systems
    function systemDraw:draw()
        love.graphics.setColor(1,1,1,1)
        for _, entity in ipairs(self.pool) do
            -- get the x/y of physical object
            local physEntity = physics.getPhysEntity(entity.uid.value)
            if physEntity ~= nil then
                drawPolygon(physEntity.body)

                -- draw the 'front' if player vessel
                if entity.uid.value == PLAYER.UID then
                    local facingrad = physEntity.body:getAngle()       -- radians
                    local facingdeg = cf.convRadToCompass(facingrad)
                    local x1,y1 = physEntity.body:getPosition()
                    local x2,y2 = cf.AddVectorToPoint(x1, y1, facingdeg, 15)
                    x1 = x1 * BOX2D_SCALE
                    y1 = y1 * BOX2D_SCALE
                    x2 = x2 * BOX2D_SCALE
                    y2 = y2 * BOX2D_SCALE
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.line(x1,y1,x2,y2)

                    -- draw vessel velocity
                    local x,y = physEntity.body:getLinearVelocity()
                    local velocity = cf.round(cf.GetDistance(0,0,x,y),1)
                    drawVelocity(velocity, x1, y1)
                end
            end
        end

    end
    ECSWORLD:addSystems(systemDraw)
end
return ecsDraw
