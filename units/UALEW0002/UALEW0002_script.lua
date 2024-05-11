-- #****************************************************************************
-- #**
-- #**  File     :  /Mods/units/UALEW0002/UALEW0002_script.lua
-- #**
-- #**
-- #**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- #****************************************************************************

local AShieldHoverLandUnit = import('/lua/aeonunits.lua').AShieldHoverLandUnit

local utilities = import('/lua/utilities.lua')
local explosion = import('/lua/defaultexplosions.lua')
local FxAmbient = import('/lua/effecttemplates.lua').AT2PowerAmbient

UALEW0002 = Class(AShieldHoverLandUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        AShieldHoverLandUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Object07', 'z', nil, 180, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Object01', 'y', nil, 360, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Object02', 'x', nil, 360, 0, 180))

        for k, v in FxAmbient do
            CreateAttachedEmitter(self, 'Object02', self:GetArmy(), v)
        end

    end,

    OnLayerChange = function(self, new, old)
        AShieldHoverLandUnit.OnLayerChange(self, new, old)
        if new == 'Seabed' then
            self:EnableIntel('WaterVision')
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:DisableShield()
        elseif new == 'Land' then
            self:DisableIntel('WaterVision')
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:EnableShield()
        end
    end,

    OnCreate = function(self)
        AShieldHoverLandUnit.OnCreate(self)
        self:SetMaintenanceConsumptionActive()
    end,


}

TypeClass = UALEW0002
