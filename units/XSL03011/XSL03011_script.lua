--****************************************************************************
--**
--**  File     :  /data/units/XAA0305/XAA0305_script.lua
--**  Author(s):  Jessica St. Croix
--**
--**  Summary  :  Aeon AA Gunship Script
--**
--**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local SConstructionUnit = import("/lua/seraphimunits.lua").SConstructionUnit
local EffectUtil = import('/lua/EffectUtilities.lua')
local EmitterBasePath = '/effects/emitters/'
local Shield = import("/lua/shield.lua").Shield
local Buff = import("/lua/sim/buff.lua")
local explosion = import("/lua/defaultexplosions.lua")

---@class XSL0309 : SConstructionUnit
--LED0026 = Class(SAirUnit) {
XSL03011 = ClassUnit(SConstructionUnit) {

    EngineRotateBones = { 'Jet_Front', 'Jet_Back', },

    BeamExhaustIdle = '/effects/emitters/air_idle_trail_beam_01_emit.bp',
    BeamExhaustCruise = '/effects/emitters/air_idle_trail_beam_01_emit.bp',

    StartBeingBuiltEffects = function(self, builder, layer)
        SConstructionUnit.StartBeingBuiltEffects(self, builder, layer)
        self:ForkThread(EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        self.EngineManipulators = {}
        self:AddCommandCap('RULEUCC_Teleport')
        self:SetMaintenanceConsumptionInactive()

        -- create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        -- set up the thursting arcs for the engines
        for key, value in self.EngineManipulators do
            --                       XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam(-0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0, 0.25)
        end

        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end

        CreateAttachedEmitter(self, 'Exhaust_Front01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_05_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_06_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_07_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_08_emit.bp')

        CreateAttachedEmitter(self, 'Exhaust_Front02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_05_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_06_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_07_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Front02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_08_emit.bp')

        CreateAttachedEmitter(self, 'Exhaust_Back01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_05_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_06_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_07_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back01', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_08_emit.bp')

        CreateAttachedEmitter(self, 'Exhaust_Back02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_05_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_06_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_07_emit.bp')
        CreateAttachedEmitter(self, 'Exhaust_Back02', self:GetArmy(),
            EmitterBasePath .. 'seraphim_ohwalli_strategic_flight_fxtrails_08_emit.bp')
        ChangeState(self, self.IdleState)
    end,

    FxDamageScale = 2.5,

    -- Enhancements
    CreateEnhancement = function(self, enh)
        SConstructionUnit.CreateEnhancement(self, enh)
        local bp = self.Blueprint.Enhancements[enh]
        if not bp then return end
        if enh == 'Shield' then
            IssueStop({ self })
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:CreateShield(bp)
        elseif enh == 'ShieldRemove' then
            IssueStop({ self })
            RemoveUnitEnhancement(self, 'Shield')
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()

        SConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnAnimTerrainCollision = function(self, bone, x, y, z)
        local position = { x, y, z }
        DamageArea(self, position, 5, 1000, 'Default', true, false)
        DamageArea(self, position, 5, 1, 'TreeForce', false)
        explosion.CreateDefaultHitExplosionAtBone(self, bone, 5.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), { self:GetUnitSizes() })
    end,

    ---@param self Unit
    ---@param target Unit | Prop
    OnStartReclaim = function(self, target)
        if target.IsProp
            or target.Army == self.Army
            or EntityCategoryContains(categories.STRUCTURE, target)
        then
            return SConstructionUnit.OnStartReclaim(self, target)
        end

        IssueClearCommands({ self })
    end,
}

TypeClass = XSL03011
