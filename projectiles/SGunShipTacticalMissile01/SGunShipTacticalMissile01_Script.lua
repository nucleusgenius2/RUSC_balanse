
local SLaanseTacticalMissile = import("/lua/seraphimprojectiles.lua").SLaanseTacticalMissile
local TacticalMissileComponent = import('/lua/sim/DefaultProjectiles.lua').TacticalMissileComponent

--- Used by XSL0111
---@class SIFLaanseTacticalMissile01 : SLaanseTacticalMissile, TacticalMissileComponent
SIFLaanseTacticalMissile01 = ClassProjectile(SLaanseTacticalMissile, TacticalMissileComponent) {

    LaunchTicks = 6,
    LaunchTicksRange = 1,
    LaunchTurnRate = 8,
    LaunchTurnRateRange = 1,
    HeightDistanceFactor = 5,
    HeightDistanceFactorRange = 0,
    MinHeight = 4,
    MinHeightRange = 0,
    FinalBoostAngle = 12,
    FinalBoostAngleRange = 2,

    OnCreate = function(self)
        SLaanseTacticalMissile.OnCreate(self)
        self.MoveThread = self.Trash:Add(ForkThread(self.MovementThread, self))
    end,
	
    MovementThread = function(self)
        self.WaitTime = 0.1
        self.Distance = self:GetDistanceToTarget()
        self:SetTurnRate(8)
        WaitSeconds(0.3)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > self.Distance then
            self:SetTurnRate(75)
            WaitSeconds(3)
            self:SetTurnRate(8)
            self.Distance = self:GetDistanceToTarget()
        end
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(10)
        elseif dist > 30 and dist <= 50 then
                        self:SetTurnRate(12)
                        WaitSeconds(1.5)
            self:SetTurnRate(12)
        elseif dist > 10 and dist <= 25 then
            WaitSeconds(0.3)
            self:SetTurnRate(50)
        elseif dist > 0 and dist <= 10 then
            self:SetTurnRate(100)
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
TypeClass = SIFLaanseTacticalMissile01