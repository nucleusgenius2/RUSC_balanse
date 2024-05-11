-- #****************************************************************************
-- #**
-- #**  File     :  /cdimage/units/uel03011/uel03011_script.lua
-- #**  Author(s):  Jessica St. Croix, Gordon Duclos
-- #**
-- #**  Summary  :  UEF Sub Commander Script
-- #**
-- #**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- #****************************************************************************
local Shield = import('/lua/shield.lua').Shield
local EffectUtil = import('/lua/EffectUtilities.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local SWeapons = import("/lua/seraphimweapons.lua")
local TerranWeaponFile = import("/lua/terranweapons.lua")
local TWeapons = import('/lua/terranweapons.lua')
local CWeapons = import("/lua/cybranweapons.lua")
local TDFHeavyPlasmaCannonWeapon = TWeapons.TDFHeavyPlasmaCannonWeapon
local SCUDeathWeapon = import('/lua/sim/defaultweapons.lua').SCUDeathWeapon
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher
local TDFIonizedPlasmaCannon = TerranWeaponFile.TDFIonizedPlasmaCannon
local CANTorpedoLauncherWeapon = CWeapons.CANTorpedoLauncherWeapon
local Buff = import('/lua/sim/Buff.lua')
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

uel03011 = Class(TWalkingLandUnit) {
    
    IntelEffects = {
		{
			Bones = {
				'Jetpack',
			},
			Scale = 0.5,
			Type = 'Jammer01',
		},
    },     

    Weapons = {
        RightHeavyPlasmaCannon = Class(TDFHeavyPlasmaCannonWeapon) {},
        DeathWeapon = Class(SCUDeathWeapon) {},
        Missile = ClassWeapon(SIFLaanseTacticalMissileLauncher) {
            OnCreate = function(self)
                SIFLaanseTacticalMissileLauncher.OnCreate(self)
                self:SetWeaponEnabled(false)
            end,
        },
        PlasmaCannon01 = ClassWeapon(TDFIonizedPlasmaCannon) {
            OnCreate = function(self)
                TDFIonizedPlasmaCannon.OnCreate(self)
				self:SetWeaponEnabled(false)
            end,
		},
        Torpedo = ClassWeapon(CANTorpedoLauncherWeapon) {},
        MissileRack01 = Class(TSAMLauncher) {
            OnCreate = function(self)
                TSAMLauncher.OnCreate(self)
                self:SetWeaponEnabled(false)
            end,
		},
    },

    ---@param self UEL0301
    ---@param bone Bone
    ---@param attachee Unit
    OnTransportAttach = function(self, bone, attachee)
        TWalkingLandUnit.OnTransportAttach(self, bone, attachee)
        attachee:SetDoNotTarget(true)
    end,

    ---@param self UEL0301
    ---@param bone Bone
    ---@param attachee Unit
    OnTransportDetach = function(self, bone, attachee)
        TWalkingLandUnit.OnTransportDetach(self, bone, attachee)
        attachee:SetDoNotTarget(false)
    end,

    OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:HideBone('Jetpack', true)
        self:HideBone('UEB2304', true)
        self:HideBone('Turret', true)
        self:HideBone('Turret_Barrel', true)
        self:HideBone('SAM', true)
        self:SetupBuildBones()
        
        local wepBp = self.Blueprint.Weapon
        self.torpRange = 60
        for k, v in wepBp do
            if v.Label == 'Torpedo' then
                self.torpRange = v.MaxRadius
            end
        end
    end,
    
    RebuildPod = function(self)
        if self.HasPod == true then
            self.RebuildingPod = CreateEconomyEvent(self, 1600, 160, 10, self.SetWorkProgress)
            self:RequestRefreshUI()
            WaitFor(self.RebuildingPod)
            self:SetWorkProgress(0.0)
            RemoveEconomyEvent(self, self.RebuildingPod)
            self.RebuildingPod = nil
            local location = self:GetPosition('AttachSpecial01')
            local pod = CreateUnitHPR('UEA0003', self.Army, location[1], location[2], location[3], 0, 0, 0)
            pod:SetParent(self, 'Pod')
            pod:SetCreator(self)
            self.Trash:Add(pod)
            self.Pod = pod
        end
    end,
	
    NotifyOfPodDeath = function(self, pod, rebuildDrone)
        if rebuildDrone == true then
            if self.HasPod == true then
                self.RebuildThread = self:ForkThread(self.RebuildPod)
            end
        else
            self:CreateEnhancement('PodRemove')
        end
    end,
	
    OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetWeaponEnabledByLabel('Torpedo', false)
        -- Block Jammer until Enhancement is built
        self:DisableUnitIntel('Enhancement', 'Jammer')
    end,

    OnPrepareArmToBuild = function(self)
        TWalkingLandUnit.OnPrepareArmToBuild(self)
        self:BuildManipulatorSetEnabled(true)
        self.BuildArmManipulator:SetPrecedence(20)
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', false)
        self.BuildArmManipulator:SetHeadingPitch( self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):GetHeadingPitch() )
    end,
    
    OnStopCapture = function(self, target)
        TWalkingLandUnit.OnStopCapture(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', true)
        self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,

    OnFailedCapture = function(self, target)
        TWalkingLandUnit.OnFailedCapture(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', true)
        self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
    
    OnStopReclaim = function(self, target)
        TWalkingLandUnit.OnStopReclaim(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', true)
        self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order)    
        TWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true        
    end,    

    OnStopBuild = function(self, unitBeingBuilt)
        TWalkingLandUnit.OnStopBuild(self, unitBeingBuilt)
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil
        self.BuildingUnit = false      
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', true)    
        self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,     
    
    OnFailedToBuild = function(self)
        TWalkingLandUnit.OnFailedToBuild(self)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon', true)
        self:GetWeaponManipulatorByLabel('RightHeavyPlasmaCannon'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        --# If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateUEFCommanderBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )   
        end           
    end,     

    NotifyOfPodDeath = function(self, pod)
        RemoveUnitEnhancement(self, 'Pod')
        self.Pod = nil
        self:RequestRefreshUI()
    end,

    OnIntelEnabled = function(self)
        TWalkingLandUnit.OnIntelEnabled(self)
        if self.RadarJammerEnh and self:IsIntelEnabled('Jammer') then 
            if self.IntelEffects then
		        self.IntelEffectsBag = {}
		        self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
	        end
	        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['RadarJammer'].MaintenanceConsumptionPerSecondEnergy or 0)        
            self:SetMaintenanceConsumptionActive()
        end    
    end,

    OnIntelDisabled = function(self)
        TWalkingLandUnit.OnIntelDisabled(self)
        if self.RadarJammerEnh and not self:IsIntelEnabled('Jammer') then
            self:SetMaintenanceConsumptionInactive()
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            end
        end       
    end,     
    
    OnPaused = function(self)
        TWalkingLandUnit.OnPaused(self)
        if self.BuildingUnit then
            TWalkingLandUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end    
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            TWalkingLandUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        TWalkingLandUnit.OnUnpaused(self)
    end,    
	
    CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        --RadarJammer
        if enh == 'RadarJammer' then
            self:SetIntelRadius('Jammer', bp.NewJammerRadius or 26)
            self.RadarJammerEnh = true 
			self:EnableUnitIntel('Jammer')
            self:AddToggleCap('RULEUTC_JammingToggle')
        elseif enh == 'RadarJammerRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Jammer', 0)
            self:DisableUnitIntel('Jammer')
            self.RadarJammerEnh = false
            self:RemoveToggleCap('RULEUTC_JammingToggle')
        --DamageStablization
        elseif enh =='DamageStablization' then
            self:SetRegenRate(bp.NewRegenRate)
            self.DamageStablization = true 
            if not Buffs['UEFACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildRate',
                    DisplayName = 'UEFACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT2BuildRate')	
        elseif enh =='DamageStablizationRemove' then
            self:RevertRegenRate()
            self.DamageStablization = false 
            if Buff.HasBuff( self, 'UEFACUT2BuildRate' ) then
                Buff.RemoveBuff( self, 'UEFACUT2BuildRate' )
            end
        elseif enh == 'Missile' then
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('Missile', true)
        elseif enh == 'MissileRemove' then
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('Missile', false)
        elseif enh == 'AAGun' then
            self:SetWeaponEnabledByLabel('MissileRack01', true)
        elseif enh == 'AAGunRemove' then
            self:SetWeaponEnabledByLabel('MissileRack01', false)
        elseif enh =='HighExplosiveOrdnance' then
            self:SetWeaponEnabledByLabel('PlasmaCannon01', true)
            local wep = self:GetWeaponByLabel('RightHeavyPlasmaCannon')
            wep:AddDamageRadiusMod(bp.NewDamageRadius)
            wep:ChangeMaxRadius(bp.NewMaxRadius or 35)
        elseif enh =='HighExplosiveOrdnanceRemove' then
            local wep = self:GetWeaponByLabel('RightHeavyPlasmaCannon')
            wep:AddDamageRadiusMod(bp.NewDamageRadius)
            wep:ChangeMaxRadius(bp.NewMaxRadius or 25)
            self:SetWeaponEnabledByLabel('PlasmaCannon01', false)
        elseif enh == 'Pod' then
            local location = self:GetPosition('AttachSpecial01')
            local pod = CreateUnitHPR('UEA0003', self.Army, location[1], location[2], location[3], 0, 0, 0)
            pod:SetParent(self, 'Pod')
            pod:SetCreator(self)
            self.Trash:Add(pod)
            self.HasPod = true
            self.Pod = pod
        elseif enh == 'PodRemove' then
            if self.HasPod == true then
                self.HasPod = false
                if self.Pod and not self.Pod:BeenDestroyed() then
                    self.Pod:Kill()
                    self.Pod = nil
                end
                if self.RebuildingPod ~= nil then
                    RemoveEconomyEvent(self, self.RebuildingPod)
                    self.RebuildingPod = nil
                end
            end
            KillThread(self.RebuildThread)
        elseif enh == 'NaniteTorpedoTube' then
            local enhbp = self.Blueprint.Enhancements[enh]
            self:SetWeaponEnabledByLabel('Torpedo', true)
            self:SetIntelRadius('Sonar', enhbp.NewSonarRadius or 60)
            self:EnableUnitIntel('Enhancement', 'Sonar')
            --if self.Layer == 'Seabed' then
            --    self:GetWeaponByLabel('DummyWeapon'):ChangeMaxRadius(self.torpRange)
            --end
        elseif enh == 'NaniteTorpedoTubeRemove' then
            local bpIntel = self.Blueprint.Intel
            self:SetWeaponEnabledByLabel('Torpedo', false)
            self:SetIntelRadius('Sonar', bpIntel.SonarRadius or 26)
            self:DisableUnitIntel('Enhancement', 'Sonar')
            --if self.Layer == 'Seabed' then
            --    self:GetWeaponByLabel('DummyWeapon'):ChangeMaxRadius(self.normalRange)
            --end
        elseif enh == 'SensorRangeEnhancer' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 104)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 104)
        elseif enh == 'SensorRangeEnhancerRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
        elseif enh == 'ShieldGeneratorField' then
            self:DestroyShield()
            self:ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
                self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
                self:SetMaintenanceConsumptionActive()
            end)
        elseif enh == 'ShieldGeneratorFieldRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
        end
    end,
	
    OnIntelEnabled = function(self, intel)
        TWalkingLandUnit.OnIntelEnabled(self, intel)
        if self.RadarJammerEnh and self:IsIntelEnabled('Jammer') then
            if self.IntelEffects then
                self.IntelEffectsBag = {}
                self:CreateTerrainTypeEffects(self.IntelEffects, 'FXIdle',  self.Layer, nil, self.IntelEffectsBag)
            end
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['RadarJammer'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
        end
    end,

    OnIntelDisabled = function(self, intel)
        TWalkingLandUnit.OnIntelDisabled(self, intel)
        if self.RadarJammerEnh and not self:IsIntelEnabled('Jammer') then
            self:SetMaintenanceConsumptionInactive()
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self, 'IntelEffectsBag')
            end
        end
    end,

}

TypeClass = uel03011