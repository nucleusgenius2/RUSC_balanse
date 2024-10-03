local CommandUnit = import("/lua/defaultunits.lua").CommandUnit
local SWeapons = import("/lua/seraphimweapons.lua")
local Buff = import("/lua/sim/buff.lua")
local SCUDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
local EffectUtil = import("/lua/effectutilities.lua")
local SDFLightChronotronCannonWeapon = SWeapons.SDFLightChronotronCannonWeapon
local SDFOverChargeWeapon = SWeapons.SDFLightChronotronCannonOverchargeWeapon
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher

---@class XSL03021 : CommandUnit
XSL03021 = ClassUnit(CommandUnit) {
    Weapons = {
        LightChronatronCannon = ClassWeapon(SDFLightChronotronCannonWeapon) {
            OnCreate = function(self)
                SDFLightChronotronCannonWeapon.OnCreate(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Electrobolter', 'x', nil, 100, 100, 100)
                    self.unit.Trash:Add(self.SpinManip)
                end
            end,
        },
        DeathWeapon = ClassWeapon(SCUDeathWeapon) {},
    },

    __init = function(self)
        CommandUnit.__init(self, 'LightChronatronCannon')
    end,

    OnCreate = function(self)
        CommandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()
        self:AddCommandCap('RULEUCC_Teleport')
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
        CommandUnit.StartBeingBuiltEffects(self, builder, layer)
        self.Trash:Add(ForkThread(EffectUtil.CreateSeraphimBuildThread, self, builder, self.OnBeingBuiltEffectsBag, 2))
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects(self, unitBeingBuilt, self.BuildEffectBones,
            self.BuildEffectsBag)
    end,
}

TypeClass = XSL03021
