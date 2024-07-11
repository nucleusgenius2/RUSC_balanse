--
-- Terran Land-Based Cruise Missile : XEL0306 (UEF T3 MML)
--

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
        self.MoveThread = self.Trash:Add(ForkThread(self.MovementThread, self))
        local targetLocation = self:GetCurrentTargetPosition()
        if targetLocation then
            local scatter = self.Blueprint.Physics.TargetScatterRange or 10
            local targetOffsetX = Random(-scatter, scatter)
            local targetOffsetZ = Random(-scatter, scatter)
            self:SetNewTargetGround(
                Vector(
                    targetLocation.x + targetOffsetX,
                    targetLocation.y,
                    targetLocation.z + targetOffsetZ
                ))
        end
    end,

    MovementThread = function(self)
        self.Distance = self:GetDistanceToTarget()
        self:SetTurnRate(8)
        WaitTicks(4)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitTicks(2)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitTicks(13)
            self:SetTurnRate(14)
        elseif dist > 30 and dist <= 50 then
            -- Increase check intervals
            self:SetTurnRate(18)
            WaitTicks(8)
            self:SetTurnRate(18)
        elseif dist > 10 and dist <= 25 then
            -- Further increase check intervals
            WaitTicks(2)
            self:SetTurnRate(68)
        elseif dist > 5 and dist <= 10 then
            -- Further increase check intervals
            self:SetTurnRate(100)
        elseif dist > 0 and dist <= 2 then
            self:SetTurnRate(150)
            KillThread(self.MoveThread)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}
TypeClass = TIFMissileCruise08
