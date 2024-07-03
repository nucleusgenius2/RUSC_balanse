--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local ConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local AIUtils = import('/lua/ai/aiutilities.lua')
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread

SEB3404 = Class(ConstructionUnit) {

    OnStartBeingBuilt = function(self, unitBeingBuilt, order)
        ConstructionUnit.OnStartBeingBuilt(self, unitBeingBuilt, order)
        AddBuildRestriction(self:GetArmy(), categories.ORBITAL1)
    end,

    OnStopBeingBuilt = function(self, ...)
        ConstructionUnit.OnStopBeingBuilt(self, unpack(arg))
        AddBuildRestriction(self:GetArmy(), categories.ORBITAL1)
        local bp = self:GetBlueprint()
        self.PanopticonUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
        self:SetScriptBit('RULEUTC_WeaponToggle', true)
        self:ForkThread(
            function()
                local army = self:GetArmy()
                local aiBrain = self:GetAIBrain()
                local maxrange = 6000

                while true do
                    if self.Intel == true then
                        self:IntelSearch(bp, army, aiBrain, maxrange)
                    end
                    WaitSeconds(1)
                end
            end
        )
        self:ForkThread(AnimationThread, {
            {
                'Xband_Base',
                'Xband_Dish',
                bounds = { -180, 180, -90, 0, },
                speed = 3,
            },
            {
                'Tiny_Dish_00',
                c = 2,
                cont = true
            },
            {
                'Small_XBand_Stand_00',
                'Small_XBand_Dish_00',
                c = 4,
                bounds = { -180, 180, -90, 0, },
            },
            {
                'Small_Dish_00',
                'Small_Dish_00',
                c = 4,
                bounds = { -180, 180, -90, 90, },
                speed = 20,
            },
            {
                'Med_Dish_Stand_00',
                'Med_Dish_00',
                c = 4,
                bounds = { -180, 180, -90, 90, },
                speed = 6,
            },
            {
                'Large_Dish_Base',
                'Large_Dish',
                bounds = { -180, 180, -90, 0, },
                speed = 2,
            },
        })
        local drawscale = bp.Display.UniformScale or 1
        for i, v in { Panopticon = 'Domes', Large_Dish = 'Dish_Scaffolds' } do
            local entity = import('/lua/sim/Entity.lua').Entity({ Owner = self, })
            entity:AttachBoneTo(-1, self, i)
            entity:SetMesh('/units/SEB3404/SEB3404_' .. v .. '_mesh')
            entity:SetDrawScale(drawscale)
            entity:SetVizToAllies('Intel')
            entity:SetVizToNeutrals('Intel')
            entity:SetVizToEnemies('Intel')
            self.Trash:Add(entity)
        end
        self:RemoveToggleCap('RULEUTC_ProductionToggle')
        self.Satellite = nil
    end,

    OpenState = State() {

        Main = function(self)
            -- If the unit has arrived with a new player via capture, it will already have a Satellite in the wild
            if not self.Satellite then

                if self.newSatellite then
                    self.Satellite = self.newSatellite
                    self.newSatellite = nil
                end

                -- Release unit
                self.Satellite:DetachFrom()

                IssueClearCommands({ self })
            end

            local army = self.Army
            self.Satellite.Parent = self
            ChangeState(self, self.IdleState)
        end,
    },

    -- Override OnStartBuild to cancel any and all commands if we already have a Satellite
    OnStartBuild = function(self, unitBeingBuilt, order)
        if self.Satellite.Dead then
            self.Satellite = nil
        end
        if self.Satellite then

            IssueStop({ self })
            IssueClearCommands({ self }) -- This clears the State launch procedure for some reason, leading to the following hack

        else
            pos = self:GetPosition('Panopticon1')
            unitBeingBuilt:SetPosition(pos, true)
            ConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt)

        if self.Satellite then
            IssueStop({ self })
            IssueClearCommands({ self })
            unitBeingBuilt:Destroy()
        else
            self.newSatellite = unitBeingBuilt
            ConstructionUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.OpenState)

            --local captorArmyIndex = unitBeingBuilt.Army
            --ChangeUnitArmy(captorArmyIndex, self.Satellite)

            -- Shift the two units to the new army and assign relationship
            --if self.Satellite and not self.Satellite.Dead then
            --    local sat = ChangeUnitArmy(captorArmyIndex, self.Satellite)
            --    base.Satellite = sat
            --    sat.Parent = base
            --end



            -- Shift the two units to the new army and assign relationship
            --if self.Satellite and not self.Satellite.Dead then
            --    local sat = ChangeUnitArmy(captorArmyIndex, self.Satellite)
            --sat.Parent = base
            --base.Satellite = sat
            --end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Satellite and not self.Satellite.Dead and not self.Satellite.IsDying then
            self.Satellite:Kill()
        end

        self:SetActiveConsumptionInactive()
        ChangeState(self, self.IdleState)
        ConstructionUnit.OnKilled(self, instigator, type, overkillRatio)

        self:DestroyUnitBeingBuilt()
    end,

    OnDestroy = function(self)
        if self.Satellite and not self.Satellite.Dead and not self.Satellite.IsDying then
            self.Satellite:Destroy()
        end

        ConstructionUnit.OnDestroy(self)

        if self.Blueprint.CategoriesHash["RESEARCH"] and self:GetFractionComplete() == 1.0 then

            -- update internal state
            self.Brain:RemoveHQ(self.Blueprint.FactionCategory, self.Blueprint.LayerCategory, self.Blueprint.TechCategory)
            self.Brain:SetHQSupportFactoryRestrictions(self.Blueprint.FactionCategory, self.Blueprint.LayerCategory)

            -- update all units affected by this
            local affected = self.Brain:GetListOfUnits(categories.SUPPORTFACTORY - categories.EXPERIMENTAL, false)
            for id, unit in affected do
                unit:UpdateBuildRestrictions()
            end
        end

        self:DestroyUnitBeingBuilt()
    end,

    OnCaptured = function(self, captor)
        if self and not self.Dead and captor and not captor.Dead and self:GetAIBrain() ~= captor:GetAIBrain() then
            local captorArmyIndex = captor.Army

            -- Disable unit cap for campaigns
            if ScenarioInfo.CampaignMode then
                SetIgnoreArmyUnitCap(captorArmyIndex, true)
            end

            -- Shift the two units to the new army and assign relationship
            local base = ChangeUnitArmy(self, captorArmyIndex)
            if self.Satellite and not self.Satellite.Dead then
                local sat = ChangeUnitArmy(self.Satellite, captorArmyIndex)
                sat.Parent = base
                base.Satellite = sat
            end

            -- Reapply unit cap checks
            local captorBrain = captor:GetAIBrain()
            if ScenarioInfo.CampaignMode and not captorBrain.IgnoreArmyCaps then
                SetIgnoreArmyUnitCap(captorArmyIndex, false)
            end
        end
    end,

    ---@param self FactoryUnit
    DestroyUnitBeingBuilt = function(self)
        if self.UnitBeingBuilt and not self.UnitBeingBuilt.Dead and self.UnitBeingBuilt:GetFractionComplete() < 1 then
            if self.UnitBeingBuilt:GetFractionComplete() > 0.5 then
                self.UnitBeingBuilt:Kill()
            else
                self.UnitBeingBuilt:Destroy()
            end
        end
    end,



}

TypeClass = SEB3404
