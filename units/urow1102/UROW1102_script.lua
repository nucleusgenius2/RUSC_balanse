--****************************************************************************
--**
--**  File     :  /cdimage/units/URO1101/URO1101_script.lua
--**  Author(s):  David Tomandl, Jessica St. Croix
--**					Modified By Asdrubaelvect
--**  Summary  :  Cybran Anti Spaceships Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local CDFHeavyElectronBolter01Weapon = import('/lua/modweapons.lua').CDFHeavyElectronBolter01Weapon
local CDFRocketIridiumWeapon = import("/lua/cybranweapons.lua").CDFRocketIridiumWeapon

local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

local LateralGaucheGun = Class(CDFRocketIridiumWeapon) {
    FxMuzzleFlash = { '/effects/emitters/particle_cannon_muzzle_02_emit.bp' },
}

UROW1102 = Class(CAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        LateralGaucheGun01 = LateralGaucheGun,
        LateralGaucheGun02 = LateralGaucheGun,
        LateralGaucheGun03 = LateralGaucheGun,
        LateralGaucheGun04 = LateralGaucheGun,
        LateralDroitGun06 = LateralGaucheGun,
        LateralDroitGun07 = LateralGaucheGun,
        LateralDroitGun08 = LateralGaucheGun,

        Missile01 = Class(CAAMissileNaniteWeapon) {},
        Missile02 = Class(CAAMissileNaniteWeapon) {},
        Missile03 = Class(CAAMissileNaniteWeapon) {},
    },


    MovementAmbientExhaustBones = {
        'Reacteur02',
        'Reacteur01',
    },

    OnMotionHorzEventChange = function(self, new, old)
        CAirUnit.OnMotionHorzEventChange(self, new, old)

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
                '/effects/emitters/missile_cruise_munition_trail_01_emit.bp',
                --'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',
            }
            local ExhaustBeam = '/effects/emitters/cybran_missile_exhaust_fire_beam_13_emit.bp'
            local army = self:GetArmy()

            for kE, vE in ExhaustEffects do
                for kB, vB in self.MovementAmbientExhaustBones do
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE))
                    table.insert(self.MovementAmbientExhaustEffectsBag,
                        CreateBeamEmitterOnEntity(self, vB, army, ExhaustBeam))
                end
            end

            WaitSeconds(5)
            fxutil.CleanupEffectBag(self, 'MovementAmbientExhaustEffectsBag')
        end
    end,
}

TypeClass = UROW1102
