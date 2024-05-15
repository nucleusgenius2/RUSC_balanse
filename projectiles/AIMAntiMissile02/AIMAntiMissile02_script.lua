local Flare = import("/lua/defaultantiprojectile.lua").Flare
local EffectTemplate = import("/lua/effecttemplates.lua")
local AIMFlareProjectile = import("/lua/aeonprojectiles.lua").AIMFlareProjectile
local EmitterProjectile = import("/lua/sim/defaultprojectiles.lua").EmitterProjectile
local EmitterProjectileOnCreate = EmitterProjectile.OnCreate

-- local function Duplicate(item, n)
--     local t = {}
--     for i = 1, n do
--         table.insert(t, item)
--     end
--     return t
-- end

---@class AIMAntiMissile02 : AIMFlareProjectile
AIMAntiMissile02 = ClassProjectile(AIMFlareProjectile) {
    -- FxTrails = Duplicate(EffectTemplate.AAntiMissileFlare[1], 6),
    -- FxImpactNone = Duplicate(EffectTemplate.AAntiMissileFlareHit[1], 6),
    -- FxImpactProjectile = Duplicate(EffectTemplate.AAntiMissileFlareHit[1], 6),
    -- FxOnKilled = Duplicate(EffectTemplate.AAntiMissileFlareHit[1], 6),

      ---@param self AIMAntiMissile02
    ---@param inWater boolean
    OnCreate = function(self, inWater)
        EmitterProjectileOnCreate(self, inWater)
        self.RedirectedMissiles = 0
        self.MaxRedirectedMissles = self.Blueprint.Defense.MaxRedirectedMissles or 3
        -- missiles that hit the flare are immediately neutralized
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)

        -- Create several flares of different sizes. A collision check is done when an entity enters the
        -- collision box of another entity. As long as the entity remains inside no additional checks
        -- are done. Therefore we create several flares of different sizes to catch missiles that are
        -- far out and close by.

        local flareSpecs = {
            Radius = 40,
            Owner = self,
            Category = "MISSILE TACTICAL",
        }

        local trash = self.Trash
        for k = 1, self.MaxRedirectedMissles do
            flareSpecs.Radius = 8 + k * 3.2
            trash:Add(Flare(flareSpecs))
        end
    end,
}

TypeClass = AIMAntiMissile02
