#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0304/URB0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Quantum Gate
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CQuantumGateUnit = import('/lua/cybranunits.lua').CQuantumGateUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

URB03011 = Class(CQuantumGateUnit) {

    GateBones = {
        {
            'Gate02_Left_FX',
            'Gate02_Right_FX',
        },
    },
    
    GateEffects = {
        '/effects/emitters/cybran_gate_01_emit.bp',
        '/effects/emitters/cybran_gate_02_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CQuantumGateUnit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread( EffectUtil.CreateCybranQuantumGateEffect, self.GateBones[1][1], self.GateBones[1][2], self.Trash, 0.1 )
        self:ForkThread( EffectUtil.CreateCybranQuantumGateEffect, self.GateBones[1][1], self.GateBones[1][2], self.Trash, 0.6 )
        self:ForkThread( EffectUtil.CreateCybranQuantumGateEffect, self.GateBones[1][1], self.GateBones[1][2], self.Trash, 2.3 )
        
        local army = self:GetArmy()
        for kBonesSet,vBoneSet in self.GateBones do
            for kBone, vBone in vBoneSet do
                for kEffect, vEffect in self.GateEffects do
                    self.Trash:Add(CreateAttachedEmitter( self, vBone, army, vEffect))
                end
            end
        end            
    end,

}

TypeClass = URB03011