local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local AirTransport = import("/lua/defaultunits.lua").AirTransport
local Buff = import("/lua/sim/buff.lua")
local Shield = import("/lua/shield.lua").Shield


---@param unit Unit
---@param intelType any
local function EnableUnitIntel(unit, intelType)
    unit:EnableIntel(intelType)
    unit:OnIntelEnabled(intelType)
end

---@param unit Unit
---@param intelType any
local function DisableUnitIntel(unit, intelType)
    unit:DisableIntel(intelType)
    unit:OnIntelDisabled(intelType)
end

---@class url0301 : AirTransport
---@field IsCargoHidden boolean
url0301 = Class(AirTransport) {

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'URA0402',
                },
                Scale = 3.0,
                Type = 'Cloak02',
            },
        },
    },

    AmbientExhaustBones = {
        'URA0402',
    },

    AmbientLandExhaustEffects = {
        '/effects/emitters/cannon_muzzle_smoke_12_emit.bp',
    },
    OnCreate = function(self)
        AirTransport.OnCreate(self)
        self:CreateTerrainTypeEffects(self.IntelEffects.Cloak, 'FXIdle', self.Layer, nil, self.EffectsBag)
    end,
    ---@param self url0301
    ---@param builder any
    ---@param layer any
    OnStopBeingBuilt = function(self, builder, layer)
        AirTransport.OnStopBeingBuilt(self, builder, layer)
        self.AnimManip = CreateAnimator(self)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        self.Trash:Add(ForkThread(self.UpdateCloakEffect, self, true, "Cloak"))
        self:SetMaintenanceConsumptionActive()
        self.IsCargoHidden = true
    end,


    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    HideUnit = function(unit)
        EnableUnitIntel(unit, "RadarStealth")
        EnableUnitIntel(unit, "Cloak")
    end,

    ShowUnit = function(unit)
        DisableUnitIntel(unit, "RadarStealth")
        DisableUnitIntel(unit, "Cloak")
    end,

    ---@param self url0301
    HideCargo = function(self)
        local cargo = self:GetCargo()
        for _, unit in cargo do
            self.HideUnit(unit)
        end
        self.IsCargoHidden = true
    end,

    ---@param self url0301
    ShowCargo = function(self)
        local cargo = self:GetCargo()
        for _, unit in cargo do
            self.ShowUnit(unit)
        end
        self.IsCargoHidden = false
    end,

    ---@param self url0301
    OnEnergyDepleted = function(self)
        AirTransport.OnEnergyDepleted(self)
        self:ShowCargo()
    end,

    ---@param self url0301
    OnEnergyViable = function(self)
        AirTransport.OnEnergyViable(self)
        self:HideCargo()
    end,

    -- When a unit attaches or detaches, tell the shield about it.
    ---@param self url0301
    ---@param attachBone Bone
    ---@param unit Unit
    OnTransportAttach = function(self, attachBone, unit)
        AirTransport.OnTransportAttach(self, attachBone, unit)
        if self.IsCargoHidden then
            self.HideUnit(unit)
        end
    end,

    ---@param self url0301
    ---@param attachBone Bone
    ---@param unit Unit
    OnTransportDetach = function(self, attachBone, unit)
        AirTransport.OnTransportDetach(self, attachBone, unit)
        self.ShowUnit(unit)
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        if damageType == 'Nuke' or damageType == 'Deathnuke' then
            self.Shield:SetContentsVulnerable(true)
        end

        AirTransport.OnDamage(self, instigator, amount, vector, damageType)
    end,

    OnMotionVertEventChange = function(self, new, old)
        AirTransport.OnMotionVertEventChange(self, new, old)
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimManip:SetRate(-1)
        elseif (new == 'Down') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1)
        elseif (new == 'Up') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        end
    end,

    DeathThread = function(self, overkillRatio, instigator)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if self.ShowUnitDestructionDebris and overkillRatio then
            if overkillRatio <= 1 then
                self:CreateUnitDestructionDebris(true, true, false)
            elseif overkillRatio <= 2 then
                self:CreateUnitDestructionDebris(true, true, false)
            elseif overkillRatio <= 3 then
                self:CreateUnitDestructionDebris(true, true, true)
            else -- Vaporized
                self:CreateUnitDestructionDebris(true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

    -- Enhancements

    ---@param self url0301
    CreateEnhancement = function(self, enh)
        AirTransport.CreateEnhancement(self, enh)
        local bp = self.Blueprint.Enhancements[enh]
        if not bp then return end

        if enh == 'Shield' then
            self:DisableCloak()
            self:RemoveToggleCap('RULEUTC_CloakToggle')

            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:CreateShield(bp)
        elseif enh == 'ShieldRemove' then
            self:SetMaintenanceConsumptionInactive()
            RemoveUnitEnhancement(self, 'Shield')
            self:DestroyShield()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')

            self:AddToggleCap('RULEUTC_CloakToggle')
            self:EnableCloak()
        end
    end,

    ---@param self url0301
    EnableCloak = function(self)
        self:SetMaintenanceConsumptionActive()
        self:EnableIntel('Cloak')
        self:HideCargo()
    end,

    ---@param self url0301
    DisableCloak = function(self)
        self:SetMaintenanceConsumptionInactive()
        self:DisableIntel('Cloak')
        self:ShowCargo()
    end,

    ---@param self url0301
    OnScriptBitSet = function(self, bit)
        AirTransport.OnScriptBitSet(self, bit)

        if bit == 0 then
            self:OnShieldEnabled()
            self:RemoveToggleCap("RULEUTC_CloakToggle")
            self:UpdateCloakEffect(false, 'Cloak')
            self:DisableCloak()
        elseif bit == 8 then
            self:UpdateCloakEffect(false, 'Cloak')
            self:DisableCloak()
        end
    end,

    ---@param self url0301
    OnScriptBitClear = function(self, bit)
        AirTransport.OnScriptBitClear(self, bit)

        if bit == 0 then
            self:OnShieldDisabled()
            self:AddToggleCap('RULEUTC_CloakToggle')
            self:UpdateCloakEffect(true, 'Cloak')
            self:EnableCloak()
        elseif bit == 8 then
            self:UpdateCloakEffect(true, 'Cloak')
            self:EnableCloak()
        end

    end,
}

TypeClass = url0301
