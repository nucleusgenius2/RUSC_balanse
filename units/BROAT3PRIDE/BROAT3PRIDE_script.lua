--****************************************************************************
--**
--**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Aeon Gunship Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local AeonWeapons = import('/lua/aeonweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TMWeaponsFile = import('/lua/BattlePackweapons.lua')
local TMAnovacatgreenlaserweapon = TMWeaponsFile.TMAnovacatgreenlaserweapon
local TMAnovacatbluelaserweapon = TMWeaponsFile.TMAnovacatbluelaserweapon
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local explosion = import('/lua/defaultexplosions.lua')
local AAATemporalFizzWeapon = AeonWeapons.AAATemporalFizzWeapon


BROAT3PRIDE = Class(AAirUnit) {
    Weapons = {
        laserblue = Class(TMAnovacatbluelaserweapon) {},
        lasergreen = Class(TMAnovacatgreenlaserweapon) {
            FxMuzzleFlash = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
            FxMuzzleFlashScale = 2.8,
        },
        lasergreen2 = Class(TMAnovacatgreenlaserweapon) {},
        lasergreen3 = Class(TMAnovacatgreenlaserweapon) {},
        lasergreen4 = Class(TMAnovacatgreenlaserweapon) {},
        lasergreen5 = Class(TMAnovacatgreenlaserweapon) {},
        autoattack = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.0,
        },
        bigGun = Class(TDFGaussCannonWeapon) {},
        SonicPulseBattery1 = ClassWeapon(AAAZealotMissileWeapon) {},
        SonicPulseBattery2 = ClassWeapon(AAAZealotMissileWeapon) {},
        SonicPulseBattery3 = ClassWeapon(AAAZealotMissileWeapon) {},
        SonicPulseBattery4 = ClassWeapon(AAAZealotMissileWeapon) {},
    },

    MovementAmbientExhaustBones = {
        'ex01', 'ex02', 'ex03', 'ex04', 'ex05', 'ex06', 'ex07', 'ex08',
    },

    DestructionPartsChassisToss = { 'BROAT3PRIDE', },
    DestroyNoFallRandomChance = 1.1,

    OnStopBeingBuilt = function(self, builder, layer)
        AAirUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Object12', 'y', nil, -20, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Cylinder02', 'y', nil, 20, 0, 0))
        self:CreatTheEffects()
        if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
            self:SetWeaponEnabledByLabel('autoattack', false)
        else
            self:SetWeaponEnabledByLabel('autoattack', true)
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        AAirUnit.OnMotionHorzEventChange(self, new, old)
        if self.ThrustExhaustTT1 == nil then
            if self.MovementAmbientExhaustEffectsBag then
                fxutil.CleanupEffectBag(self, 'MovementAmbientExhaustEffectsBag')
            else
                self.MovementAmbientExhaustEffectsBag = {}
            end
            self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
        end
        if new == 'Stopped' and self.ThrustExhaustTT1 ~= nil then
            KillThread(self.ThrustExhaustTT1)
            fxutil.CleanupEffectBag(self, 'MovementAmbientExhaustEffectsBag')
            self.ThrustExhaustTT1 = nil
        end
    end,

    MovementAmbientExhaustThread = function(self)
        while not self.Dead do
            local ExhaustEffects = {
                '/effects/emitters/dirty_exhaust_smoke_01_emit.bp',
                '/effects/emitters/dirty_exhaust_sparks_01_emit.bp',
            }
            local ExhaustBeam = '/effects/emitters/missile_exhaust_fire_beam_03_emit.bp'
            local army = self:GetArmy()

            for kE, vE in ExhaustEffects do
                for kB, vB in self.MovementAmbientExhaustBones do
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE))
                    table.insert(self.MovementAmbientExhaustEffectsBag,
                        CreateBeamEmitterOnEntity(self, vB, army, ExhaustBeam))
                end
            end

            WaitSeconds(2)
            fxutil.CleanupEffectBag(self, 'MovementAmbientExhaustEffectsBag')

            WaitSeconds(util.GetRandomFloat(1, 7))
        end
    end,

    CreatTheEffects = function(self)
        local army = self:GetArmy()
        for k, v in EffectTemplate['GenericTeleportCharge01'] do
            self.Trash:Add(CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(4.35))
        end
        for k, v in EffectTemplate['GenericTeleportCharge01'] do
            self.Trash:Add(CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(4.35))
        end
    end,

    CreatTheEffectsDeath = function(self)
        local army = self:GetArmy()
        for k, v in TMEffectTemplate['AeonBattleShipHit01'] do
            self.Trash:Add(CreateAttachedEmitter(self, 'BROAT3PRIDE', army, v):ScaleEmitter(8.65))
        end
    end,

    OnDestroy = function(self)
        AAirUnit.OnDestroy(self)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    DeathThread = function(self, overkillRatio, instigator)

        --    self:CreateProjectileAtBone('/effects/entities/InqDeathEffectController01/InqDeathEffectController01_proj.bp', 'Cylinder02'):SetCollision(false)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Cylinder02', 5.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), { self:GetUnitSizes() })
        WaitSeconds(0.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Cylinder02', 1.0)
        WaitSeconds(0.01)


        explosion.CreateDefaultHitExplosionAtBone(self, 'Cylinder02', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:CreateProjectileAtBone('/effects/entities/InqDeathEffectController01/InqDeathEffectController01_proj.bp',
            'Cylinder02'):SetCollision(false)

        local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if (bp.Weapon[i].Label == 'DeathImpact') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage,
                    bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if (self.ShowUnitDestructionDebris and overkillRatio) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris(self, true, true, true)
            else
                self.CreateUnitDestructionDebris(self, true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

}
TypeClass = BROAT3PRIDE
