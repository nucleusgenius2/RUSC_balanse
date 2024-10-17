--****************************************************************************
--**
--**  File     :  /Mods/ExpWars/units/UALEW0004/UALEW0004_script.lua
--**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
--**
--**  Summary  :  saispas Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local TWeapons = import('/lua/terranweapons.lua')

local TDFPlasmaCannonWeapon = TWeapons.TDFPlasmaCannonWeapon
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon

local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')


UALEW0003 = Class(AWalkingLandUnit) {
    SwitchAnims = true,
    Walking = true,
    IsWaiting = false,
    Weapons = {
        HeavyGun01 = Class(TDFPlasmaCannonWeapon) {},
        HeavyGun02 = Class(TDFPlasmaCannonWeapon) {},
        HeavyGun03 = Class(TDFPlasmaCannonWeapon) {},
        -- LightGun01 = Class(ADFLaserHighIntensityWeapon) {},
        -- LightGun02 = Class(ADFLaserHighIntensityWeapon) {},
    },

    OnMotionHorzEventChange = function(self, new, old)
        AWalkingLandUnit.OnMotionHorzEventChange(self, new, old)

        if (old == 'Stopped') then
            self.Trash:Add(CreateRotator(self, 'Roue01', 'x', nil, 80, 0, 60))
            self.Trash:Add(CreateRotator(self, 'Roue02', 'x', nil, 80, 0, 60))
        elseif (new == 'Stopped') then
            self.Trash:Add(CreateRotator(self, 'Roue01', 'x', nil, -80, 0, -60))
            self.Trash:Add(CreateRotator(self, 'Roue02', 'x', nil, -80, 0, -60))
        end
    end,


}

TypeClass = UALEW0003
