StructureUnit = import("/lua/sim/units/structureunit.lua").StructureUnit
local NukeDamage = import("/lua/sim/nukedamage.lua").NukeAOE
local Weapon = import("/lua/sim/weapon.lua").Weapon
local Entity = import("/lua/sim/entity.lua").Entity

local WeaponFile = import("/lua/sim/defaultweapons.lua")
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon

local SIFExperimentalStrategicMissile = import("/lua/seraphimweapons.lua").SIFExperimentalStrategicMissile
local DeathNukeWeapon = import("/lua/sim/defaultweapons.lua").DeathNukeWeapon

local beams = { '/effects/emitters/uef_orbital_death_laser_beam_02_emit.bp' }
local beams = { '/effects/emitters/quantum_generator_beam_01_emit.bp' }
local FxBeamEndPoint = {
    '/effects/emitters/uef_orbital_death_laser_end_01_emit.bp', -- big glow
    '/effects/emitters/uef_orbital_death_laser_end_02_emit.bp', -- random bright blueish dots
    '/effects/emitters/uef_orbital_death_laser_end_03_emit.bp', -- darkening lines
    '/effects/emitters/uef_orbital_death_laser_end_04_emit.bp', -- molecular, small details
    '/effects/emitters/uef_orbital_death_laser_end_05_emit.bp', -- rings
    '/effects/emitters/uef_orbital_death_laser_end_06_emit.bp', -- upward sparks
    '/effects/emitters/uef_orbital_death_laser_end_07_emit.bp', -- outward line streaks
    '/effects/emitters/uef_orbital_death_laser_end_08_emit.bp', -- center glow
    '/effects/emitters/uef_orbital_death_laser_end_distort_emit.bp', -- screen distortion
}
local FxBeamStartPoint = {
    '/effects/emitters/uef_orbital_death_laser_muzzle_01_emit.bp', -- random bright blueish dots
    '/effects/emitters/uef_orbital_death_laser_muzzle_02_emit.bp', -- molecular, small details
    '/effects/emitters/uef_orbital_death_laser_muzzle_03_emit.bp', -- darkening lines
    '/effects/emitters/uef_orbital_death_laser_muzzle_04_emit.bp', -- small downward sparks
    '/effects/emitters/uef_orbital_death_laser_muzzle_05_emit.bp', -- big glow
}
local Scale = 10
---@class LaserEnd : Entity
---@field Trash TrashBag
LaserEnd = Class(Entity)
{
    OnCreate = function(self)
        self.Trash = TrashBag()
    end,

    OnDestroy = function(self)
        self.Trash:Destroy()
    end
}

---@class UEB1901 : StructureUnit
---@field EffectsBag TrashBag
---@field Effects TrashBag
UEB1901 = ClassUnit(StructureUnit) {
    Weapons = {
        DeathWeapon = ClassWeapon(SIFExperimentalStrategicMissile) {
            ---@param self SIFExperimentalStrategicMissile
            Fire = function(self)
                local bp = self.Blueprint
                local proj = self:CreateProjectileAtMuzzle(0)
                proj:OnCreate()
                proj.InnerRing = NukeDamage()
                proj.InnerRing:OnCreate(bp.NukeInnerRingDamage, bp.NukeInnerRingRadius, bp.NukeInnerRingTicks,
                    bp.NukeInnerRingTotalTime)
                proj.OuterRing = NukeDamage()
                proj.OuterRing:OnCreate(bp.NukeOuterRingDamage, bp.NukeOuterRingRadius, bp.NukeOuterRingTicks,
                    bp.NukeOuterRingTotalTime)
                proj:OnImpact('Terrain', nil)

                local pos = self.unit:GetPosition()

                local n = 5
                local degree = 2 * math.pi / n
                local offset = Random()
                local curAngle
                local radius = 75
                for i = 1, n do
                    curAngle = i * degree + offset
                    local proj = self.unit:CreateProjectile("/projectiles/TIFMissileNuke01/TIFMissileNuke01_proj.bp", 0,
                        0, 0, nil, nil, nil)
                    --local proj = self:CreateProjectileAtMuzzle(0)
                    proj:SetPosition(Vector(
                        pos[1] + radius * math.cos(curAngle),
                        pos[2],
                        pos[3] + radius * math.sin(curAngle)
                    ), true)
                    proj:OnCreate()

                    proj.InnerRing = NukeDamage()
                    proj.InnerRing:OnCreate(bp.NukeInnerRingDamage, bp.NukeInnerRingRadius, bp.NukeInnerRingTicks,
                        bp.NukeInnerRingTotalTime)
                    proj.OuterRing = NukeDamage()
                    proj.OuterRing:OnCreate(bp.NukeOuterRingDamage, bp.NukeOuterRingRadius, bp.NukeOuterRingTicks,
                        bp.NukeOuterRingTotalTime)

                    proj:OnImpact('Terrain', nil)
                end

            end,
        },
        ---@class AntimatterExplosion : SIFExperimentalStrategicMissile
        AntimatterExplosion = ClassWeapon(SIFExperimentalStrategicMissile) {

            OnCreate = function(self)
                SIFExperimentalStrategicMissile.OnCreate(self)
                self.EffectsBag = TrashBag()
                self.Effects = TrashBag()
                self._ChargeThread = nil
                self._DischargeThread = nil
            end,

            ChargeThread = function(self, loadTimeTicks)
                local i = loadTimeTicks
                local launcher = self.unit
                while i >= 0 do
                    local progress = (loadTimeTicks - i) / loadTimeTicks
                    for _, effect in self.Effects do
                        effect:ScaleEmitter(progress * Scale)
                    end
                    i = i - 1
                    launcher:SetWorkProgress(progress)
                    WaitTicks(1)
                end
            end,

            DisChargeThread = function(self, loadTimeTicks)
                local i = loadTimeTicks
                local launcher = self.unit
                while i >= 0 do
                    local progress = i / loadTimeTicks
                    for _, effect in self.Effects do
                        effect:ScaleEmitter(progress * Scale)
                    end
                    i = i - 1
                    WaitTicks(1)
                end
                self.Effects:Destroy()
            end,

            CreateChargeEffects = function(self)
                local launcher      = self.unit
                local pos           = launcher:GetPosition()
                local location      = self:GetCurrentTargetPos()
                self.TargetLocation = location
                local army          = launcher.Army

                ---@type LaserEnd
                local skyEntity = LaserEnd()
                self.skyEntity1 = skyEntity
                ---@type LaserEnd
                local landEntity = LaserEnd()
                self.landEntity = landEntity
                ---@type LaserEnd
                local skyEntity2 = LaserEnd()
                self.skyEntity2 = skyEntity2

                for _, beamFx in beams do
                    local beam = AttachBeamEntityToEntity(launcher, -1, skyEntity, -1, army, beamFx)
                    self.EffectsBag:Add(beam)
                end

                skyEntity:SetPosition(Vector(pos[1], pos[2] + 200, pos[3]), true)
                landEntity:SetPosition(location, true)
                skyEntity2:SetPosition(Vector(location[1], location[2] + 200, location[3]), true)

                for _, beamFx in beams do
                    local beam = AttachBeamEntityToEntity(skyEntity2, -1, landEntity, -1, army, beamFx)
                    self.EffectsBag:Add(beam)
                end

                for k, y in FxBeamStartPoint do
                    local fx = CreateAttachedEmitter(launcher, 0, army, y):ScaleEmitter(0)
                    self.Effects:Add(fx)
                end
                for k, y in FxBeamEndPoint do
                    local fx = CreateAttachedEmitter(landEntity, -1, army, y):ScaleEmitter(0)
                    self.Effects:Add(fx)
                end

                self.Trash:Add(skyEntity)
                self.Trash:Add(skyEntity2)
                self.Trash:Add(landEntity)
            end,

            RemoveChargeEffects = function(self)
                if self._ChargeThread then
                    self._ChargeThread:Destroy()
                    self._ChargeThread = nil
                end
                self.EffectsBag:Destroy()
                if self.skyEntity then
                    self.skyEntity:Destroy()
                end
                if self.landEntity then
                    self.landEntity:Destroy()
                end
                if self.skyEntity2 then
                    self.skyEntity2:Destroy()
                end
            end,

            -- Idle state is when the weapon has no target and is done with any animations or unpacking
            IdleState = State(SIFExperimentalStrategicMissile.IdleState) {

                Main = function(self)
                    SIFExperimentalStrategicMissile.IdleState.Main(self)
                    self:RemoveChargeEffects()
                end,
            },
            RackSalvoChargeState = State(SIFExperimentalStrategicMissile.RackSalvoChargeState) {
                Main = function(self)
                    local unit = self.unit
                    local bp = self.Blueprint
                    local notExclusive = bp.NotExclusive
                    unit:SetBusy(true)
                    self:PlayFxRackSalvoChargeSequence()

                    if notExclusive then
                        unit:SetBusy(false)
                    end

                    -- Generate UI notification for automatic nuke ping
                    local launchData = {
                        army = self.Army - 1,
                        location = (GetFocusArmy() == -1 or IsAlly(self.Army, GetFocusArmy())) and
                            self:GetCurrentTargetPos() or nil
                    }
                    if not Sync.NukeLaunchData then
                        Sync.NukeLaunchData = {}
                    end
                    table.insert(Sync.NukeLaunchData, launchData)

                    self:CreateChargeEffects()
                    self._ChargeThread = self:ForkThread(self.ChargeThread, bp.RackSalvoChargeTime * 10)
                    WaitSeconds(bp.RackSalvoChargeTime)

                    if notExclusive then
                        unit:SetBusy(true)
                    end

                    ChangeState(self, self.RackSalvoFiringState)
                end,
            },
            RackSalvoReloadState = State(SIFExperimentalStrategicMissile.RackSalvoReloadState)
            {
                Clock = function(self, unit, time)
                    for i = 1, time do
                        unit:SetWorkProgress(i / time)
                        WaitTicks(1)
                    end
                end,

                Main = function(self)
                    local unit = self.unit
                    unit:SetBusy(true)
                    self:PlayFxRackSalvoReloadSequence()

                    local bp = self.Blueprint
                    local notExclusive = bp.NotExclusive

                    if notExclusive then
                        unit:SetBusy(false)
                    end

                    self:ForkThread(self.Clock, self.unit, bp.RackSalvoReloadTime * 10)
                    WaitSeconds(bp.RackSalvoReloadTime)

                    self:WaitForAndDestroyManips()

                    local hasTarget = self:WeaponHasTarget()
                    local canFire = self:CanFire()

                    if hasTarget and bp.RackSalvoChargeTime > 0 and canFire then
                        ChangeState(self, self.RackSalvoChargeState)
                    elseif hasTarget and canFire then
                        ChangeState(self, self.RackSalvoFireReadyState)
                    elseif not hasTarget and bp.WeaponUnpacks and not bp.WeaponUnpackLocksMotion then
                        ChangeState(self, self.WeaponPackingState)
                    else
                        ChangeState(self, self.IdleState)
                    end
                end,
            },
            RackSalvoFiringState = State(SIFExperimentalStrategicMissile.RackSalvoFiringState)
            {
                ---@param self AntimatterExplosion
                Main = function(self)
                    local bp = self.Blueprint
                    local launcher = self.unit
                    ---@type Projectile
                    local proj = self:CreateProjectileAtMuzzle(0)
                    local pos = self.TargetLocation or self:GetCurrentTargetPos()
                    proj:SetPosition(pos, true)
                    proj:OnImpact('Terrain', nil)

                    launcher:RemoveNukeSiloAmmo(1)

                    ChangeState(self, self.RackSalvoReloadState)
                    self:RemoveChargeEffects()
                    self._DischargeThread = self:ForkThread(self.DisChargeThread, bp.RackSalvoChargeTime * 3)
                end,
            },
            -- This state is entered only when the owner of the weapon is dead
            DeadState = State(SIFExperimentalStrategicMissile.DeadState) {
                Main = function(self)
                    self:RemoveChargeEffects()
                    if self._DischargeThread then
                        self._DischargeThread:Destroy()
                    end
                    self.Effects:Destroy()
                end,
            },

        },
    },
}


TypeClass = UEB1901
