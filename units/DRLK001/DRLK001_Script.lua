-----------------------------------
-- Author(s):  Mikko Tyster
-- Summary  :  Cybran T3 Mobile AA
-- Copyright © 2008 Blade Braver!
-----------------------------------
local CWalkingLandUnit = import("/lua/cybranunits.lua").CWalkingLandUnit
local CybranWeaponsFile = import("/lua/cybranweapons.lua")
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local TargetingLaser = import("/lua/kirvesweapons.lua").TargetingLaser
local Effects = import("/lua/effecttemplates.lua")

---@class DRLK001 : CWalkingLandUnit
DRLK001 = ClassUnit(CWalkingLandUnit) {
    Weapons = {
        TargetPainter = ClassWeapon(TargetingLaser) {
            FxMuzzleFlash = { '/effects/emitters/particle_cannon_muzzle_02_emit.bp' },
        },

        AAGun = ClassWeapon(CAANanoDartWeapon) {},
    },
}
TypeClass = DRLK001
