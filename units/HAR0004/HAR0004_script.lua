-----------------------------------------------------------------
-- File     :  /cdimage/units/XEB4309/XEB4309_script.lua
-- Author(s):  David Tomandl, Jessica St. Croix
-- Summary  :  UEF Radar Jammer Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TRadarUnit = import("/lua/terranunits.lua").TRadarUnit

HAR0004 = Class(TRadarUnit) {
    AntiTeleport = {
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    OnStopBeingBuilt = function(self, builder, layer)
        TRadarUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:DisableUnitIntel('unitScript', 'CloakField') -- Used to show anti-tele range
        self.antiteleportEmitterTable = {}
        self.AntiTeleportBag = {}
    end,

    GetAntiTeleActive = function(self)
        return self.AntiTeleActive
    end,

    OnIntelDisabled = function(self, intel)
        TRadarUnit.OnIntelDisabled(self, intel)
        self.AntiTeleActive = false
        self:ForkThread(self.KillantiteleportEmitter)
        if not self.Rotator1 then
            self.Rotator1 = CreateRotator(self, 'Spinner_Upper', 'y')
            self.Trash:Add(self.Rotator1)
        end
        self.Rotator1:SetTargetSpeed(0)
        self.Rotator1:SetAccel(30)
        if not self.Rotator2 then
            self.Rotator2 = CreateRotator(self, 'Spinner_middle', 'y')
            self.Trash:Add(self.Rotator2)
        end
        self.Rotator2:SetTargetSpeed(0)
        self.Rotator2:SetAccel(100)
        if not self.Rotator3 then
            self.Rotator3 = CreateRotator(self, 'Spinner_lower', 'y')
            self.Trash:Add(self.Rotator3)
        end
        self.Rotator3:SetTargetSpeed(0)
        self.Rotator3:SetAccel(30)
        if self.AntiTeleportBag then
            for k, v in self.AntiTeleportBag do
                v:Destroy()
            end
            self.AntiTeleportBag = {}
        end
    end,

    OnIntelEnabled = function(self, intel)
        TRadarUnit.OnIntelEnabled(self, intel)
        self.AntiTeleActive = true
        self:ForkThread(self.antiteleportEmitter)
        self:ForkThread(self.AntiteleportEffects)

        if not self.Rotator1 then
            self.Rotator1 = CreateRotator(self, 'Spinner_Upper', 'y')
            self.Trash:Add(self.Rotator1)
            self.Rotator1:SetAccel(30)
        end
        self.Rotator1:SetTargetSpeed(-70)
        if not self.Rotator2 then
            self.Rotator2 = CreateRotator(self, 'Spinner_middle', 'y')
            self.Trash:Add(self.Rotator2)
            self.Rotator2:SetAccel(100)
        end
        self.Rotator2:SetTargetSpeed(500)
        if not self.Rotator3 then
            self.Rotator3 = CreateRotator(self, 'Spinner_lower', 'y')
            self.Trash:Add(self.Rotator3)
            self.Rotator3:SetAccel(30)
        end
        self.Rotator3:SetTargetSpeed(-70)
    end,


    AntiteleportEffects = function(self)
        if self.AntiTeleportBag then
            for k, v in self.AntiTeleportBag do
                v:Destroy()
            end
            self.AntiTeleportBag = {}
        end
        for k, v in self.AntiTeleport do
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, -0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, 0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, -0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, 0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, 0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, -0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect05', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect05', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, 0.5, 0))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect06', self:GetArmy(), v):ScaleEmitter(0.1))
            table.insert(self.AntiTeleportBag,
                CreateAttachedEmitter(self, 'Effect06', self:GetArmy(), v):ScaleEmitter(0.1):OffsetEmitter(0, -0.5, 0))
        end
    end,

    antiteleportEmitter = function(self)
        if not self.Dead then
            WaitSeconds(0.5)
            if not self.Dead then
                -- Gets the platforms current orientation
                local platOrient = self:GetOrientation()

                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('XEB4309')

                -- Creates our antiteleportEmitter over the platform with a ranomly generated Orientation
                local antiteleportEmitter = CreateUnit('beb0003', self:GetArmy(), location[1], location[2], location[3],
                    platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')

                -- Adds the newly created antiteleportEmitter to the parent platforms antiteleportEmitter table
                table.insert(self.antiteleportEmitterTable, antiteleportEmitter)

                -- Sets the platform unit as the antiteleportEmitter parent
                antiteleportEmitter:SetParent(self, 'har0004')
                antiteleportEmitter:SetCreator(self)
                self.Trash:Add(antiteleportEmitter)
            end
        end
    end,

    KillantiteleportEmitter = function(self, instigator, type, overkillRatio)
        -- Small bit of table manipulation to sort thru all of the avalible rebulder bots and remove them after the platform is dead
        if table.getn({ self.antiteleportEmitterTable }) > 0 then
            for k, v in self.antiteleportEmitterTable do
                IssueClearCommands({ self.antiteleportEmitterTable[k] })
                IssueKillSelf({ self.antiteleportEmitterTable[k] })
            end
        end
    end,
}

TypeClass = HAR0004
