--****************************************************************************
--**
--**  File     :  /cdimage/units/UEB0301/UEB0301_script.lua
--**  Author(s):  David Tomandl
--**
--**  Summary  :  Terran Unit Script
--**
--**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local TLandFactoryUnit = import("/lua/terranunits.lua").TLandFactoryUnit

---@class UEB0301 : TLandFactoryUnit
UEB0301 = ClassUnit(TLandFactoryUnit) {

    OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        TLandFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR1)
		self:ForkThread(self.Restrt)
    end,
	
    OnStopBeingBuilt = function(self, unitBeingBuilt)
        TLandFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR1)
	--	self:ForkThread(self.Restrt)
    end,	

    Restrt = function(self)
		while not self.Dead do
			local restr1 = false

			local brain = self:GetAIBrain()
			local all = brain:GetListOfUnits(categories.FACTORY, false)
			local units1 = {}

			for _, u in all do
				if not u.Dead and not u:IsBeingBuilt() then
					table.insert(units1, u)
				end				
			end			
			for _, unit in units1 do
				if unit:GetBlueprint().BlueprintId == 'ues1501' and not unit:IsUnitState('BeingBuilt') then
					restr1 = true
				end
			end
			if restr1 then
				RemoveBuildRestriction(self:GetArmy(), categories.RESTTR1)
			else 
				AddBuildRestriction(self:GetArmy(), categories.RESTTR1)
			end
			WaitTicks(31)
				
		end
    end,

}
TypeClass = UEB0301
