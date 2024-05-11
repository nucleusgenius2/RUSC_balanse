--****************************************************************************
--**
--**  File     :  /cdimage/units/UAB0302/UAB0302_script.lua
--**  Author(s):  John Comes, David Tomandl, Gordon Duclos
--**
--**  Summary  :  Aeon Unit Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local AAirFactoryUnit = import("/lua/aeonunits.lua").AAirFactoryUnit
---@class UAB0302 : AAirFactoryUnit
UAB0302 = ClassUnit(AAirFactoryUnit) {

	OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        AAirFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR2)
		self:ForkThread(self.Restrt)
    end,

	OnStopBeingBuilt = function(self, unitBeingBuilt)
        AAirFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR2)
	--	self:ForkThread(self.Restrt)
    end,

    Restrt = function(self)
		while not self.Dead do
			local restr2 = false

			local brain = self:GetAIBrain()
			local all = brain:GetListOfUnits(categories.FACTORY, false)
		--	local all = brain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), 300)
			local units2 = {}

			for  _, u in all do
				if not u.Dead then
					table.insert(units2, u)
				end				
			end			
			for  _, unit in units2 do
				if unit:GetBlueprint().BlueprintId == 'uas1101' and not unit:IsUnitState('BeingBuilt') then
					restr2 = true
				end
			end
			if restr2 then
				RemoveBuildRestriction(self:GetArmy(), categories.RESTTR2)
			else 
				AddBuildRestriction(self:GetArmy(), categories.RESTTR2)
			end
			WaitTicks(31)
				
		end
    end,

}

TypeClass = UAB0302
