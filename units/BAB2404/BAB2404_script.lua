--****************************************************************************
--**
--**  File     :  /cdimage/units/UAB1301/UAB1301_script.lua
--**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
--**
--**  Summary  :  Aeon Power Generator Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local AEnergyCreationUnit = import("/lua/aeonunits.lua").AEnergyCreationUnit
local SCUDeathWeapon = import('/lua/sim/defaultweapons.lua').SCUDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')

---@class UAB1301 : AEnergyCreationUnit
BAB2404 = ClassUnit(AEnergyCreationUnit) {
	Weapons = {
			DeathWeapon = Class(SCUDeathWeapon) {
		},
	}, 

    BuildingEffect01 = {
        '/effects/emitters/light_blue_blinking_01_emit.bp',
    },
    AmbientEffects = 'AT3PowerAmbient',
    
    OnStopBeingBuilt = function(self, builder, layer)
        AEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        self.BuildingEffect01Bag = {}
        self.BuildingEffect02Bag = {}
        local mul = 1
        local sx = 1 or 1
        local sz = 1 or 1
        local sy = 1 or sx + sz

        for i = 1, 16 do
            local fxname
            if i < 10 then
                fxname = 'Light0' .. i
            else
                fxname = 'Light' .. i
            end
            local fx = CreateAttachedEmitter(self, fxname, self:GetArmy(), '/effects/emitters/light_yellow_02_emit.bp'):OffsetEmitter(0, 0, 0.01):ScaleEmitter(3)
            self.Trash:Add(fx)
        end
        self.Trash:Add(CreateRotator(self, 'Sphere', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'z', nil, 0, 15, 80 + Random(0, 20)))
    end,
	
	OnKilled = function(self, instigator, damagetype, overkillRatio)
		AEnergyCreationUnit.OnKilled(self, instigator, damagetype, overkillRatio)
		self:CreatTheEffectsDeath()  
	end,
	
    DeathThread = function(self, overkillRatio)
		if self.PlayDestructionEffects then
			self:CreateDestructionEffects(self, overkillRatio)
		end
			
		AEnergyCreationUnit.DeathThread(self, overkillRatio)
    end,
	
	CreatTheEffectsDeath = function(self)
		local army =  self:GetArmy()
		for k, v in EffectTemplate['SZthuthaamArtilleryHit'] do
			self.Trash:Add(CreateAttachedEmitter(self, 'Sphere', army, v):ScaleEmitter(6.85))
		end
		for k, v in TMEffectTemplate['AeonUnitDeathRing03'] do
			self.Trash:Add(CreateAttachedEmitter(self, 'Sphere', army, v):ScaleEmitter(3.25))
		end
		for k, v in TMEffectTemplate['UEFDeath01'] do
			self.Trash:Add(CreateAttachedEmitter(self, 'Sphere', army, v):ScaleEmitter(1.85))
		end
	end,
}

TypeClass = BAB2404
