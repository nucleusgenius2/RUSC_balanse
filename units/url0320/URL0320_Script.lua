#****************************************************************************
#**
#**  File     :  /units/URL0320/URL0320_script.*
#**  Author(s):  Asdrubaelvect
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#****************************************************************************

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit

local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFHeavyDisintegratorWeapon = CybranWeaponsFile.CDFHeavyDisintegratorWeapon
local CAAMissileNaniteWeapon = CybranWeaponsFile.CAAMissileNaniteWeapon
local CDFElectronBolterWeapon = CybranWeaponsFile.CDFElectronBolterWeapon

local WeaponsFile = import ('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGeneratorCom02 = WeaponsFile.CDFHeavyMicrowaveLaserGeneratorCom02


URL0320 = Class(CWalkingLandUnit) {
    Weapons = {
		MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom02) {
		},
		Disintigrator01 = Class(CDFHeavyDisintegratorWeapon) {
		},
		Disintigrator02 = Class(CAAMissileNaniteWeapon) {
		},		
		HeavyBolterI = Class(CDFElectronBolterWeapon) {
		},
		HeavyBolterII = Class(CDFElectronBolterWeapon) {
		},
    },
	
    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'Object06',
                },
                Scale = 3.0,
                Type = 'Cloak01',
            },
        },
    },	
	
    AmbientExhaustBones = {
        'Object06',
    },

    AmbientLandExhaustEffects = {
        '/effects/emitters/cannon_muzzle_smoke_12_emit.bp',
    },	
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
        self:EnableIntel('Cloak')
    end,	

    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		
        self.EffectsBagXRL = TrashBag()
        self.AmbientExhaustEffectsBagXRL = TrashBag()
        self:CreateTerrainTypeEffects(self.IntelEffects.Cloak, 'FXIdle', self.Layer, nil, self.EffectsBag)
        self.Trash:Add(ForkThread(self.HideUnit, self))
    end,

    HideUnit = function(self)
        WaitTicks(1)
        self:SetMesh(self.Blueprint.Display.CloakMeshBlueprint, true)
    end,
	
    OnKilled = function(self, instigator, type, overkillRatio)
        local emp = self:GetWeaponByLabel('EMP')
        local bp
        for k, v in self:GetBlueprint().Buffs do
            if v.Add.OnDeath then
                bp = v
            end
        end
        #if we could find a blueprint with v.Add.OnDeath, then add the buff 
        if bp != nil then 
            #Apply Buff
			self:AddBuff(bp)
        end
        #otherwise, we should finish killing the unit
           
		if self.UnitComplete then
            # Play EMP Effect
            CreateLightParticle( self, -1, -1, 24, 62, 'flare_lens_add_02', 'ramp_red_10' )
            # Fire EMP weapon
            emp:SetWeaponEnabled(true)
            emp:OnFire()
        end
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,	
	
}
TypeClass = URL0320
