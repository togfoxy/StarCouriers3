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
                end
            end
        end

    end
    ECSWORLD:addSystems(systemDraw)
end
return ecsDraw
