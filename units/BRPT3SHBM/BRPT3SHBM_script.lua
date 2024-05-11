#****************************************************************************
#**
#**  File     :  /units/XSLconcept/XSLconcept_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Concept Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SANUallCavitationTorpedo = SeraphimWeapons.SANUallCavitationTorpedo
local SAAOlarisCannonWeapon = SeraphimWeapons.SAAOlarisCannonWeapon
local SDFAireauWeapon = SeraphimWeapons.SDFAireauWeapon
local SDFUltraChromaticBeamGenerator = SeraphimWeapons.SDFUltraChromaticBeamGenerator02
local SDFSinnuntheWeapon = SeraphimWeapons.SDFSinnuntheWeapon
local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')
local explosion = import("/lua/defaultexplosions.lua")
local SAMElectrumMissileDefense = import('/lua/seraphimweapons.lua').SAMElectrumMissileDefense

BRPT3SHBM = Class( SWalkingLandUnit ) {

    SpawnEffects = {
        '/effects/emitters/seraphim_othuy_spawn_01_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_02_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_03_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_04_emit.bp',
    },

    Weapons = {
        AntiMissile = Class(SAMElectrumMissileDefense) {},
        AntiMissile1 = Class(SAMElectrumMissileDefense) {},
        AntiMissile2 = Class(SAMElectrumMissileDefense) {},
        TorpedoFront = ClassWeapon(SANUallCavitationTorpedo) {},
        autoattack = Class(SAAOlarisCannonWeapon) {
            FxMuzzleFlashScale = 0.0, 
        },
        frontmg1 = Class(SDFAireauWeapon) {
        },
        topgun = ClassWeapon(SDFSinnuntheWeapon){
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                SDFSinnuntheWeapon.PlayFxMuzzleChargeSequence(self, muzzle)
            end,
        },
        aa1 = Class(SDFUltraChromaticBeamGenerator) {
            FxMuzzleFlashScale = 2.4,
        },
        aa2 = Class(SDFUltraChromaticBeamGenerator) {
            FxMuzzleFlashScale = 2.4,
        },
    },

    OnCreate = function(self)
        SWalkingLandUnit.OnCreate(self)

        -- allow this unit to teleport
        self:AddCommandCap('RULEUCC_Teleport')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
            self:SetWeaponEnabledByLabel('autoattack', false)
        else
            self:SetWeaponEnabledByLabel('autoattack', true)
        end  
    end,

    CreatTheEffectsDeath = function(self)
        local army =  self:GetArmy()
        for k, v in TMEffectTemplate['SerT3SHBMDeath'] do
            self.Trash:Add(CreateAttachedEmitter(self, 'Arm01', army, v):ScaleEmitter(2.8))
        end
    end,

    SpawnElectroStorm = function(self)
        local position = self:GetPosition()
        local spawnEffects = self.SpawnEffects

        -- Spawn the Energy Being
        local spiritUnit = CreateUnitHPR('XSL0402', self.Army, position[1], position[2], position[3], 0, 0, 0)
        -- Create effects for spawning of energy being
        for k, v in spawnEffects do
            CreateAttachedEmitter(spiritUnit, -1, self.Army, v)
        end
    end,

    OnReclaimed = function(self, entity)

        SWalkingLandUnit.OnReclaimed(self, entity)

        -- Spawn the Energy Being
        self:SpawnElectroStorm()
    end,
	
	DeathThread = function(self, overkillRatio , instigator)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if self.ShowUnitDestructionDebris and overkillRatio then
            if overkillRatio <= 1 then
                self:CreateUnitDestructionDebris(true, true, false)
            elseif overkillRatio <= 2 then
                self:CreateUnitDestructionDebris(true, true, false)
            elseif overkillRatio <= 3 then
                self:CreateUnitDestructionDebris(true, true, true)
            else -- Vaporized
                self:CreateUnitDestructionDebris(true, true, true)
            end
        end


        -- only spawn storm and do damage when the unit is finished building
        if self:GetFractionComplete() == 1 then
            self:SpawnElectroStorm()
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}
TypeClass = BRPT3SHBM