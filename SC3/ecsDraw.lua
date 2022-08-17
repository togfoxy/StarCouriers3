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


            -- for each component
            -- get the x/y of the component
            -- get the size of the component
            -- get the corners of the component
            -- draw the component

            end
        end

    end
    ECSWORLD:addSystems(systemDraw)
end
return ecsDraw
