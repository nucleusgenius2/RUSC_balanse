--****************************************************************************
--**
--**  File     :  /cdimage/units/URB0301/URB0301_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Cybran T3 Land Factory Unit Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CLandFactoryUnit = import("/lua/cybranunits.lua").CLandFactoryUnit

---@class URB0301 : CLandFactoryUnit
URB0301 = ClassUnit(CLandFactoryUnit) {

	OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        CLandFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR3)
		self:ForkThread(self.Restrt)
    end,

	OnStopBeingBuilt = function(self, unitBeingBuilt)
        CLandFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR3)
	--	self:ForkThread(self.Restrt)
    end,

    Restrt = function(self)
		while not self.Dead do
			local restr3 = false
			local all = {}

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

TypeClass = URB0301
