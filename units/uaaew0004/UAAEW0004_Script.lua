--[[#######################################################################
#  File	 :  /units/UAAEW0004/UAAEW0004_script.lua
#  Author(s):  John Comes, David Tomandl
#  Summary  :  Aeon Tech 2 Experimental Bomber
#  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#######################################################################]]--

local AWalkingLandUnit = import("/lua/aeonunits.lua").AWalkingLandUnit
local aWeapons = import("/lua/aeonweapons.lua")
local AAAZealotMissileWeapon = aWeapons.AAAZealotMissileWeapon
local AAATemporalFizzWeapon = import("/lua/aeonweapons.lua").AAATemporalFizzWeapon


UAAEW0004 = Class(AWalkingLandUnit) {
    Weapons = {
		SonicPulseBattery1 = Class(AAAZealotMissileWeapon) {},
        SonicPulseBattery2 = Class(AAAZealotMissileWeapon) {},
        SonicPulseBattery3 = Class(AAAZealotMissileWeapon) {},
        SonicPulseBattery4 = Class(AAAZealotMissileWeapon) {},
        AAFizz = ClassWeapon(AAATemporalFizzWeapon) {
            ChargeEffectMuzzles = {'Turret_Right_Muzzle', 'Turret_Left_Muzzle'},

            PlayFxRackSalvoChargeSequence = function(self)
                AAATemporalFizzWeapon.PlayFxRackSalvoChargeSequence(self)
                CreateAttachedEmitter(self.unit, 'Turret_Right_Muzzle', self.unit.Army, '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
                CreateAttachedEmitter(self.unit, 'Turret_Left_Muzzle', self.unit.Army, '/effects/emitters/temporal_fizz_muzzle_charge_03_emit.bp')
            end,
        },
    },
}

TypeClass = UAAEW0004
