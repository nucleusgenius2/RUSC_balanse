local Buff = import("/lua/sim/buff.lua")

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CWeapons = import('/lua/cybranweapons.lua')

local CDFHvyProtonCannonWeapon = CybranWeaponsFile.CDFHvyProtonCannonWeapon
local CDFElectronBolterWeapon = CybranWeaponsFile.CDFElectronBolterWeapon
local CAAMissileNaniteWeapon = CybranWeaponsFile.CAAMissileNaniteWeapon
local SCUDeathWeapon = import('/lua/sim/defaultweapons.lua').SCUDeathWeapon
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon
local CDFHeavyMicrowaveLaserGenerator = CybranWeaponsFile.CDFHeavyMicrowaveLaserGenerator
local AAMWillOWisp = import("/lua/aeonweapons.lua").AAMWillOWisp

local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

local Entity = import('/lua/sim/Entity.lua').Entity

local util = import('/lua/utilities.lua')
local utilities = import('/lua/Utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local EffectUtils = import('/lua/EffectUtilities.lua')
local ExhaustBeam = import('/lua/effecttemplates.lua')
local ExhaustEffects = import('/lua/effecttemplates.lua')
local CAABurstCloudFlakArtilleryWeapon = import("/lua/cybranweapons.lua").CAABurstCloudFlakArtilleryWeapon

local AIUtils = import('/lua/ai/aiutilities.lua')
local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local CAMZapperWeapon = import("/lua/cybranweapons.lua").CAMZapperWeapon
local satt = false

CDFMicrowaveLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.MicrowaveLaserCollisionBeam04,
    FxMuzzleFlash = {},
}
local CDFHeavyMicrowaveLaserGeneratorDefense = CDFMicrowaveLaserGenerator

URL4032 = Class(CWalkingLandUnit) {
    WalkingAnimRate = 5.75,

    Weapons = {
        MissileRack = Class(CAMEMPMissileWeapon) {
            IdleState = State(CAMEMPMissileWeapon.IdleState) {
                OnGotTarget = function(self)
                    local bp = self:GetBlueprint()
                    --only say we've fired if the parent fire conditions are met
                    if (
                        bp.WeaponUnpackLockMotion ~= true or
                            (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
                        if (bp.CountedProjectile == false) or self:CanFire() then
                            nukeFiredOnGotTarget = true
                        end
                    end
                    CAMEMPMissileWeapon.IdleState.OnGotTarget(self)
                end,
                -- uses OnGotTarget, so we shouldn't do this.
                OnFire = function(self)
                    if not nukeFiredOnGotTarget then
                        CAMEMPMissileWeapon.IdleState.OnFire(self)
                    end
                    nukeFiredOnGotTarget = false

                    self:ForkThread(function()
                        self.unit:SetBusy(true)
                        WaitSeconds(1 / self.unit:GetBlueprint().Weapon[1].RateOfFire + .2)
                        self.unit:SetBusy(false)
                    end)
                end,
            },
        },
        AntiNuke2 = Class(CAMEMPMissileWeapon) {},
        AAGun = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},
        AAGun1 = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},

        AAGun2 = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},
        AAGun3 = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},
        DeathWeapon = Class(SCUDeathWeapon) {},

        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorDefense) {},

        LaserTurretI = Class(CDFElectronBolterWeapon) {},
        LaserTurretII = Class(CDFElectronBolterWeapon) {},
        LaserTurretIII = Class(CDFElectronBolterWeapon) {},
        LaserTurretIV = Class(CDFElectronBolterWeapon) {},

        LaserTurretV = Class(CDFElectronBolterWeapon) {},
        LaserTurretVI = Class(CDFElectronBolterWeapon) {},
        LaserTurretVII = Class(CDFElectronBolterWeapon) {},
        LaserTurretVIII = Class(CDFElectronBolterWeapon) {},

        ParticleGun = Class(CDFHvyProtonCannonWeapon) {},
        AntiSatt = Class(CAMEMPMissileWeapon) {},
        Turret01 = ClassWeapon(CAMZapperWeapon) {},
        Turret02 = ClassWeapon(CAMZapperWeapon) {},
        Turret03 = ClassWeapon(CAMZapperWeapon) {},
        Turret04 = ClassWeapon(CAMZapperWeapon) {},
        --    Turret05 = ClassWeapon(CAMZapperWeapon) {},
    },


    OnStartBeingBuilt = function(self, builder, layer)
        CWalkingLandUnit.OnStartBeingBuilt(self, builder, layer)
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self:HideBone('Turret', true)
        self:HideBone('Turret11', true)
        self:HideBone('Turret_Barrel', true)
        self:HideBone('Turret_Barrel11', true)
        self:HideBone('Turret_Recoil01', true)
        self:HideBone('Turret_Recoil02', true)
        self:HideBone('Turret_Recoil0111', true)
        self:HideBone('URB2204', true)
        self:HideBone('URB220411', true)
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        CWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(0.7)
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration() * self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end
        self:SetMaintenanceConsumptionActive()
        local layer = self:GetCurrentLayer()
        self.WeaponsEnabled = true
        self:SetWeaponEnabledByLabel('AntiSatt', false)
        self:SetWeaponEnabledByLabel('AAGun', false)
        self:SetWeaponEnabledByLabel('AAGun1', false)
        self:SetWeaponEnabledByLabel('AAGun2', false)
        self:SetWeaponEnabledByLabel('AAGun3', false)
        self:ForkThread(self.ChangeLayer)
        self:HideBone('Turret', true)
        self:HideBone('Turret11', true)
        self:HideBone('Turret_Barrel', true)
        self:HideBone('Turret_Barrel11', true)
        self:HideBone('Turret_Recoil01', true)
        self:HideBone('Turret_Recoil02', true)
        self:HideBone('Turret_Recoil0111', true)
        self:HideBone('URB2204', true)
        self:HideBone('URB220411', true)
    end,

    AmbientLandExhaustEffects = {
        '/effects/emitters/dirty_exhaust_smoke_02_emit.bp',
        '/effects/emitters/dirty_exhaust_sparks_02_emit.bp',
    },

    AmbientSeabedExhaustEffects = {
        '/effects/emitters/underwater_vent_bubbles_02_emit.bp',
    },

    CreateUnitAmbientEffect = function(self, layer)
        if (self.AmbientEffectThread ~= nil) then
            self.AmbientEffectThread:Destroy()
        end
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self, 'AmbientExhaustEffectsBag')
        end

        self.AmbientEffectThread = nil
        self.AmbientExhaustEffectsBag = {}
        if layer == 'Land' then
            self.AmbientEffectThread = self:ForkThread(self.UnitLandAmbientEffectThread)
        elseif layer == 'Seabed' then
            local army = self:GetArmy()
            self:SetWeaponEnabledByLabel('AntiSatt', false)
            for kE, vE in self.AmbientSeabedExhaustEffects do
                for kB, vB in self.AmbientExhaustBones do
                    table.insert(self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE))
                end
            end
        end
    end,

    UnitLandAmbientEffectThread = function(self)
        while not self:IsDead() do
            local army = self:GetArmy()

            for kE, vE in self.AmbientLandExhaustEffects do
                for kB, vB in self.AmbientExhaustBones do
                    table.insert(self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE))
                end
            end

            WaitSeconds(2)
            EffectUtil.CleanupEffectBag(self, 'AmbientExhaustEffectsBag')

            WaitSeconds(utilities.GetRandomFloat(1, 7))
        end
    end,

    CreateEnhancement = function(self, enh)
        CWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self.Blueprint.Enhancements[enh]

        if enh == 'MicrowaveLaserGenerator' then
            self:SetWeaponEnabledByLabel('AntiSatt', true)
        elseif enh == 'MicrowaveLaserGeneratorRemove' then
            self:SetWeaponEnabledByLabel('AntiSatt', false)
        elseif enh == 'EnergyReflector' then
            if not Buffs['EnergyReflectorBonus'] then
                BuffBlueprint {
                    Name = 'EnergyReflectorBonus',
                    DisplayName = 'EnergyReflectorBonus',
                    BuffType = 'ENERGYREFLECTORBONUS',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                        },
                    },
                }
            end
            if not Buff.HasBuff(self, 'EnergyReflectorBonus') then
                Buff.ApplyBuff(self, 'EnergyReflectorBonus')
            end
            self.OCDamageMitigation = bp.OCDamageMitigation
        elseif enh == 'EnergyReflectorRemove' then
            if Buff.HasBuff(self, 'EnergyReflectorBonus') then
                Buff.RemoveBuff(self, 'EnergyReflectorBonus')
            end
            self.OCDamageMitigation = nil
        elseif enh == 'NaniteMissileSystem' then
            self:ShowBone('Turret', true)
            self:ShowBone('Turret11', true)
            self:ShowBone('Turret_Barrel', true)
            self:ShowBone('Turret_Barrel11', true)
            self:ShowBone('Turret_Recoil01', true)
            self:ShowBone('Turret_Recoil02', true)
            self:ShowBone('Turret_Recoil0111', true)
            self:ShowBone('URB2204', true)
            self:ShowBone('URB220411', true)
            self:SetWeaponEnabledByLabel('AAGun', true)
            self:SetWeaponEnabledByLabel('AAGun1', true)
            self:SetWeaponEnabledByLabel('AAGun2', true)
            self:SetWeaponEnabledByLabel('AAGun3', true)
        elseif enh == 'NaniteMissileSystemRemove' then
            self:HideBone('Turret', true)
            self:HideBone('Turret11', true)
            self:HideBone('Turret_Barrel', true)
            self:HideBone('Turret_Barrel11', true)
            self:HideBone('Turret_Recoil01', true)
            self:HideBone('Turret_Recoil02', true)
            self:HideBone('Turret_Recoil0111', true)
            self:HideBone('URB2204', true)
            self:HideBone('URB220411', true)
            self:SetWeaponEnabledByLabel('AAGun', false)
            self:SetWeaponEnabledByLabel('AAGun1', false)
            self:SetWeaponEnabledByLabel('AAGun2', false)
            self:SetWeaponEnabledByLabel('AAGun3', false)
        end

    end,

    ChangeLayer = function(self)
        while not self.Dead do
            local layer = self:GetCurrentLayer()
            if layer == 'Land' then
                if self:HasEnhancement('MicrowaveLaserGenerator') then
                    self:SetWeaponEnabledByLabel('AntiSatt', true)
                end
                if self:HasEnhancement('NaniteMissileSystem') then
                    self:SetWeaponEnabledByLabel('AAGun', true)
                end
                self:SetWeaponEnabledByLabel('AntiNuke2', true)
            else
                self:SetWeaponEnabledByLabel('AntiSatt', false)
                self:SetWeaponEnabledByLabel('AntiNuke2', false)
                self:SetWeaponEnabledByLabel('AAGun', false)
            end
            WaitTicks(31)
        end
    end,

}

TypeClass = URL4032
