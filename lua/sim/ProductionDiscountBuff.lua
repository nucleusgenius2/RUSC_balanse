local Buff = import("/lua/sim/buff.lua")


---@class DiscountValues
---@field Mass? number
---@field Energy? number

---@class BPEconomyDiscount  : DiscountValues
---@field Units? table<BlueprintId, DiscountValues>


---@param name string
---@param type "Energy" | "Mass"
---@param unit Unit
function RemoveDiscountBuffOfType(name, type, unit)
    local buffName = type .. "Discount" .. name
    if Buff.HasBuff(unit, buffName) then
        Buff.RemoveBuff(unit, buffName)
    end
end

---@param name string
---@param unit Unit
function RemoveDiscountBuff(name, unit)
    RemoveDiscountBuffOfType(name, "Mass", unit)
    RemoveDiscountBuffOfType(name, "Energy", unit)
end

---@param name string
---@param type "Energy" | "Mass"
---@param unit Unit
---@param value number
function ApplyDiscountBuff(name, type, unit, value)

    if not value or value == 0 then
        return
    end

    local buffName = type .. "Discount" .. name
    type = type .. "Active"
    if not Buffs[buffName] then
        BuffBlueprint {
            Name = buffName,
            DisplayName = buffName,
            BuffType = string.upper(buffName),
            Stacks = "ALWAYS",
            Duration = -1,
            Affects = { [type] = { Add = value } },
        }
    end
    if not Buff.HasBuff(unit, buffName) then
        Buff.ApplyBuff(unit, buffName)
    end
end
