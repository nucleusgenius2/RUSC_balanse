local TQuantumGateUnit = import("/lua/terranunits.lua").TQuantumGateUnit
local VDist3 = VDist3
local Random = Random

local function OffSetVector(vec, value)
    return Vector(vec[1] + Random(-value, value), vec[2], vec[3] + Random(-value, value))
end

local teleportableCats = (categories.AIR + categories.LAND) * categories.MOBILE

---@class DialingData
---@field ActiveWormhole boolean
---@field WormholeThread thread?
---@field ConnectedGates StargateMultiDialing[]

---@generic T : Unit
---@param SuperClass Unit
---@return T
function StargateMultiDialing(SuperClass)



    ---@class StargateMultiDialing : Unit
    ---@field DialingData DialingData
    local cls = Class(SuperClass) {
        OnKilled = function(self, instigator, type, overkillRatio)
            self:CloseWormhole(true)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)
        end,

        OnDestroy = function(self)
            self:CloseWormhole(true)
            SuperClass.OnDestroy(self)
        end,

        OnScriptBitSet = function(self, bit)
            SuperClass.OnScriptBitSet(self, bit)
            if bit == 6 then
                self:CloseWormhole()
                self:SetScriptBit('RULEUTC_GenericToggle', false)
            end
        end,

        ---@param self StargateMultiDialing
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.DialingData = {
                ActiveWormhole = false,
                TargetGate = nil,
                WormholeThread = nil,
                ConnectedGates = {}
            }
        end,

        --#region ConnectedGates

        ---@param self StargateMultiDialing
        GetNumConnectedGates = function(self)
            return table.getn(self.DialingData.ConnectedGates)
        end,

        ---@param self StargateMultiDialing
        RemoveGate = function(self, gate)
            table.removeByValue(self.DialingData.ConnectedGates, gate)
        end,

        ---@param self StargateMultiDialing
        AddGate = function(self, gate)
            table.insert(self.DialingData.ConnectedGates, gate)
        end,

        ---@param self StargateMultiDialing
        ---@return StargateMultiDialing?
        GetConnectedGate = function(self)
            if self:GetNumConnectedGates() >= 1 then
                return self.DialingData.ConnectedGates[1]
            end
            return nil
        end,

        HasConnected = function(self, gate)
            return table.find(self.DialingData.ConnectedGates, gate)
        end,

        ---@param self StargateMultiDialing
        ClearGates = function(self)
            self.DialingData.ConnectedGates = {}
        end,

        --#endregion

        ---@param self StargateMultiDialing
        GateTeleportThread = function(self)
            local checkRadius = self.Blueprint.Defense.TeleCheckRadius or 20
            local position = self:GetPosition()
            local data = self.DialingData

            while not self.Dead do
                local connectedGate = self:GetConnectedGate()
                if not data.ActiveWormhole and connectedGate then
                    self:OpenWormhole(connectedGate, true)
                elseif connectedGate and data.ActiveWormhole then
                    if not connectedGate.Dead then
                        -- local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR +
                        --     categories.NUKE + categories.EXPERIMENTAL - categories.STARGATE, position, 4)

                        -- for i, v in units do
                        --     Warp(v, connectedGate:GetPosition())
                        --     CreateLightParticleIntel(self, -1, self:GetArmy(), 35, 10, 'glow_02', 'ramp_blue_13')
                        -- end

                        local guards = EntityCategoryFilterDown(teleportableCats, self:GetGuards())
                        for i, v in guards do
                            if VDist3(v:GetPosition(), position) <= checkRadius then
                                IssueToUnitClearCommands(v)
                                Warp(v, OffSetVector(connectedGate:GetPosition(), 4))
                                CreateLightParticleIntel(self, -1, self:GetArmy(), 35, 10, 'glow_02',
                                    'ramp_blue_13')
                            end
                        end
                    else
                        self:CloseWormhole(true)
                    end
                    WaitTicks(3)
                else
                    WaitTicks(5)
                end
            end
        end,

        ---@param self StargateMultiDialing
        ---@param builder any
        ---@param layer any
        OnStopBeingBuilt = function(self, builder, layer)
            self.Sync.Abilities = self.Blueprint.Abilities
            SuperClass.OnStopBeingBuilt(self, builder, layer)

            self.DialingData.WormholeThread = self:ForkThread(self.GateTeleportThread)
        end,

        ---@param self StargateMultiDialing
        OnTargetLocation = function(self, location)
            local aiBrain = self:GetAIBrain()
            local bp = self:GetBlueprint()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.DialingCostBase
            if not (have > need) then
                return
            end
            local targetarea = aiBrain:GetUnitsAroundPoint(categories.ueb0305, location, 10, "Ally")
            ---@type StargateMultiDialing
            local targetgate = targetarea[1]

            if targetgate --Check we have a target
                and targetgate ~= self --Check not trying to dial self
                and not self:HasConnected(targetgate)
                and targetgate.DialingData.WormholeThread --Check the target is built and ready
            then
                targetgate:AddGate(self)
                self:AddGate(targetgate)
                aiBrain:TakeResource('ENERGY', bp.Economy.DialingCostBase or 0)
            end
        end,

        ---@param self StargateMultiDialing
        ---@param other StargateMultiDialing
        ---@param primary boolean
        OpenWormhole = function(self, other, primary)
            if other and not other.Dead then
                if primary then
                    other:OpenWormhole(self, not primary)
                    self:AddToggleCap('RULEUTC_GenericToggle')
                    self:SetScriptBit('RULEUTC_GenericToggle', false)
                end
                if not self.DialingData.ActiveWormhole then
                    self.DialingData.ActiveWormhole = true
                    self:EventHorizonToggle(true)
                end
            end
        end,

        ---@param self StargateMultiDialing
        ---@param other StargateMultiDialing
        CloseConnection = function(self, other)
            self:RemoveGate(other)
            if self:GetNumConnectedGates() == 0 then
                self:EventHorizonToggle(false)
                self.DialingData.ActiveWormhole = false
            end
        end,

        ---@param self StargateMultiDialing
        CloseWormhole = function(self, force)
            for _, gate in self.DialingData.ConnectedGates do
                gate:CloseConnection(self)
            end
            self:ClearGates()
            self:EventHorizonToggle(false)
            self.DialingData.ActiveWormhole = false
        end,

        EventHorizonToggle = function(self, value)
        end,
    }
    return cls
end

TQuantumGateUnit = StargateMultiDialing(TQuantumGateUnit)

---@class UEB0305 : TQuantumGateUnit
UEB0305 = ClassUnit(TQuantumGateUnit) {
    GateEffectVerticalOffset = 0.35,
    GateEffectScale = 0.55,

    OnStopBeingBuilt = function(self, builder, layer)
        self.Effects = TrashBag()
        TQuantumGateUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    OnDestroy = function(self)
        TQuantumGateUnit.OnDestroy(self)
        self.Effects:Destroy()
    end,

    EventHorizonToggle = function(self, value)
        if value then
            local effect = import("/lua/sim/entity.lua").Entity()
            effect = import("/lua/sim/entity.lua").Entity()
            effect:AttachBoneTo(-1, self, 'UEB0304')
            effect:SetMesh('/effects/entities/ForceField01/ForceField01_mesh')
            effect:SetDrawScale(self.GateEffectScale)
            effect:SetParentOffset(Vector(0, 0, self.GateEffectVerticalOffset))
            effect:SetVizToAllies('Intel')
            effect:SetVizToNeutrals('Intel')
            effect:SetVizToEnemies('Intel')

            self.Effects:Add(effect)
            self.Effects:Add(CreateAttachedEmitter(self, 'Left_Gate_FX', self.Army,
                '/effects/emitters/terran_gate_01_emit.bp'):ScaleEmitter(1.3))
            self.Effects:Add(CreateAttachedEmitter(self, 'Right_Gate_FX', self.Army,
                '/effects/emitters/terran_gate_01_emit.bp'):ScaleEmitter(1.3))
        else
            for _, effect in self.Effects do
                effect:Destroy()
            end
        end
    end,
}

TypeClass = UEB0305
