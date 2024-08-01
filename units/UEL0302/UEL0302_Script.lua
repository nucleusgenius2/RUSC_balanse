----------------------------------------------------------------------------
--
--  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
--  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--
--  Summary  :  BRN Scavenger Medium Tank
--
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
----------------------------------------------------------------------------
local CommandUnit = import("/lua/defaultunits.lua").CommandUnit
local EffectUtil = import("/lua/effectutilities.lua")
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local AWeaponsFile = import('/lua/aeonweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TIFCruiseMissileLauncher = import("/lua/terranweapons.lua").TIFCruiseMissileLauncher
local TSAMLauncher = WeaponsFile.TSAMLauncher
local ACruiseMissileWeapon = AWeaponsFile.ACruiseMissileWeapon
local SCUDeathWeapon = import('/lua/sim/defaultweapons.lua').SCUDeathWeapon
local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')
local TAMInterceptorWeapon = import('/lua/terranweapons.lua').TAMInterceptorWeapon
local CAMEMPMissileWeapon = import('/lua/cybranweapons.lua').CAMEMPMissileWeapon
local TAMPhalanxWeapon = import('/lua/terranweapons.lua').TAMPhalanxWeapon
local CAABurstCloudFlakArtilleryWeapon = import("/lua/cybranweapons.lua").CAABurstCloudFlakArtilleryWeapon
local Buff = import("/lua/sim/buff.lua")

UEL0302 = Class(CommandUnit) {
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
        rocket = Class(TIFCruiseMissileLauncher) {
            FxMuzzleFlash = EffectTemplate.TIFCruiseMissileLaunchBuilding,
        },

        DeathWeapon = Class(SCUDeathWeapon) {
        },

        trigun01 = Class(TDFGaussCannonWeapon) {
        },
        trigun02 = Class(TDFGaussCannonWeapon) {
        },
        trigun03 = Class(TDFGaussCannonWeapon) {
        },
        trigun04 = Class(TDFGaussCannonWeapon) {
        },
        sidegun01 = Class(TDFGaussCannonWeapon) {
        },
        sidegun02 = Class(TDFGaussCannonWeapon) {
        },
        sidegun03 = Class(TDFGaussCannonWeapon) {
        },
        sidegun04 = Class(TDFGaussCannonWeapon) {
        },
        sidegun05 = Class(TDFGaussCannonWeapon) {
        },
        sidegun06 = Class(TDFGaussCannonWeapon) {
        },
        sidegun07 = Class(TDFGaussCannonWeapon) {
        },
        sidegun08 = Class(TDFGaussCannonWeapon) {
        },
        autoattack = Class(TDFGaussCannonWeapon) {
        },
        AAGun = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},
        AAGun1 = ClassWeapon(CAABurstCloudFlakArtilleryWeapon) {},
        Turret01 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

        },
        Turret02 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

        },
    },

    OnStopBeingBuilt = function(self, builder, layer)
        CommandUnit.OnStopBeingBuilt(self, builder, layer)
        self:DisableUnitIntel('Enhancement', 'Jammer')
        self.SetAIAutoattackWeapon(self)
        self:ForkThread(self.ChangeLayer)
        self:HideBone('Object01', true)
        self:HideBone('Object23', true)
        self:HideBone('Object20', true)
        self:HideBone('Front_Turret99', true)
        self:HideBone('AntiSatellite', true)
        self:SetWeaponEnabledByLabel('AAGun', false)
        self:SetWeaponEnabledByLabel('AAGun', false)
        self:SetWeaponEnabledByLabel('MissileRack01', false)
        self:ForkThread(self.AuraThread)
    end,

    AuraThread = function(self)
        local bpAura = self.Blueprint.Aura

        local auraRadius = bpAura.AuraRadius or 52
        -- SACU Range
        local buffSACUrange = 'SACURange'
        if not Buffs[buffSACUrange] then
            BuffBlueprint {
                Name = buffSACUrange,
                DisplayName = buffSACUrange,
                BuffType = 'AURAFORALLUEFSACU',
                Stacks = 'REPLACE',
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    MaxRadius = {
                        Add = bpAura.RangeBuff,
                    }
                }
            }
        end

        local uefSacu = categories.SUBCOMMANDER * categories.UEF
        while not self.Dead do

            self:ApplyBuffToUnits(uefSacu, buffSACUrange, auraRadius)
            WaitTicks(51)
        end
    end,

    ---@param self UEL0302
    ---@param category EntityCategory
    ApplyBuffToUnits = function(self, category, buffName, buffRadius, allyType)
        allyType = allyType or "Ally"
        local brain = self.Brain
        local all = brain:GetUnitsAroundPoint(category, self:GetPosition(), buffRadius, allyType)
        local units = {}

        for _, u in all do
            if not u.Dead and not u:IsBeingBuilt() then
                table.insert(units, u)
            end
        end
        for _, unit in units do
            Buff.ApplyBuff(unit, buffName)
            unit:RequestRefreshUI()
        end
        return not table.empty(units)
    end,

    OnDetachedFromTransport = function(self, transport, bone)
        CommandUnit.OnDetachedFromTransport(self, transport, bone)
        self.SetAIAutoattackWeapon(self)
    end,

    SetAIAutoattackWeapon = function(self)
        if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
            self:SetWeaponEnabledByLabel('autoattack', false)
        else
            self:SetWeaponEnabledByLabel('autoattack', true)
        end
    end,

    OnKilled = function(self, instigator, damagetype, overkillRatio)
        CommandUnit.OnKilled(self, instigator, damagetype, overkillRatio)
    end,

    IntelEffects = {
        {
            Bones = {
                'BRNT3DOOMSDAY',
            },
            Scale = 0.5,
            Type = 'Jammer01',
        },
    },

    CreateEnhancement = function(self, enh)
        CommandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'RadarJammer' then
            self:SetIntelRadius('Jammer', bp.NewJammerRadius or 26)
            self.RadarJammerEnh = true
            self:EnableUnitIntel('Enhancement', 'Jammer')
            self:AddToggleCap('RULEUTC_JammingToggle')
        elseif enh == 'RadarJammerRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Jammer', 0)
            self:DisableUnitIntel('Enhancement', 'Jammer')
            self.RadarJammerEnh = false
            self:RemoveToggleCap('RULEUTC_JammingToggle')
        elseif enh == 'NaniteMissileSystem' then
            self:ShowBone('Object01', true)
            self:ShowBone('Object23', true)
            self:ShowBone('Object20', true)
            self:ShowBone('Front_Turret99', true)
            self:ShowBone('AntiSatellite', true)
            self:SetWeaponEnabledByLabel('AAGun', true)
            self:SetWeaponEnabledByLabel('AAGun1', true)
        elseif enh == 'NaniteMissileSystemRemove' then
            self:HideBone('Object01', true)
            self:HideBone('Object23', true)
            self:HideBone('Object20', true)
            self:HideBone('Front_Turret99', true)
            self:HideBone('AntiSatellite', true)
            self:SetWeaponEnabledByLabel('AAGun', false)
            self:SetWeaponEnabledByLabel('AAGun1', false)
        elseif enh == 'AdvancedOmniSensors' then
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 57)
        elseif enh == 'AdvancedOmniSensorsRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 47)
        end
    end,

    OnIntelEnabled = function(self, intel)
        CommandUnit.OnIntelEnabled(self, intel)
        if self.RadarJammerEnh and self:IsIntelEnabled('Jammer') then
            if self.IntelEffects then
                self.IntelEffectsBag = {}
                self:CreateTerrainTypeEffects(self.IntelEffects, 'FXIdle', self.Layer, nil, self.IntelEffectsBag)
            end
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['RadarJammer'].MaintenanceConsumptionPerSecondEnergy
                or 0)
            self:SetMaintenanceConsumptionActive()
        end
    end,

    OnIntelDisabled = function(self, intel)
        CommandUnit.OnIntelDisabled(self, intel)
        if self.RadarJammerEnh and not self:IsIntelEnabled('Jammer') then
            self:SetMaintenanceConsumptionInactive()
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self, 'IntelEffectsBag')
            end
        end
    end,

    ChangeLayer = function(self)
        while not self.Dead do
            local layer = self:GetCurrentLayer()
            if layer == 'Land' then
                self:SetWeaponEnabledByLabel('AntiNuke2', true)
            else
                self:SetWeaponEnabledByLabel('AntiNuke2', false)
            end
            WaitTicks(31)
        end
    end,
}

TypeClass = UEL0302
