#****************************************************************************
#**
#**  File     :  /cdimage/units/XSB0304/XSB0304_script.lua
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  Seraphim Sub Commander Gateway Unit Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SQuantumGateUnit = import("/lua/seraphimunits.lua").SQuantumGateUnit

local SSeraphimSubCommanderGateway01 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway01
local SSeraphimSubCommanderGateway02 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway02
local SSeraphimSubCommanderGateway03 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway03

LED0006 = ClassUnit(SQuantumGateUnit) {

    RollOffBones = { 'Pod01',},

    
    OnCreate = function(self)
        SQuantumGateUnit.OnCreate(self)
        self.Rotator1 = CreateRotator(self, 'Pod01', 'y', nil, 5, 0, 0)
        self.Trash:Add(self.Rotator1)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Rotator1:SetSpeed(0)
        SQuantumGateUnit.OnKilled(self, instigator, type, overkillRatio)
    end,



    OnStopBeingBuilt = function(self,builder,layer)
        ###Place emitters at the center of the gateway.
        for k, v in SSeraphimSubCommanderGateway01 do
            CreateAttachedEmitter(self, 'Attachpoint', self:GetArmy(), v)
        end
        
        ###Place emitters on certain light bones on the mesh.
        for k, v in SSeraphimSubCommanderGateway02 do
            CreateAttachedEmitter(self, 'Light04', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light05', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light06', self:GetArmy(), v)
        end
        
        ###Place emitters on certain OTHER light bones on the mesh.
        for k, v in SSeraphimSubCommanderGateway03 do
            CreateAttachedEmitter(self, 'Light01', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light02', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light03', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light07', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light08', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light09', self:GetArmy(), v)
        end

        SQuantumGateUnit.OnStopBeingBuilt(self, builder, layer)
	
    end,
	
    OnStopBuild = function(self, unitBeingBuilt)
		pos = self:GetPosition('Pod02')
		unitBeingBuilt:SetPosition(pos, true)
		SQuantumGateUnit.OnStopBuild(self, unitBeingBuilt)
    end,
	
}

TypeClass = LED0006