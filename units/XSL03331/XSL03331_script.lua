-- #****************************************************************************
-- #**
-- #**  File     :  /units/XSLconcept/XSLconcept_script.lua
-- #**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
-- #**
-- #**  Summary  :  Seraphim Concept Script
-- #**
-- #**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
-- #****************************************************************************
local CommandUnit = import("/lua/defaultunits.lua").CommandUnit
local SWeapons = import("/lua/seraphimweapons.lua")
local Buff = import("/lua/sim/buff.lua")
local SDFHeavyQuarnonCannon = SWeapons.SDFHeavyQuarnonCannon
local SCUDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
local EffectUtil = import("/lua/effectutilities.lua")
local EffectTemplate = import('/lua/EffectTemplates.lua')
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher
--local SDFChronotronOverChargeCannonWeapon = SWeapons.SDFChronotronCannonOverChargeWeapon
local SAAOlarisCannonWeapon = import("/lua/seraphimweapons.lua").SAAOlarisCannonWeapon


XSL03331 = Class( CommandUnit ) {
	Weapons = {
    --    OverCharge = ClassWeapon(SDFChronotronOverChargeCannonWeapon) {},
    --    AutoOverCharge = ClassWeapon(SDFChronotronOverChargeCannonWeapon) {},
        AAFizz = ClassWeapon(SAAOlarisCannonWeapon) {},
        Electrobolter01 = ClassWeapon(SDFHeavyQuarnonCannon) {
        	OnCreate = function(self)
              SDFHeavyQuarnonCannon.OnCreate(self)
            	if not self.SpinManip then 
					self.SpinManip = CreateRotator(self.unit, 'Electrobolter', 'x', nil, 250, 250, 250)
					self.unit.Trash:Add(self.SpinManip)
					self.unit:HideBone('Electrobolter', true)
            	end
            end,
		},
        Missile = ClassWeapon(SIFLaanseTacticalMissileLauncher) {
            OnCreate = function(self)
                SIFLaanseTacticalMissileLauncher.OnCreate(self)
                self:SetWeaponEnabled(false)
            end,
        },
        DeathWeapon = ClassWeapon(SCUDeathWeapon) {},
	},

    __init = function(self)
        CommandUnit.__init(self, 'Electrobolter01')
    end,

    ---@param self UEL0301
    ---@param bone Bone
    ---@param attachee Unit
    OnTransportAttach = function(self, bone, attachee)
        CommandUnit.OnTransportAttach(self, bone, attachee)
        attachee:SetDoNotTarget(true)
    end,

    ---@param self UEL0301
    ---@param bone Bone
    ---@param attachee Unit
    OnTransportDetach = function(self, bone, attachee)
        CommandUnit.OnTransportDetach(self, bone, attachee)
        attachee:SetDoNotTarget(false)
    end,

    ---@param self Unit
    OnCreate = function(self)
        CommandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()
        self.Rotator1 = CreateRotator(self, 'SpinMultiGun', 'z', nil, 200, 200, 200)
        self.Trash:Add(self.Rotator1)
		self.SpinManip = CreateRotator(self, 'TurnPoint', 'y', nil, 40, 40, 40)
		self.Trash:Add(self.SpinManip)
        self:ShowBone('Electrobolter', true)
		-- allow this unit to teleport
        self:AddCommandCap('RULEUCC_Teleport')
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
        CommandUnit.StartBeingBuiltEffects(self, builder, layer)
        self.Trash:Add(ForkThread(EffectUtil.CreateSeraphimBuildThread, self, builder, self.OnBeingBuiltEffectsBag, 2))
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects(self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		CommandUnit.OnStopBeingBuilt(self,builder,layer)
        self:AddBuildRestriction(categories.GALAXY3)
		self:CreatTheEffects()
	end,

	CreatTheEffects = function(self)
		local army =  self:GetArmy()
		for k, v in EffectTemplate['OthuyAmbientEmanation'] do
			CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(0.08)
		end
		for k, v in EffectTemplate['OthuyAmbientEmanation'] do
			CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.08)
		end
		for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
			CreateAttachedEmitter(self, 'eff03', army, v):ScaleEmitter(0.28)
		end
	end,

	OnKilled = function(self, instigator, damagetype, overkillRatio)
		CommandUnit.OnKilled(self, instigator, damagetype, overkillRatio)
		self:CreatTheEffectsDeath()  
	end,

	CreatTheEffectsDeath = function(self)
		local army =  self:GetArmy()
		for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
			self.Trash:Add(CreateAttachedEmitter(self, 'BRPT1BTBOT', army, v):ScaleEmitter(2.3))
		end
	end,

    CreateEnhancement = function(self, enh)
        CommandUnit.CreateEnhancement(self, enh)
		
        local bp = self.Blueprint.Enhancements[enh]
		
        if not bp then return end
            -- Missile
        if enh == 'Missile' then
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('Missile', true)
        elseif enh == 'MissileRemove' then
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('Missile', false)
            --Blast Attack
        elseif enh == 'BlastAttack' then
            local wep = self:GetWeaponByLabel('Electrobolter01')
            wep:ChangeMaxRadius(bp.NewMaxRadius or 35)
            wep:AddDamageMod(bp.AdditionalDamage or 5)
            wep:AddDamageRadiusMod(bp.NewDamageRadius or 5)
        --    local wep1 = self:GetWeaponByLabel('OverCharge')
        --    wep1:ChangeMaxRadius(bp.NewMaxRadius or 35)
        --    wep1:AddDamageMod(bp.AdditionalDamage or 5)
        --    wep1:AddDamageRadiusMod(bp.NewDamageRadius or 5)
        --    local wep2 = self:GetWeaponByLabel('AutoOverCharge')
        --    wep2:ChangeMaxRadius(bp.NewMaxRadius or 35)
        --    wep2:AddDamageMod(bp.AdditionalDamage or 5)
        --    wep2:AddDamageRadiusMod(bp.NewDamageRadius or 5)
        elseif enh == 'BlastAttackRemove' then
            local wep = self:GetWeaponByLabel('Electrobolter01')
        --    local wep1 = self:GetWeaponByLabel('OverCharge')
        --    local wep2 = self:GetWeaponByLabel('AutoOverCharge')
            wep:ChangeMaxRadius(bp.NewMaxRadius or 25)
        --    wep1:ChangeMaxRadius(bp.NewMaxRadius or 25)
        --    wep2:ChangeMaxRadius(bp.NewMaxRadius or 25)
            wep:AddDamageMod(-self.Blueprint.Enhancements['BlastAttack'].AdditionalDamage)
            wep:AddDamageRadiusMod(-self.Blueprint.Enhancements['BlastAttack'].NewDamageRadius) -- unlimited AOE bug fix by brute51 [117]			--self:SetWeaponEnabledByLabel('Electrobolter01', false)
            -- Enhanced EngineeringThroughput
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

TypeClass = XSL03331