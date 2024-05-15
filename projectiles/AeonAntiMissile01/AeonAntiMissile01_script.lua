--
-- Aeon Very Fast Anti-Missile Missile
--
local AIMFlareProjectile = import("/lua/aeonprojectiles.lua").AIMFlareProjectile

AeonAntiMissile01 = ClassProjectile(AIMFlareProjectile) {
    OnCreate = function(self)
        AIMFlareProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
    end,
}

TypeClass = AeonAntiMissile01
