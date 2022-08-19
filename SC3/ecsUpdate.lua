ecsUpdate = {}

function ecsUpdate.init()
    systemEngine = concord.system({
    pool = {"engine"}
    })
    function systemEngine:update(dt)
        for _, entity in ipairs(self.pool) do

        end
    end
    ECSWORLD:addSystems(systemEngine)
end

return ecsUpdate
