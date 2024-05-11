-- File     :  /cdimage/units/UAB0301/UAB0301_script.lua
-- Author(s):  David Tomandl
-- Summary  :  Aeon Land Factory Tier 3 Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------
local SLandFactoryUnit = import("/lua/seraphimunits.lua").SLandFactoryUnit

---@class XSB0301 : SLandFactoryUnit
XSB0301 = ClassUnit(SLandFactoryUnit) {

    OnCreate = function(self)
        SLandFactoryUnit.OnCreate(self)
        self.Rotator1 = CreateRotator(self, 'Pod01', 'y', nil, 5, 0, 0)
        self.Trash:Add(self.Rotator1)
        self.Rotator2 = CreateRotator(self, 'Pod02', 'y', nil, 8, 0, 0)
        self.Trash:Add(self.Rotator2)
        self.Rotator3 = CreateRotator(self, 'Pod03', 'y', nil, -3, 0, 0)
        self.Trash:Add(self.Rotator3)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Rotator1:SetSpeed(0)
        self.Rotator2:SetSpeed(0)
        self.Rotator3:SetSpeed(0)
        SLandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

	OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        SLandFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR4)
		self:ForkThread(self.Restrt)
    end,
	
	OnStopBeingBuilt = function(self, unitBeingBuilt)
        SLandFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR4)
	--	self:ForkThread(self.Restrt)
    end,

    Restrt = function(self)
		while not self.Dead do
			local restr4 = false

			local brain = self:GetAIBrain()
			local all = brain:GetListOfUnits(categories.FACTORY, false)
		--	local all = brain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), 300)
			local units4 = {}

			for  _, u in all do
				if not u.Dead and not u:IsBeingBuilt() then
					table.insert(units4, u)
				end				
			end			
			for  _, unit in units4 do
				if unit:GetBlueprint().BlueprintId == 'xss1501' and not unit:IsUnitState('BeingBuilt') then
					restr4 = true
				end
			end
			if restr4 then
				RemoveBuildRestriction(self:GetArmy(), categories.RESTTR4)
			else 
				AddBuildRestriction(self:GetArmy(), categories.RESTTR4)
			end
			WaitTicks(31)
				
		end
    end,
	
}

TypeClass = XSB0301
