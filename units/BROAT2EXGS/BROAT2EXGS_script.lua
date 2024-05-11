-- #****************************************************************************
-- #**
-- #**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
-- #**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- #**
-- #**  Summary  :  Aeon Gunship Script
-- #**
-- #**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- #****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local AeonWeapons = import('/lua/aeonweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ADFQuantumAutogunWeapon = AeonWeapons.ADFQuantumAutogunWeapon
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon
local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

BROAT2EXGS = Class(AAirUnit) {
    Weapons = {
        autoattack = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.0,
        },
        MainGun1 = Class(ADFQuantumAutogunWeapon) {},
        MainGun2 = Class(ADFQuantumAutogunWeapon) {},
        MainGun3 = Class(ADFQuantumAutogunWeapon) {},
        MainGun4 = Class(ADFQuantumAutogunWeapon) {},
        AntiAirMissiles01 = Class(AAAZealotMissileWeapon) {},
        bigGun = Class(TDFGaussCannonWeapon) {

        }
    },

    MovementAmbientExhaustBones = {
        'ex01',
        'ex02',
    },

    DestructionPartsChassisToss = { 'BROAT2EXGS', },
    DestroyNoFallRandomChance = 1.1,


    OnStopBeingBuilt = function(self, builder, layer)
        AAirUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Object09', 'y', nil, -750, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Object10', 'y', nil, 750, 0, 0))

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
        while not self:IsDead() do
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

    OnDestroy = function(self)
        -- If we were destroyed without triggering OnKilled and our parent exists, notify that we just died
        if not self.IsDying and self.Parent then
            self.Parent:RemoveSatellite(self)
            IssueBuildFactory({ self.Parent }, 'BROAT2EXGS', 1)
            self.Parent = nil
        end

        AAirUnit.OnDestroy(self)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)

        --    if self.IsDying then
        --        return
        --    end

        --    self.IsDying = true

        -- If our parent exists, notify that we just died
        if self.Parent then
            self.Parent:RemoveSatellite(self)
            IssueBuildFactory({ self.Parent }, 'BROAT2EXGS', 1)
            self.Parent = nil
        end
        --	RemoveBuildRestriction(self:GetArmy(), categories[self:GetBlueprint().BlueprintId] )
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

TypeClass = BROAT2EXGS
