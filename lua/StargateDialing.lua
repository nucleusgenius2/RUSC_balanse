--------------------------------------------------------------------------------
-- Summary  :  Stargate Dialing Script
-- Author   :  Balthazar
--------------------------------------------------------------------------------
local VDist3 = VDist3
local Random = Random

local function RandomRange(value)
    return (Random() * 2 - 1) * value
end

local function OffSetVector(vec, value)
    return Vector(vec[1] + RandomRange(value), vec[2], vec[3] + RandomRange(value))
end


function StargateDialing(SuperClass)
    return Class(SuperClass) {

        ------------------------------------------------------------------------
        -- Main function callbacks
        ------------------------------------------------------------------------

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

        OnCollisionCheck = function(self, other, firingWeapon)
            --local hit = SuperClass.OnCollisionCheck(self, other, firingWeapon)
            if self.DialingData.ActiveWormhole then
                local oPos = other:GetPosition()
                local sPos = self:GetPosition() --z inverted so projectiles appear opposite side.
                local rPos = { oPos[1] - sPos[1], oPos[2] - sPos[2], sPos[3] - oPos[3] }
                local tPos = self.DialingData.TargetGate:GetPosition()
                Warp(other, { sPos[1], sPos[2] - 50, sPos[3] }) --Route the projectile underground.
                Warp(other, { tPos[1], tPos[2] - 50, tPos[3] }) --Prevents poly-trails being visible between the two warp points.
                Warp(other, self.DialingData.TargetGate:CalculateWorldPositionFromRelative(rPos))
                return false
            else
                return SuperClass.OnCollisionCheck(self, other, firingWeapon)
            end
        end,

        ------------------------------------------------------------------------
        -- Innitialisation
        ------------------------------------------------------------------------
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.DialingData = {
                ActiveWormhole = false,
                IncomingWormhole = false,
                --Iris = false,
                TargetGate = nil,
                WormholeThread = nil,
                --DisableCounter = 0,
                DialingSequence = self:DialingSequence(self),
                DialingHome = math.mod(self:GetEntityId() or 1, 9),
                CurrentPosition = 9,
            }
        end,

        ---@param self Unit
        ---@param builder any
        ---@param layer any
        OnStopBeingBuilt = function(self, builder, layer)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            --self:RemoveToggleCap('RULEUTC_GenericToggle')
            SuperClass.OnStopBeingBuilt(self, builder, layer)
            local checkRadius = self.Blueprint.Defense.TeleCheckRadius or 20
            local position = self:GetPosition()


            self.DialingData.WormholeThread = self:ForkThread(
                function()
                    while true do
                        if not self.DialingData.ActiveWormhole and self.DialingData.TargetGate then
                            self:DialingAnimation(self.DialingData.TargetGate)
                            self:OpenWormhole(self.DialingData.TargetGate, true)
                        elseif self.DialingData.TargetGate
                            and self.DialingData.ActiveWormhole
                            and not self.DialingData.IncomingWormhole
                        --and not self.DialingData.Iris
                        then
                            if not self.DialingData.TargetGate:IsDead() then
                                local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR +
                                    categories.NUKE + categories.EXPERIMENTAL - categories.STARGATE, self:GetPosition(),
                                    7)
                                local guards = EntityCategoryFilterDown(
                                    (categories.AIR + categories.LAND) * categories.MOBILE,
                                    self:GetGuards())
                                --local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR + categories.NUKE, self:GetPosition(), 4)
                                for i, v in units do
                                    Warp(v, self.DialingData.TargetGate:GetPosition())
                                    CreateLightParticleIntel(self, -1, self:GetArmy(), 35, 10, 'glow_02', 'ramp_blue_13')
                                end

                                for i, v in guards do
                                    if VDist3(v:GetPosition(), position) <= checkRadius then
                                        IssueToUnitClearCommands(v)
                                        Warp(v, OffSetVector(self.DialingData.TargetGate:GetPosition(), 7))
                                        CreateLightParticleIntel(self, -1, self:GetArmy(), 35, 10, 'glow_02',
                                            'ramp_blue_13')
                                    end
                                end
                            elseif self.DialingData.TargetGate:IsDead() then
                                self:CloseWormhole(true)
                            end
                            WaitTicks(3)
                        else
                            WaitTicks(5)
                        end
                    end
                end
            )
        end,

        ------------------------------------------------------------------------
        -- Activation
        ------------------------------------------------------------------------
        OnTargetLocation = function(self, location)
            local aiBrain = self:GetAIBrain()
            local bp = self:GetBlueprint()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.DialingCostBase
            if not (have > need) or self.DialingData.IncomingWormhole then
                return
            end
            local targetarea = aiBrain:GetUnitsAroundPoint(categories.STARGATE, location, 10)
            --if table.getn(targetarea) > 1 then
            --sort by distance here
            local targetgate = targetarea[1]
            --end

            if targetgate --Check we have a target
                and targetgate ~= self --Check not trying to dial self
                and targetgate ~= self.DialingData.TargetGate --Check not redialing the same gate
                and targetgate.DialingData.WormholeThread --Check the target is built and ready
                and not targetgate.DialingData.ActiveWormhole --Check the target isn't already dialing out
                and not targetgate.DialingData.IncomingWormhole --Check the target isn't already being dialed into
                and not targetgate.DialingData.OutgoingWormhole --Check the target isn't currently dialing out
                and not self.DialingData.IncomingWormhole --Check we don't have incoming
            then
                if self.DialingData.OutgoingWormhole then
                    self:CloseWormhole(true)
                end
                targetgate.DialingData.IncomingWormhole = true
                self.DialingData.TargetGate = targetgate
                self.DialingData.OutgoingWormhole = true
                aiBrain:TakeResource('ENERGY', bp.Economy.DialingCostBase or 0)
                --LOG("CHEVRON 7 LOCKED")
            else
                --LOG("CHEVRON 7 ... WONT ENGAGE")
            end
        end,

        ------------------------------------------------------------------------
        -- Event Horizon functions
        ------------------------------------------------------------------------
        OpenWormhole = function(self, other, primary)
            --FloatingEntityText(self:GetEntityId(),tostring(primary) )
            if other and not other:IsDead() then
                if primary then
                    other:OpenWormhole(self, not primary)
                    self:AddToggleCap('RULEUTC_GenericToggle')
                    self:SetScriptBit('RULEUTC_GenericToggle', false)
                    --Disable shield whilst dialing out. Can't leave else.
                    --self:DisableShield()
                end
                self.DialingData.TargetGate = other
                self.DialingData.ActiveWormhole = true
                self.DialingData.IncomingWormhole = not primary
                self:EventHorizonToggle(true)
            end
        end,

        CloseWormhole = function(self, force)
            --            if not self.DialingData.IncomingWormhole or force then
            if self.DialingData.TargetGate and not self.DialingData.TargetGate:IsDead() then
                local other = self.DialingData.TargetGate
                self.DialingData.TargetGate.DialingData.TargetGate = nil
                other:CloseWormhole(true)
            end
            self:EventHorizonToggle(false)
            --self:RemoveToggleCap('RULEUTC_GenericToggle')
            self.DialingData.ActiveWormhole = false
            self.DialingData.IncomingWormhole = false
            self.DialingData.OutgoingWormhole = false
            self.DialingData.TargetGate = nil
            --            end
        end,


        ------------------------------------------------------------------------
        -- Animations and effects
        ------------------------------------------------------------------------
        DialingSequence = function(self, target)
            local targetPos = target:GetPosition()
            local Chevrons = {
                math.ceil((targetPos[1] * 9) / ScenarioInfo.size[1]),
                math.ceil((targetPos[3] * 9) / ScenarioInfo.size[2]),
                math.ceil(math.mod(targetPos[1] * 81, ScenarioInfo.size[1] * 9) / ScenarioInfo.size[1]),
                math.ceil(math.mod(targetPos[3] * 81, ScenarioInfo.size[2] * 9) / ScenarioInfo.size[2]),
            }
            return Chevrons
        end,

        DialingAnimation = function(self, target, reset)
            --------------------------------------------------------------------
            -- Error protection (Should never trigger)
            --------------------------------------------------------------------
            if not target then target = self end
            if not target.DialingData.DialingSequence then target.DialingData.DialingSequence = self:DialingSequence(target) end
            if not self.DialingData.DialingHome then self.DialingData.DialingHome = math.mod(self:GetEntityId() or 1, 9) end
            --------------------------------------------------------------------
            -- First time triggers
            --------------------------------------------------------------------
            --            if not self.DailingAnimation then self.DailingAnimation = CreateRotator(self, 'Ring', 'z') end
            --            if target ~= self and not target.DailingAnimation then target.DailingAnimation = CreateRotator(target, 'Ring', 'z') end
            --------------------------------------------------------------------
            -- Dial turn function
            --------------------------------------------------------------------
            local Dial = function(manipulator, values)
                local index = values[1]
                local Chevron = values[2]
                local prevChe = values[3]
                local sign = -1 + (2 * math.mod(index, 2))

                --manipulator:SetAccel(40 )-- * Chevron)
                --manipulator:SetTargetSpeed(100 * 5)-- * Chevron)
                --manipulator:SetGoal(Chevron * 40)
                --manipulator:SetSpeed(30 )-- * Chevron)
            end
            --------------------------------------------------------------------
            -- Load sequence
            --------------------------------------------------------------------
            local Chevrons = target.DialingData.DialingSequence
            table.insert(Chevrons, self.DialingData.DialingHome)
            --------------------------------------------------------------------
            -- Animation
            --------------------------------------------------------------------
            WaitTicks(7)
        end,

        EventHorizonToggle = function(self, value)

        end,
    }
end
