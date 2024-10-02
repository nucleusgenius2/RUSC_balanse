local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')

local TDFIonizedPlasmaCannon = WeaponsFile.TDFIonizedPlasmaCannon
local TAALinkedRailgun = WeaponsFile.TAALinkedRailgun

local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon

local TDFRiotWeapon = WeaponsFile.TDFRiotWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')

local EffectUtil = import('/lua/EffectUtilities.lua')
local CreateUEFBuildSliceBeams = EffectUtil.CreateUEFBuildSliceBeams

UELEW0003 = Class(TLandUnit) {
    SwitchAnims = true,
    IsWaiting = false,

    Weapons = {
        PlasmaCannon01 = Class(TDFIonizedPlasmaCannon) {},
        DroiteAAGun = Class(TAALinkedRailgun) {},
        GaucheAAGun = Class(TAALinkedRailgun) {},
        ArriereGaucheAAGun = Class(TAALinkedRailgun) {},
        ArriereDroitAAGun = Class(TAALinkedRailgun) {},

        TourelleAvantDroite = Class(TDFGaussCannonWeapon) {},
        TourelleAvantGauche = Class(TDFGaussCannonWeapon) {},
        TourelleArriereDroite = Class(TDFGaussCannonWeapon) {},
        TourelleArriereGauche = Class(TDFGaussCannonWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetGunsEnabled(false)
    end,

    GetAntiTeleActive = function(self) return true end,

    SetGunsEnabled = function(self, state)
        self:SetWeaponEnabledByLabel('TourelleAvantDroite', state)
        self:SetWeaponEnabledByLabel('TourelleAvantGauche', state)
        self:SetWeaponEnabledByLabel('TourelleArriereDroite', state)
        self:SetWeaponEnabledByLabel('TourelleArriereGauche', state)
    end,

    TransformThread = function(self, land)
        if (not self.AnimManip) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = bp.Display.UniformScale or 1

        if (land) then
            self:SetImmobile(true)
            self:SetSpeedMult(0)

            self.AnimManip:PlayAnim(bp.Display.AnimationTransform)
            self.AnimManip:SetRate(1)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            self.IsWaiting = false
            self.Trash:Add(self.AnimManip)
            self:SetGunsEnabled(true)
            self.SwitchAnims = true
        else
            self:SetImmobile(true)
            self:SetGunsEnabled(false)
            self.AnimManip:PlayAnim(bp.Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-1)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            self.IsWaiting = false
            self:SetSpeedMult(1)
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
        end
    end,

    CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'AdvancedOmniSensors' then
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 57)
        elseif enh == 'AdvancedOmniSensorsRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 47)
        end
    end,


    OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        local bp = self:GetBlueprint()
        if bit == 1 and not self.IsWaiting then
            self.AT1 = self:ForkThread(self.TransformThread, true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 and not self.IsWaiting then
            self.AT1 = self:ForkThread(self.TransformThread, false)
        end
    end,

}

TypeClass = UELEW0003
