--------------------------------------------------------------------------------
-- Summary  :  Stargate Script
--------------------------------------------------------------------------------
local explosion = import('/lua/defaultexplosions.lua')
local SQuantumGateUnit = import('/lua/seraphimunits.lua').SQuantumGateUnit
local StargateDialing = import('/lua/StargateDialing.lua').StargateDialing
SQuantumGateUnit = StargateDialing(SQuantumGateUnit)

SSB5401 = Class(SQuantumGateUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        SQuantumGateUnit.OnStopBeingBuilt(self, builder, layer)

        local army = self:GetArmy()

        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):
            ScaleEmitter(0.7) -- glow
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):
            ScaleEmitter(0.7) -- plasma pillar
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):
            ScaleEmitter(0.7) -- darkening pillar
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):
            ScaleEmitter(0.7) -- ring outward dust/motion
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):
            ScaleEmitter(0.7) -- plasma pillar move
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):
            ScaleEmitter(0.7) -- darkening pillar move
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):
            ScaleEmitter(0.7) -- bright line at bottom / right side
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):
            ScaleEmitter(0.7) -- bright line at bottom / left side
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):
            ScaleEmitter(0.7) -- small flickery dots rising
        CreateAttachedEmitter(self, 'Effect01', army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):
            ScaleEmitter(0.7) -- distortion
        CreateAttachedEmitter(self, 'FX_07', army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7) -- top part glow
        CreateAttachedEmitter(self, 'FX_07', army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7) -- top part plasma
        CreateAttachedEmitter(self, 'FX_07', army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7) -- top part darkening
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):
            ScaleEmitter(0.7) -- glow
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):
            ScaleEmitter(0.7) -- plasma pillar
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):
            ScaleEmitter(0.7) -- darkening pillar
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):
            ScaleEmitter(0.7) -- ring outward dust/motion
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):
            ScaleEmitter(0.7) -- plasma pillar move
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):
            ScaleEmitter(0.7) -- darkening pillar move
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):
            ScaleEmitter(0.7) -- bright line at bottom / right side
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):
            ScaleEmitter(0.7) -- bright line at bottom / left side
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):
            ScaleEmitter(0.7) -- small flickery dots rising
        CreateAttachedEmitter(self, 'Effect03', army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):
            ScaleEmitter(0.7) -- distortion
        CreateAttachedEmitter(self, 'FX_14', army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7) -- top part glow
        CreateAttachedEmitter(self, 'FX_14', army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7) -- top part plasma
        CreateAttachedEmitter(self, 'FX_14', army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7) -- top part darkening
        self.GateEffectsBag = TrashBag()
    end,

    OnStartBuild = function(self, built, order)
        SQuantumGateUnit.OnStartBuild(self, built, order)
    end,

    OnStopBuild = function(self, built)
        SQuantumGateUnit.OnStopBuild(self, built)

        built:SetVeterancy(5)
    end,

    OnFailedToBuild = function(self)
        SQuantumGateUnit.OnFailedToBuild(self)
    end,

    EventHorizonToggle = function(self, value)
        if value then
            if self.GateEffectsBag then
                for k, v in self.GateEffectsBag do
                    v:Destroy()
                end
            end
            local army = self:GetArmy()

            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_08', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_09', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_10', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_11', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_12', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_13', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_01', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_02', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_03', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_04', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_05', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))
            table.insert(self.GateEffectsBag,
                CreateAttachedEmitter(self, 'FX_06', army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):
                ScaleEmitter(0.7))

        else
            explosion.CreateDefaultHitExplosionAtBone(self, 'Center', 5.0)
            for k, v in self.GateEffectsBag do
                v:Destroy()
            end
        end
    end,

}

TypeClass = SSB5401
