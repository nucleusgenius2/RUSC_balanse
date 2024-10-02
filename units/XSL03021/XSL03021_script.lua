local CommandUnit = import("/lua/defaultunits.lua").CommandUnit
local SWeapons = import("/lua/seraphimweapons.lua")
local Buff = import("/lua/sim/buff.lua")
local SCUDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
local EffectUtil = import("/lua/effectutilities.lua")
local SDFLightChronotronCannonWeapon = SWeapons.SDFLightChronotronCannonWeapon
local SDFOverChargeWeapon = SWeapons.SDFLightChronotronCannonOverchargeWeapon
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher

---@class XSL03021 : CommandUnit
XSL03021 = ClassUnit(CommandUnit) {
    Weapons = {
        LightChronatronCannon = ClassWeapon(SDFLightChronotronCannonWeapon) {
            OnCreate = function(self)
                SDFLightChronotronCannonWeapon.OnCreate(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Electrobolter', 'x', nil, 100, 100, 100)
                    self.unit.Trash:Add(self.SpinManip)
                end
            end,
        },
        DeathWeapon = ClassWeapon(SCUDeathWeapon) {},
    },

    __init = function(self)
        CommandUnit.__init(self, 'LightChronatronCannon')
    end,

    OnCreate = function(self)
        CommandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()
        self:AddCommandCap('RULEUCC_Teleport')
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
        CommandUnit.StartBeingBuiltEffects(self, builder, layer)
        self.Trash:Add(ForkThread(EffectUtil.CreateSeraphimBuildThread, self, builder, self.OnBeingBuiltEffectsBag, 2))
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects(self, unitBeingBuilt, self.BuildEffectBones,
            self.BuildEffectsBag)
    end,

    CreateEnhancement = function(self, enh)
        CommandUnit.CreateEnhancement(self, enh)
        local bp = self.Blueprint.Enhancements[enh]
        if not bp then return end
        -- Teleporter
        if enh == 'Teleporter' then
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
            -- Advanced Teleporter
        elseif enh == 'AdvancedTeleporterRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
            -- Shields
        elseif enh == 'Shield' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:CreateShield(bp)
        elseif enh == 'ShieldRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            -- Engineering Throughput Upgrade
        elseif enh == 'EngineeringThroughput' then
            if not Buffs['SeraphimSCUBuildRate'] then
                BuffBlueprint {
                    Name = 'SeraphimSCUBuildRate',
                    DisplayName = 'SeraphimSCUBuildRate',
                    BuffType = 'SCUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add = bp.NewBuildRate - self.Blueprint.Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'SeraphimSCUBuildRate')
        elseif enh == 'EngineeringThroughputRemove' then
            if Buff.HasBuff(self, 'SeraphimSCUBuildRate') then
                Buff.RemoveBuff(self, 'SeraphimSCUBuildRate')
            end
            -- Damage Stabilization
        elseif enh == 'DamageStabilization' then
            if not Buffs['SeraphimSCUDamageStabilization'] then
                BuffBlueprint {
                    Name = 'SeraphimSCUDamageStabilization',
                    DisplayName = 'SeraphimSCUDamageStabilization',
                    BuffType = 'SCUUPGRADEDMG',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            if Buff.HasBuff(self, 'SeraphimSCUDamageStabilization') then
                Buff.RemoveBuff(self, 'SeraphimSCUDamageStabilization')
            end
            Buff.ApplyBuff(self, 'SeraphimSCUDamageStabilization')
        elseif enh == 'DamageStabilizationRemove' then
            if Buff.HasBuff(self, 'SeraphimSCUDamageStabilization') then
                Buff.RemoveBuff(self, 'SeraphimSCUDamageStabilization')
            end
            -- Enhanced Sensor Systems
        elseif enh == 'EnhancedSensors' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 104)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 104)
        elseif enh == 'EnhancedSensorsRemove' then
            local bpIntel = self.Blueprint.Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 16)
        end
    end,
}

TypeClass = XSL03021
