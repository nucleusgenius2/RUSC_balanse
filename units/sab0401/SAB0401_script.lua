--------------------------------------------------------------------------------
--  Summary:  The Independence Engine script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AAirFactoryUnit = import('/lua/aeonunits.lua').AAirFactoryUnit
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
--------------------------------------------------------------------------------
SAB0401 = Class(AAirFactoryUnit) {
    --------------------------------------------------------------------------------
    -- Function triggers
    --------------------------------------------------------------------------------
    ---------------------------------------

    --OpenState = State() {
    --    Retract = function(self)
    --        WaitTicks(25)
    --    end,
    --},

    OnCreate = function(self)
        AAirFactoryUnit.OnCreate(self)

        self.Satellites = {}
        self:ForkThread(self.PlatformRaisingThread)
    end,

    OnStopBeingBuilt = function(self)
        AAirFactoryUnit.OnStopBeingBuilt(self)
    end,

    AddSatellite = function(self, unit)
        table.insert(self.Satellites, unit)
    end,

    RemoveSatellite = function(self, unit)
        table.removeByValue(self.Satellites, unit)
    end,

    GetNumSatellites = function(self)
        return table.getn(self.Satellites)
    end,

    KillAllSatellites = function(self)
        if not table.empty(self.Satellites) then
            for k, v in self.Satellites do
                IssueClearCommands({ v })
                IssueKillSelf({ v })
            end
            self.Satellites = {}
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        local id = self:GetEntityId()
        if unitBeingBuilt:GetBlueprint().BlueprintId == 'broat2exgs' then
            if self:GetNumSatellites() >= 8 then
                FloatingEntityText(id, 'Достигнут предел количества юнитов')
                IssueStop({ self })
                IssueClearCommands({ self })
                return
            end
            self:AddSatellite(unitBeingBuilt)
            unitBeingBuilt.Parent = self
        end
        AAirFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        if unitBeingBuilt:GetBlueprint().BlueprintId == 'broat2exgs' then
            if self:GetNumSatellites() > 8 then
                IssueStop({ self })
                IssueClearCommands({ self }) -- This clears the State launch procedure for some reason, leading to the following hack
                return
            end
        end
        AAirFactoryUnit.OnStopBuild(self, unitBeingBuilt)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self:KillAllSatellites()

        self:SetActiveConsumptionInactive()
        AAirFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroy = function(self)
        self:KillAllSatellites()
        AAirFactoryUnit.OnDestroy(self)
    end,

    OnCaptured = function(self, captor)
        if self and not self.Dead and captor and not captor.Dead and self:GetAIBrain() ~= captor:GetAIBrain() then
            local captorArmyIndex = captor.Army

            -- Disable unit cap for campaigns
            if ScenarioInfo.CampaignMode then
                SetIgnoreArmyUnitCap(captorArmyIndex, true)
            end

            -- Shift the two units to the new army and assign relationship
            local factory = ChangeUnitArmy(self, captorArmyIndex)
            if not factory then
                return
            end
            factory.Satellites = {}
            if not table.empty(self.Satellites) then
                for k, v in self.Satellites do
                    local sat = ChangeUnitArmy(v, captorArmyIndex)
                    if not sat then
                        continue
                    end
                    sat.Parent = factory
                    factory:AddSatellite(sat)
                end
            end

            -- Reapply unit cap checks
            local captorBrain = captor:GetAIBrain()
            if ScenarioInfo.CampaignMode and not captorBrain.IgnoreArmyCaps then
                SetIgnoreArmyUnitCap(captorArmyIndex, false)
            end
        end
    end,

    PlatformRaisingThread = function(self)
        local id = self:GetEntityId()
        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
        local pSlider = CreateSlider(self, 'Platform', 0, 0, 0, 10)
        local bRotator = CreateRotator(self, 'Builder_Node', 'y', 0, 1000, 100, 1000)
        local nSliders = {}
        for i = 1, 8 do
            nSliders[i] = CreateSlider(self, 'Builder_00' .. i, 0, 0, 0, 50)
        end
        local pMaxHeight = 25

        local unitBeingBuilt
        local buildState = 'start'
        local uBBF = 0
        local pSliderPos = 0
        local bSliderPos
        while self do
            unitBeingBuilt = self:GetFocusUnit()
            if unitBeingBuilt then
                if buildState == 'start' or
                    buildState == 'active' and EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                    --	uBBF = math.max(unitBeingBuilt:GetFractionComplete() - 0.8, 0) * 5
                    uBBF = math.max(unitBeingBuilt:GetFractionComplete(), 0)
                    buildState = 'active'
                elseif EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                    uBBF = 1
                else
                    --	uBBF = math.max(unitBeingBuilt:GetFractionComplete() - 0.8, 0) * 5
                    uBBF = 0
                end
                pSliderPos = uBBF * pMaxHeight
                if math.random(1, 15) == 10 then
                    --	bRotator:SetGoal(math.random(1,3) * 22.5 - 22.5 )
                    for i, slider in nSliders do
                        if math.random(1, 8) ~= 8 then
                            bSliderPos = pMaxHeight * RandomFloat(0, 1) * ((1 - uBBF) * .75)
                            slider:SetGoal(0, bSliderPos, 0)
                        end
                    end
                end
            else
                --    WaitTicks(1) -- If there is something building after 3 ticks, then assume inf build and stay up.
                if (buildState == 'active' or buildState == 'repeat') and self:GetFocusUnit() then
                    buildState = 'repeat'
                else
                    buildState = 'start'
                    pSliderPos = 0
                end
            end
            pSlider:SetGoal(0, pSliderPos, 0)
            WaitTicks(1)
            --	FloatingEntityText(id, 'pSliderPos =' .. pSliderPos)
        end
    end,
}

TypeClass = SAB0401
