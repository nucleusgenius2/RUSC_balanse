-- #****************************************************************************
-- #**
-- #**  File     :  /cdimage/units/URS0302/URS0302_script.lua
-- #**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- #**
-- #**  Summary  :  Cybran Battleship Script
-- #**
-- #**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- #****************************************************************************

local SeaUnit = import("/lua/defaultunits.lua").SeaUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CybranWeaponsFile2 = import('/lua/BlackOpsweapons.lua')
local CAAAutocannon = CybranWeaponsFile.CAAAutocannon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local XCannonWeapon01 = CybranWeaponsFile2.XCannonWeapon01
local CDFHvyProtonCannonWeapon = CybranWeaponsFile.CDFHvyProtonCannonWeapon
local CANNaniteTorpedoWeapon = CybranWeaponsFile.CANNaniteTorpedoWeapon
local CAMZapperWeapon = CybranWeaponsFile.CAMZapperWeapon
local MGAALaserWeapon = CybranWeaponsFile2.MGAALaserWeapon
local CAMEMPMissileWeapon = CybranWeaponsFile.CAMEMPMissileWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local CIFSmartCharge = CybranWeaponsFile.CIFSmartCharge
local CDFHeavyMicrowaveLaserGenerator = CybranWeaponsFile.CDFHeavyMicrowaveLaserGeneratorAir
       
BRS0402= Class(SeaUnit) {

	MuzzleFlashEffects01 = {
		'/effects/emitters/xcannon_cannon_muzzle_01_emit.bp',--#large redish flash
		'/effects/emitters/x_cannon_fire_test_01_emit.bp',--barrel lightning effect
		'/effects/emitters/xcannon_cannon_muzzle_07_emit.bp',-- small redish flash, double quick
		'/effects/emitters/xcannon_cannon_muzzle_08_emit.bp',-- small redish double flash
	},
	
	MuzzleFlashEffects02 = {
		'/effects/emitters/dirty_exhaust_sparks_02_emit.bp',	
	},
	
	MuzzleChargeEffects = {
		'/effects/emitters/x_cannon_charge_test_01_emit.bp',--#lightning
	},

	Weapons = {
        AAGun = ClassWeapon(CDFHeavyMicrowaveLaserGenerator) {},
        AAGun1 = ClassWeapon(CDFHeavyMicrowaveLaserGenerator) {},
		AAGun2 = ClassWeapon(CDFHeavyMicrowaveLaserGenerator) {},
        AAGun3 = ClassWeapon(CDFHeavyMicrowaveLaserGenerator) {},
		MissileRack = Class(CAMEMPMissileWeapon) {
            IdleState = State(CAMEMPMissileWeapon.IdleState) {
                OnGotTarget = function(self)
                    local bp = self:GetBlueprint()
                    --only say we've fired if the parent fire conditions are met
                    if (bp.WeaponUnpackLockMotion != true or (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
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
                        WaitSeconds(1/self.unit:GetBlueprint().Weapon[1].RateOfFire + .2)
                        self.unit:SetBusy(false)
                    end)
                end,
            },
		},
        AntiNuke2 = Class(CAMEMPMissileWeapon) {},
	
        MainCannon01 = Class(XCannonWeapon01) {
        	OnWeaponFired = function(self)
            	XCannonWeapon01.OnWeaponFired(self)
            	if self.unit.MuzzleFlashWep1Effects01Bag then
            		for k, v in self.unit.MuzzleFlashWep1Effects01Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleFlashWep1Effects01Bag = {}
				end
        		for k, v in self.unit.MuzzleFlashEffects01 do
            		table.insert( self.unit.MuzzleFlashWep1Effects01Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Muzzle', self.unit:GetArmy(), v ):ScaleEmitter(1.2))
        		end
        		
        		if self.unit.MuzzleFlashWep1Effects02Bag then
            		for k, v in self.unit.MuzzleFlashWep1Effects02Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleFlashWep1Effects02Bag = {}
				end
        		for k, v in self.unit.MuzzleFlashEffects02 do
            		table.insert( self.unit.MuzzleFlashWep1Effects02Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Effect03', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
            		table.insert( self.unit.MuzzleFlashWep1Effects02Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Effect04', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
            		table.insert( self.unit.MuzzleFlashWep1Effects02Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Effect05', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
        		end
				self:ForkThread(self.MuzzleFlashEffectsWep1CleanUp)
			end,
				
			MuzzleFlashEffectsWep1CleanUp = function(self)
				WaitTicks(30)
				if self.unit.MuzzleFlashWep1Effects01Bag then
					for k, v in self.unit.MuzzleFlashWep1Effects01Bag do
						v:Destroy()
					end
					self.unit.MuzzleFlashWep1Effects01Bag = {}
				end
				if self.unit.MuzzleFlasWep1hEffects02Bag then
					for k, v in self.unit.MuzzleFlashWep1Effects02Bag do
						v:Destroy()
					end
					self.unit.MuzzleFlashWep1Effects02Bag = {}
				end
			end,
            
        	PlayFxRackSalvoChargeSequence = function(self, muzzle)
            	XCannonWeapon01.PlayFxRackSalvoChargeSequence(self, muzzle) 
            	local wep = self.unit:GetWeaponByLabel('MainCannon01')
            	local bp = wep:GetBlueprint()
        		if bp.Audio.RackSalvoCharge then
            		wep:PlaySound(bp.Audio.RackSalvoCharge)
        		end
            	if self.unit.MuzzleChargeEffectsWep1Bag then
            		for k, v in self.unit.MuzzleChargeEffectsWep1Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleChargeEffectsWep1Bag = {}
				end
        		for k, v in self.unit.MuzzleChargeEffects do
            		table.insert( self.unit.MuzzleChargeEffectsWep1Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Effect01', self.unit:GetArmy(), v ):ScaleEmitter(0.4):OffsetEmitter(0, 0, -0.9))
            		table.insert( self.unit.MuzzleChargeEffectsWep1Bag, CreateAttachedEmitter( self.unit, 'Left_Railgun_Effect02', self.unit:GetArmy(), v ):ScaleEmitter(0.4):OffsetEmitter(0, 0, -0.9))
        		end
        		self:ForkThread(self.MuzzleChargeEffectsWep1CleanUp)
        	end,
        	MuzzleChargeEffectsWep1CleanUp = function(self)
				WaitTicks(100)
				if self.unit.MuzzleChargeEffectsWep1Bag then
					for k, v in self.unit.MuzzleChargeEffectsWep1Bag do
						v:Destroy()
					end
					self.unit.MuzzleChargeEffectsWep1Bag = {}
				end
			end,
        },
        MainCannon02 = Class(XCannonWeapon01) {
        	OnWeaponFired = function(self)
            	XCannonWeapon01.OnWeaponFired(self)
            	if self.unit.MuzzleFlashWep2Effects01Bag then
            		for k, v in self.unit.MuzzleFlashWep2Effects01Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleFlashWep2Effects01Bag = {}
				end
        		for k, v in self.unit.MuzzleFlashEffects01 do
            		table.insert( self.unit.MuzzleFlashWep2Effects01Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Muzzle', self.unit:GetArmy(), v ):ScaleEmitter(1.2))
        		end
        		
        		if self.unit.MuzzleFlashWep2Effects02Bag then
            		for k, v in self.unit.MuzzleFlashWep2Effects02Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleFlashWep2Effects02Bag = {}
				end
        		for k, v in self.unit.MuzzleFlashEffects02 do
            		table.insert( self.unit.MuzzleFlashWep2Effects02Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Effect03', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
            		table.insert( self.unit.MuzzleFlashWep2Effects02Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Effect04', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
            		table.insert( self.unit.MuzzleFlashWep2Effects02Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Effect05', self.unit:GetArmy(), v ):ScaleEmitter(0.5))
        		end
				self:ForkThread(self.MuzzleFlashEffectsWep2CleanUp)
			end,
				
			MuzzleFlashEffectsWep2CleanUp = function(self)
				WaitTicks(30)
				if self.unit.MuzzleFlashWep2Effects01Bag then
					for k, v in self.unit.MuzzleFlashWep2Effects01Bag do
						v:Destroy()
					end
					self.unit.MuzzleFlashWep2Effects01Bag = {}
				end
				if self.unit.MuzzleFlashWep2Effects02Bag then
					for k, v in self.unit.MuzzleFlashWep2Effects02Bag do
						v:Destroy()
					end
					self.unit.MuzzleFlashWep2Effects02Bag = {}
				end
			end,
            
        	PlayFxRackSalvoChargeSequence = function(self, muzzle)
            	XCannonWeapon01.PlayFxRackSalvoChargeSequence(self, muzzle) 
            	local wep2 = self.unit:GetWeaponByLabel('MainCannon02')
            	local bp = wep2:GetBlueprint()
        		if bp.Audio.RackSalvoCharge then
            		wep2:PlaySound(bp.Audio.RackSalvoCharge)
        		end
            	if self.unit.MuzzleChargeEffectsWep2Bag then
            		for k, v in self.unit.MuzzleChargeEffectsWep2Bag do
                		v:Destroy()
            		end
		    		self.unit.MuzzleChargeEffectsWep2Bag = {}
				end
        		for k, v in self.unit.MuzzleChargeEffects do
            		table.insert( self.unit.MuzzleChargeEffectsWep2Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Effect01', self.unit:GetArmy(), v ):ScaleEmitter(0.4):OffsetEmitter(0, 0, -0.9))
            		table.insert( self.unit.MuzzleChargeEffectsWep2Bag, CreateAttachedEmitter( self.unit, 'Right_Railgun_Effect02', self.unit:GetArmy(), v ):ScaleEmitter(0.4):OffsetEmitter(0, 0, -0.9))
        		end
        		self:ForkThread(self.MuzzleChargeEffectsWep2CleanUp)
        	end,
        	MuzzleChargeEffectsWep2CleanUp = function(self)
				WaitTicks(100)
				if self.unit.MuzzleChargeEffectsWep2Bag then
					for k, v in self.unit.MuzzleChargeEffectsWep2Bag do
						v:Destroy()
					end
					self.unit.MuzzleChargeEffectsWep2Bag = {}
				end
			end,
        },
		
        Cannon01 = Class(CDFProtonCannonWeapon) {},
        Cannon02 = Class(CDFProtonCannonWeapon) {},
        Cannon03 = Class(CDFProtonCannonWeapon) {},
        Cannon04 = Class(CDFProtonCannonWeapon) {},
        Cannon05 = Class(CDFProtonCannonWeapon) {},
        Cannon06 = Class(CDFProtonCannonWeapon) {},
		
        AntiMissile = Class(CAMZapperWeapon) {},
		
        Torpedoes = Class(CANNaniteTorpedoWeapon) {},
		
        HailfireRocket = Class(CAANanoDartWeapon) {},
		
        AntiTorpedo = Class(CIFSmartCharge) {},
    },

    OnStartBeingBuilt = function(self, builder, layer)
        SeaUnit.OnStartBeingBuilt(self, builder, layer)
		self:HideBone('HeavyWeaponBarrel01', true)
		self:HideBone('HeavyWeaponBarrel02', true)
		self:HideBone('HeavyWeaponBarrel011', true)
		self:HideBone('HeavyWeaponBarrel021', true)
		self:HideBone('HeavyWeaponTurret', true)
		self:HideBone('HeavyWeaponTurret1', true)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        SeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.MuzzleFlashWep1Effects01Bag = {}
        self.MuzzleFlashWep1Effects02Bag = {}
        self.MuzzleFlashWep2Effects01Bag = {}
        self.MuzzleFlashWep2Effects02Bag = {}
        self.MuzzleChargeEffectsWep1Bag = {}
        self.MuzzleChargeEffectsWep2Bag = {}
		self:HideBone('HeavyWeaponBarrel01', true)
		self:HideBone('HeavyWeaponBarrel02', true)
		self:HideBone('HeavyWeaponBarrel011', true)
		self:HideBone('HeavyWeaponBarrel021', true)
		self:HideBone('HeavyWeaponTurret', true)
		self:HideBone('HeavyWeaponTurret1', true)
		self:SetWeaponEnabledByLabel('AAGun', false)
		self:SetWeaponEnabledByLabel('AAGun1', false)
		self:SetWeaponEnabledByLabel('AAGun2', false)
		self:SetWeaponEnabledByLabel('AAGun3', false)
    end,
	
    CreateEnhancement = function(self, enh)
        SeaUnit.CreateEnhancement(self, enh)

        if enh == 'NaniteMissileSystem' then
			self:ShowBone('HeavyWeaponBarrel01', true)
			self:ShowBone('HeavyWeaponBarrel02', true)
			self:ShowBone('HeavyWeaponBarrel011', true)
			self:ShowBone('HeavyWeaponBarrel021', true)
			self:ShowBone('HeavyWeaponTurret', true)
			self:ShowBone('HeavyWeaponTurret1', true)
            self:SetWeaponEnabledByLabel('AAGun', true)
            self:SetWeaponEnabledByLabel('AAGun1', true)
            self:SetWeaponEnabledByLabel('AAGun2', true)
            self:SetWeaponEnabledByLabel('AAGun3', true)
        elseif enh == 'NaniteMissileSystemRemove' then
			self:HideBone('HeavyWeaponBarrel01', true)
			self:HideBone('HeavyWeaponBarrel02', true)
			self:HideBone('HeavyWeaponBarrel011', true)
			self:HideBone('HeavyWeaponBarrel021', true)
			self:HideBone('HeavyWeaponTurret', true)
			self:HideBone('HeavyWeaponTurret1', true)
            self:SetWeaponEnabledByLabel('AAGun', false)
            self:SetWeaponEnabledByLabel('AAGun1', false)
			self:SetWeaponEnabledByLabel('AAGun2', false)
            self:SetWeaponEnabledByLabel('AAGun3', false)
        end
		
    end,
}

TypeClass = BRS0402