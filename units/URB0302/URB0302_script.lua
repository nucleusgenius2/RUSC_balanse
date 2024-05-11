--****************************************************************************
--**
--**  File     :  /cdimage/units/URB0302/URB0302_script.lua
--**  Author(s):  David Tomandl
--**
--**  Summary  :  Cybran Tier 3 Air Unit Factory Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CAirFactoryUnit = import("/lua/cybranunits.lua").CAirFactoryUnit

---@class URB0302 : CAirFactoryUnit
URB0302 = Class(CAirFactoryUnit) {

	OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        CAirFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR3)
		self:ForkThread(self.Restrt)
    end,

	OnStopBeingBuilt = function(self, unitBeingBuilt)
        CAirFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR3)
	--	self:ForkThread(self.Restrt)
    end,

    Restrt = function(self)
		while not self.Dead do
			local restr3 = false

			local brain = self:GetAIBrain()
			local all = brain:GetListOfUnits(categories.FACTORY, false)
		--	local all = brain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), 300)
			local units3 = {}

			for  _, u in all do
				if not u.Dead then
					table.insert(units3, u)
				end				
			end			
			for  _, unit in units3 do
				if unit:GetBlueprint().BlueprintId == 'urs1501' and not (unit:IsUnitState('BeingBuilt')) then
					restr3 = true
				end
			end
			if restr3 then
				RemoveBuildRestriction(self:GetArmy(), categories.RESTTR3)
			else 
				AddBuildRestriction(self:GetArmy(), categories.RESTTR3)
			end
			WaitTicks(31)
				
		end
    end,

 }

TypeClass = URB0302
