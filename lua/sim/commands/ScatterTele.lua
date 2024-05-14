local MathCos = math.cos
local MathSin = math.sin

local scatterRadius = 10

---@param data {Position:Vector, Clear:boolean}
---@param units Unit[]
Function = function(data, units)
    if not data then
        return
    end

    if not data.Position then
        return
    end

    if table.empty(units) then
        return
    end

    if data.Clear then
        IssueClearCommands(units)
    end

    local pos = data.Position
    local ox  = pos[1]
    local oz  = pos[3]
    local n   = table.getn(units)
    local seg = math.pi * 2 / n
    for i, unit in ipairs(units) do
        local x = scatterRadius * MathCos(seg * i) + ox
        local z = scatterRadius * MathSin(seg * i) + oz
        local y = GetTerrainHeight(x, z)
        IssueTeleport({ unit }, Vector(x, y, z))
    end
end
