#****************************************************************************
#**
#**  File     :  /Mods/units/UESE0001/UESE0001_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix  
#**					Modified By Asdrubaelvect
#**  Summary  :  FTU tech 1 spaceships experimental
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TAirUnit = import('/lua/terranunits.lua').TAirUnit

local TIFCruiseMissileLauncher = import("/lua/terranweapons.lua").TIFCruiseMissileLauncher
local TIFCruiseMissileUnpackingLauncher = import("/lua/terranweapons.lua").TIFCruiseMissileUnpackingLauncher
local EffectTemplate = import("/lua/effecttemplates.lua")
local fxutil = import('/lua/effectutilities.lua')
local Shield = import("/lua/shield.lua").Shield
local TAirUnit = import("/lua/terranunits.lua").TAirUnit
local TOrbitalDeathLaserBeamWeapon = import("/lua/terranweapons.lua").TOrbitalDeathLaserBeamWeapon
local Weapon = import('/lua/BlackOpsweapons.lua')
local TDFGoliathShoulderBeam = Weapon.TDFGoliathShoulderBeam

UESE0001 = Class(TAirUnit) {

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_mobile_01_emit.bp',
        '/effects/emitters/terran_shield_generator_mobile_02_emit.bp',
    },

    Weapons = {
        MissileWeapon1 = ClassWeapon(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
            
            
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
                OnLostTarget = function(self)
                    self:ForkThread( self.LostTargetThread )
                end,            
            },            

            LostTargetThread = function(self)
                while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
                    WaitSeconds(2)
                end

                if self.unit:IsDead() then
                    return
                end
                
                local bp = self:GetBlueprint()

                if bp.WeaponUnpacks then
                    ChangeState(self, self.WeaponPackingState)
                else
                    ChangeState(self, self.IdleState)
                end
            end,
        },
		MissileWeapon2 = ClassWeapon(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
            
            
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
                OnLostTarget = function(self)
                    self:ForkThread( self.LostTargetThread )
                end,            
            },            

            LostTargetThread = function(self)
                while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
                    WaitSeconds(2)
                end

                if self.unit:IsDead() then
                    return
                end
                
                local bp = self:GetBlueprint()

                if bp.WeaponUnpacks then
                    ChangeState(self, self.WeaponPackingState)
                else
                    ChangeState(self, self.IdleState)
                end
            end,
        },
		MissileWeapon3 = ClassWeapon(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
            
            
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
                OnLostTarget = function(self)
                    self:ForkThread( self.LostTargetThread )
                end,            
            },            

            LostTargetThread = function(self)
                while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
                    WaitSeconds(2)
                end

                if self.unit:IsDead() then
                    return
                end
                
                local bp = self:GetBlueprint()

                if bp.WeaponUnpacks then
                    ChangeState(self, self.WeaponPackingState)
                else
                    ChangeState(self, self.IdleState)
                end
            end,
        },
		MissileWeapon4 = ClassWeapon(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
            
            
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
                OnLostTarget = function(self)
                    self:ForkThread( self.LostTargetThread )
                end,            
            },            

            LostTargetThread = function(self)
                while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
                    WaitSeconds(2)
                end

                if self.unit:IsDead() then
                    return
                end
                
                local bp = self:GetBlueprint()

                if bp.WeaponUnpacks then
                    ChangeState(self, self.WeaponPackingState)
                else
                    ChangeState(self, self.IdleState)
                end
            end,
        },
        TacNukeMissile = ClassWeapon(TIFCruiseMissileLauncher) {},
        OrbitalDeathLaserWeapon = ClassWeapon(TOrbitalDeathLaserBeamWeapon) {},
        OrbitalDeathLaserWeapon1 = Class(TDFGoliathShoulderBeam) {},
    },
	
    MovementAmbientExhaustBones = {
		'Reacteur02',
		'Reacteur04',		
    },

    OnMotionHorzEventChange = function(self, new, old )
		TAirUnit.OnMotionHorzEventChange(self, new, old)
	
		if self.ThrustExhaustTT1 == nil then 
			if self.MovementAmbientExhaustEffectsBag then
				fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			else
				self.MovementAmbientExhaustEffectsBag = {}
			end
			self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
		end
		
        if new == 'Stopped' and self.ThrustExhaustTT1 != nil then
			KillThread(self.ThrustExhaustTT1)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			self.ThrustExhaustTT1 = nil
        end		 
    end,
    
    MovementAmbientExhaustThread = function(self)
		while not self.Dead do
			local ExhaustEffects = {
				'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',
				--'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',	
			}
			local ExhaustBeam = '/effects/emitters/missile_exhaust_fire_beam_12_emit.bp'
			local army = self:GetArmy()			
			
			for kE, vE in ExhaustEffects do
				for kB, vB in self.MovementAmbientExhaustBones do
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity( self, vB, army, ExhaustBeam ))
				end
			end
			

			WaitSeconds(0)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
							
		end	
    end,		

    OnStopBeingBuilt = function(self, builder, layer)
        TAirUnit.OnStopBeingBuilt(self, builder, layer)
		self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', false)
		self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon1', false)
    end,

    -- Enhancements
    CreateEnhancement = function(self, enh)
        TAirUnit.CreateEnhancement(self, enh)
        local bp = self.Blueprint.Enhancements[enh]
        if not bp then return end
        if enh == 'Laser' then
			self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', true)
		--	self:SetScriptBit('RULEUTC_ShieldToggle', true)
            IssueStop({self})
        elseif enh == 'LaserRemove' then
			self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', false)
		--	self:SetScriptBit('RULEUTC_ShieldToggle', true)
            IssueStop({self})
        elseif enh == 'GreenLaser' then
			self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon1', true)
		--	self:SetScriptBit('RULEUTC_ShieldToggle', true)
            IssueStop({self})
        elseif enh == 'GreenLaserRemove' then
			self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon1', false)
		--	self:SetScriptBit('RULEUTC_ShieldToggle', true)
            IssueStop({self})
		end
    end,

    OnScriptBitSet = function(self, bit)
        TAirUnit.OnScriptBitSet(self, bit)
        local bp = self:GetBlueprint().Defense.Shield
        if bit == 0 then
		
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:EnableShield()

			local MainWep = self:GetWeaponByLabel('MissileWeapon1')
			MainWep:ChangeRateOfFire(0.1*2)
			local MainWep = self:GetWeaponByLabel('MissileWeapon2')
			MainWep:ChangeRateOfFire(0.1*1.9)
			local MainWep = self:GetWeaponByLabel('MissileWeapon3')
			MainWep:ChangeRateOfFire(0.1*1.9)
			local MainWep = self:GetWeaponByLabel('MissileWeapon4')
			MainWep:ChangeRateOfFire(0.1*1.8)
		
		--	self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', false)
		--	self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon1', false)
			
            IssueStop({self})
            self:SetSpeedMult(0.5)

        end
    end,
	
    OnScriptBitClear = function(self, bit)
        TAirUnit.OnScriptBitClear(self, bit)
        local bp = self:GetBlueprint().Defense.Shield
        if bit == 0 then
		
            self:SetMaintenanceConsumptionInactive()
            self:DisableShield()

			local MainWep1 = self:GetWeaponByLabel('MissileWeapon1')
			MainWep1:ChangeRateOfFire(0.1*4)
			local MainWep2 = self:GetWeaponByLabel('MissileWeapon2')
			MainWep2:ChangeRateOfFire(0.1*3.8)
			local MainWep3 = self:GetWeaponByLabel('MissileWeapon3')
			MainWep3:ChangeRateOfFire(0.1*3.8)
			local MainWep4 = self:GetWeaponByLabel('MissileWeapon4')
			MainWep4:ChangeRateOfFire(0.1*3.6)

		--	if self:HasEnhancement('Laser') then 
		--		self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', true)
		--	elseif	self:HasEnhancement('GreenLaser') then
		--		self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon', false)
		--		self:SetWeaponEnabledByLabel('OrbitalDeathLaserWeapon1', true)
		--	end

            self:SetSpeedMult(1.0)

        end
    end,

}

TypeClass = UESE0001
