-----------------------------------------------------------------
-- File     :  /cdimage/units/BEA0402/BEA0402_script.lua
-- Author(s):  John Comes, David Tomandl, Gordon Duclos
-- Summary  :  UEF Mobile Factory Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFHiroPlasmaCannon = WeaponsFile.TDFHiroPlasmaCannon
local TAAFlakArtilleryCannon = WeaponsFile.TAAFlakArtilleryCannon
local RailGunWeapon02 = import('/lua/BlackOpsWeapons.lua').RailGunWeapon02
local CitadelHVMWeapon = import('/lua/BlackOpsWeapons.lua').CitadelHVMWeapon
local CitadelPlasmaGatlingCannonWeapon = import('/lua/BlackOpsWeapons.lua').CitadelPlasmaGatlingCannonWeapon
local TIFCruiseMissileUnpackingLauncher = WeaponsFile.TIFCruiseMissileUnpackingLauncher
local TIFCruiseMissileLauncher = WeaponsFile.TIFCruiseMissileLauncher
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')


local MissileLauncher = Class(TIFCruiseMissileUnpackingLauncher)
{
    -- FxMuzzleFlash = { '/effects/emitters/terran_mobile_missile_launch_01_emit.bp' },

    -- OnLostTarget = function(self)
    --     self:ForkThread(self.LostTargetThread)
    -- end,

    -- RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
    --     OnLostTarget = function(self)
    --         self:ForkThread(self.LostTargetThread)
    --     end,
    -- },

    -- LostTargetThread = function(self)
    --     while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
    --         WaitSeconds(2)
    --     end

    --     if self.unit:IsDead() then
    --         return
    --     end

    --     local bp = self:GetBlueprint()

    --     if bp.WeaponUnpacks then
    --         ChangeState(self, self.WeaponPackingState)
    --     else
    --         ChangeState(self, self.IdleState)
    --     end
    -- end,
}

local MissileWeaponsNames = {
    "MissileWeapon1",
    "MissileWeapon2",
    "MissileWeapon3",
    "MissileWeapon4",
    "MissileWeapon5",
    "MissileWeapon6",
    "MissileWeapon7",
    "MissileWeapon8",
}

---@class BEA0402:TAirUnit
BEA0402 = Class(TAirUnit) {
    Weapons = {
        MainTurret01 = Class(TDFHiroPlasmaCannon) {},
        MainTurret02 = Class(TDFHiroPlasmaCannon) {},
        HVMTurret01 = Class(CitadelHVMWeapon) {},
        HVMTurret02 = Class(CitadelHVMWeapon) {},
        HVMTurret03 = Class(CitadelHVMWeapon) {},
        HVMTurret04 = Class(CitadelHVMWeapon) {},
        AAAFlak01 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak02 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak03 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak04 = Class(TAAFlakArtilleryCannon) {},
        GattlerTurret01 = Class(CitadelPlasmaGatlingCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(),
                    Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_2', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(),
                    Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,
        },

        GattlerTurret02 = Class(CitadelPlasmaGatlingCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(),
                    Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_1', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(),
                    Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,
        },
        TacNukeMissile = ClassWeapon(TIFCruiseMissileLauncher) {},

        MissileWeapon1 = ClassWeapon(MissileLauncher) {},
        MissileWeapon2 = ClassWeapon(MissileLauncher) {},
        MissileWeapon3 = ClassWeapon(MissileLauncher) {},
        MissileWeapon4 = ClassWeapon(MissileLauncher) {},
        MissileWeapon5 = ClassWeapon(MissileLauncher) {},
        MissileWeapon6 = ClassWeapon(MissileLauncher) {},
        MissileWeapon7 = ClassWeapon(MissileLauncher) {},
        MissileWeapon8 = ClassWeapon(MissileLauncher) {},
    },

    DestroyNoFallRandomChance = 1.1,
    FxDamageScale = 2.5,

    OnStopBeingBuilt = function(self, builder, layer)
        self.AirPadTable = {}
        TAirUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetModePrecisionMode(false)
    end,


    ---@param self BEA0402
    ---@param fn fun(weapon:Weapon)
    ApplyToMissleWeapons = function(self, fn)
        for _, key in MissileWeaponsNames do
            fn(self:GetWeaponByLabel(key))
        end
    end,

    ---@param self BEA0402
    SetModePrecisionMode = function(self, precision)
        self:SetWeaponEnabledByLabel("MainTurret01", precision)
        self:SetWeaponEnabledByLabel("MainTurret02", precision)

        if precision then
            self.TargetScatterRange = 7
            self:ApplyToMissleWeapons(function (weapon)
                weapon:ChangeMaxRadius(90)
                weapon:ChangeRateOfFire(0.5)
            end)
        else
            self.TargetScatterRange = 10
            self:ApplyToMissleWeapons(function (weapon)
                weapon:ChangeMaxRadius(48)
                weapon:ChangeRateOfFire(1)
            end)
        end
    end,


    OnScriptBitSet = function(self, bit)
        TAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then -- on
            self:SetModePrecisionMode(true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then -- off
            self:SetModePrecisionMode(false)
        end
    end,
}

TypeClass = BEA0402
