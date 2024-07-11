--
-- Terran Land-Based Cruise Missile : XEL0306 (UEF T3 MML)
--

local function RandomRange(value)
    return (Random() * 2 - 1) * value
end

local MathCos = math.cos
local MathSin = math.sin

local TMissileCruiseProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile
--local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile
local EffectTemplate = import("/lua/effecttemplates.lua")

---@class TIFMissileCruise08 : TArtilleryAntiMatterProjectile
TIFMissileCruise08 = Class(TMissileCruiseProjectile) {

    FxTrails = EffectTemplate.TMissileExhaust01,
    FxTrailOffset = -0.85,

    FxAirUnitHitScale = 0.65,
    FxLandHitScale = 0.65,
    FxNoneHitScale = 0.65,
    FxPropHitScale = 0.65,
    FxProjectileHitScale = 0.65,
    FxProjectileUnderWaterHitScale = 0.65,
    FxShieldHitScale = 0.65,
    FxUnderWaterHitScale = 0.65,
    FxUnitHitScale = 0.65,
    FxWaterHitScale = 0.65,
    FxOnKilledScale = 0.65,

    ---@param self TIFMissileCruise08
    OnCreate = function(self)
        TMissileCruiseProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
    end,

    ---@param self Projectile
    OnTrackTargetGround = function(self)
        local scatter = self.Launcher.TargetScatterRange or self.Blueprint.Physics.TargetScatterRange or 10
        local targetOffsetX = RandomRange(scatter)
        local targetOffsetZ = RandomRange(scatter)
        local pos
        local target = self.OriginalTarget or self:GetTrackingTarget() or self.Launcher:GetTargetEntity()
        if target and target.IsUnit then
            local unitBlueprint = target.Blueprint
            local cy = unitBlueprint.CollisionOffsetY or 0
            local sx, sy, sz = unitBlueprint.SizeX or 1, unitBlueprint.SizeY or 1, unitBlueprint.SizeZ or 1
            local px, py, pz = target:GetPositionXYZ()

            -- take into account heading
            local heading = -1 * target:GetHeading() -- inverse heading because Supreme Commander :)
            local mch = MathCos(heading)
            local msh = MathSin(heading)

            local physics = self.Blueprint.Physics
            local fuzziness = physics.TrackTargetGroundFuzziness or 0.8
            local offset = physics.TrackTargetGroundOffset or 0
            sx = sx + offset
            sy = sy + offset
            sz = sz + offset

            local dx = (Random() - 0.5) * fuzziness * sx
            local dy = (Random() - 0.5) * fuzziness * sy
            local dz = (Random() - 0.5) * fuzziness * sz

            pos = {
                px + dx * mch - dz * msh,
                py + cy + 0.5 * sy + dy,
                pz + dx * msh + dz * mch,
            }
        else
            pos = self:GetCurrentTargetPosition()
        end
        pos[1] = pos[1] + targetOffsetX
        pos[3] = pos[3] + targetOffsetZ
        pos[2] = GetSurfaceHeight(pos[1], pos[3])
        self:SetNewTargetGround(pos)
    end,
}
TypeClass = TIFMissileCruise08
