-----------------------------------------------------------------
-- File     :  /cdimage/units/XRB4309/XRB4309_script.lua
-- Author(s):  David Tomandl, Greg Kohne
-- Summary  :  Cybran Shield Generator lvl 5 Script
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TRadarUnit = import("/lua/terranunits.lua").TRadarUnit

---@class HAR0007 : TRadarUnit
HAR0007 = Class(TRadarUnit) {
    OnCreate = function(self)
        TRadarUnit.OnCreate(self)
        self.ExtractionAnimManip = CreateAnimator(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TRadarUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:DisableUnitIntel('unitScript', 'CloakField') -- Used to show anti-tele range
        self.antiteleportEmitterTable = {}
        self.AntiTeleActive = true
    end,

    ---@param self HAR0007
    OnIntelDisabled = function(self, intel)
        TRadarUnit.OnIntelDisabled(self, intel)
        self.AntiTeleActive = false
        if self.Rotator1 then
            self.Rotator1:SetTargetSpeed(0)
        end
        self:ForkThread(self.KillantiteleportEmitter)
    end,

    ---@param self HAR0007
    OnIntelEnabled = function(self, intel)
        TRadarUnit.OnIntelEnabled(self, intel)
        self.AntiTeleActive = true
        if (not self.Rotator1) then
            self.Rotator1 = CreateRotator(self, 'Shaft', 'y')
            self.Trash:Add(self.Rotator1)
            self.Rotator1:SetAccel(30)
        end
        self.Rotator1:SetTargetSpeed(30)
        self:ForkThread(self.antiteleportEmitter)
    end,

    GetAntiTeleActive = function(self)
        return self.AntiTeleActive
    end,

    antiteleportEmitter = function(self)
        if not self.Dead then
            WaitSeconds(0.5)
            if not self.Dead then
                local platOrient = self:GetOrientation()
                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('Shaft')

                -- Creates our antiteleportEmitter over the platform with a ranomly generated Orientation
                local antiteleportEmitter = CreateUnit('brb0006', self:GetArmy(),
                    location[1], location[2], location[3],
                    platOrient[1], platOrient[2], platOrient[3], platOrient[4],
                    'Land')

                -- Adds the newly created antiteleportEmitter to the parent platforms antiteleportEmitter table
                table.insert(self.antiteleportEmitterTable, antiteleportEmitter)

                antiteleportEmitter:AttachTo(self, 'Shaft')

                -- Sets the platform unit as the antiteleportEmitter parent
                antiteleportEmitter:SetParent(self, 'har0007')
                antiteleportEmitter:SetCreator(self)
                self.Trash:Add(antiteleportEmitter)
            end
        end
    end,


    KillantiteleportEmitter = function(self, instigator, type, overkillRatio)
        -- Small bit of table manipulation to sort thru all of the avalible rebulder bots and remove them after the platform is dead
        if not table.empty({ self.antiteleportEmitterTable }) then
            for k, v in self.antiteleportEmitterTable do
                IssueClearCommands({ self.antiteleportEmitterTable[k] })
                IssueKillSelf({ self.antiteleportEmitterTable[k] })
            end
        end
    end,
}

TypeClass = HAR0007
