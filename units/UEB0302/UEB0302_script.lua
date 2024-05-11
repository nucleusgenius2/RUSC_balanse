--****************************************************************************
--**
--**  File     :  /cdimage/units/UEB0302/UEB0302_script.lua
--**  Author(s):  John Comes, David Tomandl
--**
--**  Summary  :  UEF T3 Air Factory Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local TAirFactoryUnit = import("/lua/terranunits.lua").TAirFactoryUnit


---@class UEB0302 : TAirFactoryUnit
UEB0302 = ClassUnit(TAirFactoryUnit) {

    RollOffAnimationRate = 12,

    StartArmsMoving = function(self)
        TAirFactoryUnit.StartArmsMoving(self)
        if not self.ArmSlider1 then
            self.ArmSlider1 = CreateSlider(self, 'Arm01')
            self.Trash:Add(self.ArmSlider1)
        end
        if not self.ArmSlider2 then
            self.ArmSlider2 = CreateSlider(self, 'Arm02')
            self.Trash:Add(self.ArmSlider2)
        end
        if not self.ArmSlider3 then
            self.ArmSlider3 = CreateSlider(self, 'Arm03')
            self.Trash:Add(self.ArmSlider3)
        end
    end,

    MovingArmsThread = function(self)
        TAirFactoryUnit.MovingArmsThread(self)
        local dir = 1
        while true do
            if not self.ArmSlider1 then return end
            if not self.ArmSlider2 then return end
            if not self.ArmSlider3 then return end
            self.ArmSlider1:SetGoal(0, -5, 0)
            self.ArmSlider1:SetSpeed(20)
            self.ArmSlider2:SetGoal(0, 2 * dir, 0)
            self.ArmSlider2:SetSpeed(10)
            self.ArmSlider3:SetGoal(0, 5, 0)
            self.ArmSlider3:SetSpeed(20)
            WaitFor(self.ArmSlider3)
            self.ArmSlider1:SetGoal(0, 0, 0)
            self.ArmSlider1:SetSpeed(20)
            self.ArmSlider2:SetGoal(0, 0, 0)
            self.ArmSlider2:SetSpeed(10)
            self.ArmSlider3:SetGoal(0, 0, 0)
            self.ArmSlider3:SetSpeed(20)
            WaitFor(self.ArmSlider3)
            dir = dir * -1
        end
    end,

    StopArmsMoving = function(self)
        TAirFactoryUnit.StopArmsMoving(self)
        self.ArmSlider1:SetGoal(0, 0, 0)
        self.ArmSlider2:SetGoal(0, 0, 0)
        self.ArmSlider3:SetGoal(0, 0, 0)
        self.ArmSlider1:SetSpeed(40)
        self.ArmSlider2:SetSpeed(40)
        self.ArmSlider3:SetSpeed(40)
    end,

	OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        TAirFactoryUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
		AddBuildRestriction(self:GetArmy(), categories.RESTTR1)
		self:ForkThread(self.Restrt)
    end,

	
	OnStopBeingBuilt = function(self, unitBeingBuilt)
        TAirFactoryUnit.OnStopBeingBuilt(self, unitBeingBuilt)
	--	AddBuildRestriction(self:GetArmy(), categories.RESTTR1)
	--	self:ForkThread(self.Restrt)
    end,

    Restrt = function(self)
		while not self.Dead do
			local restr1 = false

			local brain = self:GetAIBrain()
			local all = brain:GetListOfUnits(categories.FACTORY, false)
		--	local all = brain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), 300)
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

TypeClass = UEB0302
