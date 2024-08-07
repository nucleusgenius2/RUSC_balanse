-----------------------------------------------------------------
-- File     :  /cdimage/units/BAL0401/BAL0401_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Aeon Long Range Artillery Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local AAMWillOWisp = import('/lua/aeonweapons.lua').AAMWillOWisp
local WeaponsFile = import('/lua/BlackOpsWeapons.lua')
local explosion = import('/lua/defaultexplosions.lua')
local BlackOpsEffectTemplate = import('/lua/BlackOpsEffectTemplates.lua')
local RemoteViewing = import('/lua/RemoteViewing.lua').RemoteViewing
local Buff = import("/lua/sim/buff.lua")
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon
local SAMElectrumMissileDefense = import("/lua/seraphimweapons.lua").SAMElectrumMissileDefense
local EffectTemplate = import("/lua/effecttemplates.lua")
local WeakKeyMeta = { __mode = 'k' }

AStructureUnit = RemoteViewing(SWalkingLandUnit)

---@class UAL0405 : AStructureUnit
UAL0405 = Class(AStructureUnit) {
    FxMuzzleFlash = EffectTemplate.AChronoDampenerLarge,
    Weapons = {
        AntiMissile = ClassWeapon(AAMWillOWisp) {
            --    AntiMissile = ClassWeapon(SAMElectrumMissileDefense) {},
        },
        BoomWeapon = Class(CDFLaserHeavyWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(0)
                end

                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end

                if self.SpinManip3 then
                    self.SpinManip3:SetTargetSpeed(0)
                end
                CDFLaserHeavyWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip1 then
                    self.SpinManip1 = CreateRotator(self.unit, 'Spinner_1', 'y', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip1)
                end
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(200)
                end

                if not self.SpinManip2 then
                    self.SpinManip2 = CreateRotator(self.unit, 'Spinner_2', 'y', nil, -270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end

                if not self.SpinManip3 then
                    self.SpinManip3 = CreateRotator(self.unit, 'Spinner_3', 'y', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip3)
                end
                if self.SpinManip3 then
                    self.SpinManip3:SetTargetSpeed(300)
                end
                CDFLaserHeavyWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            CreateProjectileForWeapon = function(self, bone)
                local bp = self:GetBlueprint()
                local numProjectiles = 10
                local rangeNum = 5
                for i = 0, (numProjectiles - 1) do
                    WaitTicks(Random(5, 10))
                    local pos = self:GetCurrentTargetPos()
                    ranX = Random(-8, 8)
                    ranZ = Random(-8, 8)
                    pos.y = pos.y + 200 or 200
                    pos.x = pos.x + ranX
                    pos.z = pos.z + ranZ
                    local proj = CDFLaserHeavyWeapon.CreateProjectileForWeapon(self, bone)
                    Warp(proj, pos)
                    rangeNum = (rangeNum - 1)
                    self.unit:PlayUnitSound('WarpingProjectile')
                    CreateLightParticle(self.unit, 'Bombard', self.unit:GetArmy(), 5, 2, 'beam_white_01', 'ramp_white_07')
                    CreateAttachedEmitter(self.unit, 'Bombard', self.unit:GetArmy(),
                        '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp'):ScaleEmitter(0.08)
                end
            end,
        },
    },

    OnCreate = function(self)
        AStructureUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('AntiMissile', false)
        self:DisableRemoteViewingButtons()
        self.AntiTeleActive = false
    end,

    GetAntiTeleActive = function(self)
        return self.AntiTeleActive
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)
        --    self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'x', nil, 0, 100, 200))
        --    self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'y', nil, 0, 100, 200))
        --    self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'z', nil, 0, 100, 200))
        self.MaelstromEffects01 = {}
        if self.MaelstromEffects01 then
            for k, v in self.MaelstromEffects01 do
                v:Destroy()
            end
            self.MaelstromEffects01 = {}
        end
        table.insert(self.MaelstromEffects01,
            CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/effects/emitters/inqu_glow_effect03.bp'):
            ScaleEmitter(0.7)
            :OffsetEmitter(0, -2.1, 0))
        table.insert(self.MaelstromEffects01,
            CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/effects/emitters/inqu_glow_effect01.bp'):
            ScaleEmitter(3)
            :OffsetEmitter(0, 0, 0))
        table.insert(self.MaelstromEffects01,
            CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/effects/emitters/inqu_glow_effect02.bp'):
            ScaleEmitter(3)
            :OffsetEmitter(0, 0, 0))

        self.ShieldEffectsBag = {}
        self:SetWeaponEnabledByLabel('AntiMissile', false)
        self:ForkThread(self.Enhancement)
    end,


    ---@param self UAL0405
    ---@param category EntityCategory
    ApplyBuffToUnits = function(self, category, buffName, buffRadius, allyType)
        allyType = allyType or "Ally"
        local brain = self.Brain
        local all = brain:GetUnitsAroundPoint(category, self:GetPosition(), buffRadius, allyType)
        local units = {}

        for _, u in all do
            if not u.Dead and not u:IsBeingBuilt() then
                table.insert(units, u)
            end
        end
        for _, unit in units do
            Buff.ApplyBuff(unit, buffName)
            unit:RequestRefreshUI()
        end
        return not table.empty(units)
    end,

    ---@param self UAL0405
    Enhancement = function(self)
        local bpAura = self.Blueprint.Aura

        local auraRadius = bpAura.AuraRadius or 52
        local slowdownRadius = bpAura.SlowDownRadius or 62.4
        local maxDamageBuffStackLimit = bpAura.MaxDamageBuffStack or 5

        local RegenCeilingSCU = bpAura.RegenSCU
        local RegenCeilingT1 = bpAura.RegenT1
        local RegenCeilingT2 = bpAura.RegenT2
        local RegenCeilingT3 = bpAura.RegenT3
        local RegenCeilingT4 = bpAura.RegenT4
        local RegenFloor = 3
        local RegenPerSecond = 0.2

        -- Regenerative Aura
        local buff = 'RegAura'
        if not Buffs[buff] then
            BuffBlueprint {
                Name = buff,
                DisplayName = buff,
                BuffType = 'AURAFORALL',
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    Regen = {
                        Add = 0,
                        Mult = RegenPerSecond,
                        Floor = RegenFloor,
                        BPCeilings = {
                            TECH1 = RegenCeilingT1,
                            TECH2 = RegenCeilingT2,
                            TECH3 = RegenCeilingT3,
                            EXPERIMENTAL = RegenCeilingT4,
                            SUBCOMMANDER = RegenCeilingSCU,
                        },
                    },
                },
            }
        end

        -- HP Aura
        local buffHPAuraLandUnits = 'HPAuraLandUnits'
        if not Buffs[buffHPAuraLandUnits] then
            BuffBlueprint {
                Name = buffHPAuraLandUnits,
                DisplayName = buffHPAuraLandUnits,
                BuffType = 'AURAFORALL1',
                Stacks = 'REPLACE',
                Duration = 5,
                Effects = {},
                Affects = {
                    MaxHealth = {
                        Add = 0,
                        Mult = bpAura.HPLand,
                    }
                }
            }
        end

        -- HP Aura
        local buffHPAuraAeonExps = 'HPAuraAeonExps'
        if not Buffs[buffHPAuraAeonExps] then
            BuffBlueprint {
                Name = buffHPAuraAeonExps,
                DisplayName = buffHPAuraAeonExps,
                BuffType = 'AURAFORALL2',
                Stacks = 'REPLACE',
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    MaxHealth = {
                        Add = 0,
                        Mult = bpAura.HPExpAeon,
                    }
                }
            }
        end

        -- HP Aura
        local buffHPAuraExps = 'HPAuraNonAeonExps'
        if not Buffs[buffHPAuraExps] then
            BuffBlueprint {
                Name = buffHPAuraExps,
                DisplayName = buffHPAuraExps,
                BuffType = 'AURAFORALL2',
                Stacks = 'REPLACE',
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    MaxHealth = {
                        Add = 0,
                        Mult = bpAura.HPExp,
                    }
                }
            }
        end

        -- GC Range
        local buffRange = 'GCRangeBuff'
        if not Buffs[buffRange] then
            BuffBlueprint {
                Name = buffRange,
                DisplayName = buffRange,
                BuffType = 'AURAFORALL3',
                Stacks = 'REPLACE',
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    MaxRadius = {
                        Add = 0,
                        Mult = bpAura.GCRange,
                    }
                }
            }
        end

        local buffPreDamage = 'AeonExpPreDamage'
        if not Buffs[buffPreDamage] then
            BuffBlueprint {
                Name = buffPreDamage,
                DisplayName = buffPreDamage,
                BuffType = 'PREDAMAGEEFFECT',
                Stacks = 'IGNORE',
                Duration = 4.9,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {}
            }
        end

        local buffDamage = 'AeonExpDamage'
        if not Buffs[buffDamage] then
            BuffBlueprint {
                Name = buffDamage,
                DisplayName = buffDamage,
                BuffType = 'AURAFORALL5',
                Stacks = 'ALWAYS',
                BuffCheckFunction = function(buff, unit)
                    if Buff.HasBuff(unit, buffPreDamage) and
                        Buff.CountBuff(unit, buffDamage) < maxDamageBuffStackLimit - 1 then
                        return true
                    end
                    Buff.ApplyBuff(unit, buffPreDamage)
                    return false
                end,
                Duration = 5,
                Effects = { '/effects/emitters/seraphim_regenerative_aura_02_emit.bp' },
                Affects = {
                    Damage = {
                        Add = 0,
                        Mult = bpAura.DamageBuff,
                    }
                }
            }
        end

        local buffPreStun = 'PreStunEffect'
        if not Buffs[buffPreStun] then
            BuffBlueprint {
                Name = buffPreStun,
                DisplayName = buffPreStun,
                BuffType = 'PRESTUNEFFECT',
                Stacks = 'IGNORE',
                Duration = 4.9,
                Affects = {}
            }
        end

        local buffPostStun = 'PostStunEffect'
        if not Buffs[buffPostStun] then
            BuffBlueprint {
                Name = buffPostStun,
                DisplayName = buffPostStun,
                BuffType = 'POSTSTUNEFFECT',
                Stacks = 'IGNORE',
                Duration = bpAura.SlowDownBreak,
                Affects = {}
            }
        end

        local buffStun = 'StunEffect'
        if not Buffs[buffStun] then
            BuffBlueprint {
                Name = buffStun,
                DisplayName = buffStun,
                BuffType = 'STUNEFFECT',
                Stacks = 'IGNORE',
                Duration = bpAura.SlowDownDuration,
                BuffCheckFunction = function(buff, unit)
                    return not Buff.HasBuff(unit, buffPostStun)
                end,
                OnBuffRemove = function(buff, unit)
                    Buff.ApplyBuff(unit, buffPostStun)
                end,
                Effects = EffectTemplate.Aeon_HeavyDisruptorCannonMuzzleCharge,
                Affects = {
                    MoveMult = { Mult = 0.01 }
                }
            }
        end


        table.insert(self.ShieldEffectsBag,
            CreateAttachedEmitter(self, 'BAL0401', self.Army, '/effects/emitters/seraphim_regenerative_aura_01_emit.bp'))

        local mobileLandUnits = categories.MOBILE * categories.LAND
        local expUnits = categories.EXPERIMENTAL * categories.MOBILE - categories.NOHP
        local aeonExp = categories.AEON * expUnits
        local nonAeonExp = expUnits - aeonExp
        local mobileUnits = categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD +
            categories.BUILTBYTEXPFACTORY
            - categories.COMMAND
            - categories.OPTICS
            - categories.NOHP
        local nonExps = mobileUnits - expUnits
        local rangeBuffCat = categories.ual0401 + categories.ualew0003
        local inqusitorCat = categories.ual0405

        ---@type AIBrain
        local brain = self.Brain

        local CreateAttachedEmitter = CreateAttachedEmitter
        local WaitTicks             = WaitTicks

        WaitTicks(51 - math.mod(GetGameTick(), 50))

        while not self.Dead do
            local layer = self:GetCurrentLayer()

            if layer == 'Land' then
                self:ApplyBuffToUnits(mobileUnits, buff, auraRadius)
                self:ApplyBuffToUnits(nonExps, buffHPAuraLandUnits, auraRadius)
                self:ApplyBuffToUnits(aeonExp, buffHPAuraAeonExps, auraRadius)
                self:ApplyBuffToUnits(nonAeonExp, buffHPAuraExps, auraRadius)
                self:ApplyBuffToUnits(rangeBuffCat, buffRange, auraRadius)
                self:ApplyBuffToUnits(aeonExp, buffDamage, auraRadius)

                local all = brain:GetUnitsAroundPoint(mobileLandUnits, self:GetPosition(), slowdownRadius, "Enemy")
                local units = {}
                for _, u in all do
                    if not u.Dead and not u:IsBeingBuilt() then
                        table.insert(units, u)
                    end
                end

                for _, unit in units do
                    if Buff.HasBuff(unit, buffPreStun) then
                        Buff.ApplyBuff(unit, buffStun)
                    else
                        Buff.ApplyBuff(unit, buffPreStun)
                    end
                end

                if not table.empty(units) then
                    for _, effect in self.FxMuzzleFlash do
                        CreateAttachedEmitter(self, "Body", self:GetArmy(), effect):ScaleEmitter(0.9)
                    end
                end
            end

            WaitTicks(51)
        end

    end,

    DeathThread = function(self, overkillRatio, instigator)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_Ball', 5.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), { self:GetUnitSizes() })
        WaitSeconds(2)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_A_3', 1.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_1', 1.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_D_2', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_3', 1.0)
        WaitSeconds(0.3)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_B_1', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_B_2', 1.0)

        WaitSeconds(1.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Body', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:CreateProjectileAtBone('/effects/entities/InqDeathEffectController01/InqDeathEffectController01_proj.bp',
            'Body')
            :SetCollision(false)

        local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if (bp.Weapon[i].Label == 'CollossusDeath') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage,
                    bp.Weapon[i].DamageType,
                    bp.Weapon[i].DamageFriendly)
                break
            end
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if (self.ShowUnitDestructionDebris and overkillRatio) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris(self, true, true, true)
            else
                self.CreateUnitDestructionDebris(self, true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

    CreateEnhancement = function(self, enh)
        AStructureUnit.CreateEnhancement(self, enh)

        local bp = self.Blueprint.Enhancements[enh]
        local buff3 = 'Radar'

        if not bp then return end
        -- Missile
        if enh == 'AntiMissile' then
            self:SetWeaponEnabledByLabel('AntiMissile', true)
        elseif enh == 'AntiMissileRemove' then
            self:SetWeaponEnabledByLabel('AntiMissile', false)
        elseif enh == 'Visor' then
            self:EnableRemoteViewingButtons()
            self:OnIntelEnabled()
            if not Buffs[buff3] then -- AURA SELF BUFF
                BuffBlueprint {
                    Name = buff3,
                    DisplayName = buff3,
                    BuffType = 'RadarRadius',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        RadarRadius = {
                            Add = 150,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, buff3)
        elseif enh == 'VisorRemove' then
            self:DisableRemoteViewingButtons()
            self:DisableVisibleEntity()
            self:OnIntelDisabled()
            Buff.RemoveBuff(self, buff3)
            self.ScryEnabled = false
        elseif enh == 'AntiTele' then
            self.AntiTeleActive = true
        elseif enh == 'AntiTeleRemove' then
            self.AntiTeleActive = false
        end
    end,
}

TypeClass = UAL0405
