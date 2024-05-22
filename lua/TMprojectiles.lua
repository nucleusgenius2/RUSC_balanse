-- --#****************************************************************************
-- --#**
-- --#**  File     : /cdimage/lua/modules/BlackOpsARprojectiles.lua
-- --#**  Author(s): 
-- --#**
-- --#**  Summary  :
-- --#**
-- --#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- --#****************************************************************************
-- --#------------------------------------------------------------------------
-- --#					
-- --#------------------------------------------------------------------------
local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local OnWaterEntryEmitterProjectile = DefaultProjectileFile.OnWaterEntryEmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local SingleCompositeEmitterProjectile = DefaultProjectileFile.SingleCompositeEmitterProjectile
local Explosion = import('/lua/defaultexplosions.lua')
local NullShell = DefaultProjectileFile.NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local DefaultExplosion = import('/lua/defaultexplosions.lua')
local DepthCharge = import('/lua/defaultantiprojectile.lua').DepthCharge
local util = import('/lua/utilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

local TMEffectTemplate = import('/lua/TMEffectTemplates.lua')
local DepthCharge = import('/lua/defaultantiprojectile.lua').DepthCharge
local util = import('/lua/utilities.lua')

-- --#----------------
-- --# Null Shell
-- --#----------------
EXNullShell = Class(Projectile) {}


-- --#----------------------------------------------------------------
-- --# 			AEON PROJECTILES
-- --#----------------------------------------------------------------


-- --#----------------
-- --# UEF T1 Advanced Battle Bot Weapon
-- --#----------------
UefBRNT1ADVBOTproj = Class(EmitterProjectile) {
    FxTrails = TMEffectTemplate.BRNT1ADVBOTFXTrails01,
    FxImpactUnit = TMEffectTemplate.UEFT1ADVBOThit1,
    FxUnitHitScale = 0.5,
    FxImpactProp = TMEffectTemplate.UEFT1ADVBOThit1,
    FxPropHitScale = 0.5,
    FxImpactLand = TMEffectTemplate.UEFT1ADVBOThit1,
    FxLandHitScale = 0.5,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Seraphim Experimental Mega Bot Projectile
--#----------------
SerBRPT3SHBMproj = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.SDFSinnutheWeaponFXTrails01,
    FxImpactUnit = TMEffectTemplate.SerT3SHBMHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = TMEffectTemplate.SerT3SHBMHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = TMEffectTemplate.SerT3SHBMHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Seraphim Tech 1 Advanced Assault Tank
--#----------------
SerBRPT1EXTANK2proj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SChronotronCannonProjectileFxTrails,
    PolyTrails = EffectTemplate.SChronotronCannonProjectileTrails,
    PolyTrailOffset = {0,0,0},
    FxImpactUnit = TMEffectTemplate.SerT1AdvancedTankHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = TMEffectTemplate.SerT1AdvancedTankHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = TMEffectTemplate.SerT1AdvancedTankHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon NovaCat Blue laser
--#----------------

AeonBROT3NCNlaserproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        '/mods/TotalMayhem/effects/emitters/novacat_bluelaser_emit.bp',
	},
	PolyTrailOffset = {0,0}, 

    --# Hit Effects
    FxImpactUnit = EffectTemplate.CLaserHitUnit01,
    FxImpactProp = EffectTemplate.CLaserHitUnit01,
    FxImpactLand = EffectTemplate.CLaserHitLand01,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Super Heavy Point Defense
--#----------------
AeonT3SHPDproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 7,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 7,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}


--#----------------
--# Aeon Tech 1 Experimental Mobile Artillery Main projectile
--#----------------
AeonBROT1EXMOBARTproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 7,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 7,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 1 Experimental Mobile Artillery Child projectile
--#----------------
AeonBROT1EXMOBART2proj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.AeonExpT1ArtilleryHit,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonExpT1ArtilleryHit,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonExpT1ArtilleryHit,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 NovaCat Quantum Charge
--#----------------
AeonBROT3NCMproj = Class(SinglePolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.AeonQuantumChargeHit01,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.AeonQuantumChargeHit01,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.AeonQuantumChargeHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 NovaCat Rapid Pulsegun
--#----------------
AeonBROT3NCMPproj = Class(SinglePolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxUnitHitScale = 1,
    FxImpactProp = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxPropHitScale = 1,
    FxImpactLand = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Rocket Defense
--#----------------
AeonBROT3PDROproj = Class(EmitterProjectile) {

    FxTrails = EffectTemplate.AOblivionCannonFXTrails02,
    FxImpactUnit = TMEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 2.4,
    FxImpactProp = TMEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 2.4,
    FxImpactLand = TMEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 2.4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 2 Advanced Battleship main cannons
--#----------------
AeonBROST2ADVBATTLESHIPproj = Class(EmitterProjectile) {

    FxTrails = TMEffectTemplate.BROST2ADVBATTLESHIPTRAILS,
    FxImpactUnit = TMEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxWaterHitScale = 2,
    FxImpactUnderWater = {},
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_004_albedo', 11, 11, 250, 200, army )

            --#local blanketSides = 12
            --#local blanketAngle = (2*math.pi) / blanketSides
            --#local blanketStrength = 1
            --#local blanketVelocity = 2.25

            --#for i = 0, (blanketSides-1) do
            --#    local blanketX = math.sin(i*blanketAngle)
            --#    local blanketZ = math.cos(i*blanketAngle)
            --#    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            --#        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            --#end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

--#----------------
--# UEF Tech 2 Advanced Battleship main cannons
--#----------------
UefBRNST2ADVBATTLESHIPproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxUnitHitScale = 1.4,
    FxImpactProp = TMEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxPropHitScale = 1.4,
    FxImpactLand = TMEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxLandHitScale = 1.4,
    FxTrailOffset = 0,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxWaterHitScale = 2,
    FxImpactUnderWater = {},
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_004_albedo', 7, 7, 250, 200, army )

            --#local blanketSides = 12
            --#local blanketAngle = (2*math.pi) / blanketSides
            --#local blanketStrength = 1
            --#local blanketVelocity = 2.25

            --#for i = 0, (blanketSides-1) do
            --#    local blanketX = math.sin(i*blanketAngle)
            --#    local blanketZ = math.cos(i*blanketAngle)
            --#    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            --#        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            --#end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

--#----------------
--# Aeon Tech 1 Experimental Quadrobot maingun
--#----------------
AeonBROT1EXM1proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.AeonT1EXM1MainHit01,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.AeonT1EXM1MainHit01,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.AeonT1EXM1MainHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Tank Hunter
--#----------------
AeonBROT3THproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.AeonT3HeavyRocketHit01,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonT3HeavyRocketHit01,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonT3HeavyRocketHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 1 Battle Tank Clawgun
--#----------------
AeonBROT1BTCLAWproj = Class(SinglePolyTrailProjectile) {

    PolyTrail = '/effects/emitters/aeon_laser_trail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.AeonClawHit01,
    FxUnitHitScale = 0.35,
    FxImpactProp = TMEffectTemplate.AeonClawHit01,
    FxPropHitScale = 0.35,
    FxImpactLand = TMEffectTemplate.AeonClawHit01,
    FxLandHitScale = 0.35,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Heavy Clawgun
--#----------------
AeonHvyClawproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = TMEffectTemplate.AeonHvyClawHit01,
    FxUnitHitScale = 1.35,
    FxImpactProp = TMEffectTemplate.AeonHvyClawHit01,
    FxPropHitScale = 1.35,
    FxImpactLand = TMEffectTemplate.AeonHvyClawHit01,
    FxLandHitScale = 1.35,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Anti-Air Missile
--#----------------

AeonAAmissile01 = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = {},
    FxImpactAirUnit = {},
    FxImpactNone = EffectTemplate.AAntiMissileFlareHit,
    FxImpactProjectile = EffectTemplate.AAntiMissileFlareHit,
    FxOnKilled = EffectTemplate.AAntiMissileFlareHit,
    FxUnitHitScale = 1.4,
    FxLandHitScale = 1.4,
    FxWaterHitScale = 1.4,
    FxUnderWaterHitScale = 1.4,
    FxAirUnitHitScale = 1.4,
    FxNoneHitScale = 1.4,
    FxImpactLand = {},
    FxImpactUnderWater = {},
    DestroyOnImpact = false,

    OnImpact = function(self, TargetType, targetEntity)
        EmitterProjectile.OnImpact(self, TargetType, targetEntity)
        if TargetType == 'Terrain' or TargetType == 'Water' or TargetType == 'Prop' then
            if self.Trash then
                self.Trash:Destroy()
            end
            self:Destroy()
        end
    end,
}

--#----------------
--# Aeon T1 Rocket PD
--#----------------
AeonBROT1PDROproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxUnitHitScale = 1.0,
    FxImpactProp = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxPropHitScale = 1.0,
    FxImpactLand = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxImpactWater = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
}

--#----------------
--# Aeon T2 Medium Tank rockets
--#----------------
AeonBROT2MTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.ABombHit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = EffectTemplate.ABombHit01,
    FxPropHitScale = 1.0,
    FxImpactLand = EffectTemplate.ABombHit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = EffectTemplate.ABombHit01,
    FxImpactWater = EffectTemplate.ABombHit01,
}

--#----------------
--# Aeon Tech 2 Medium Tank main gun
--#----------------
AeonBROT2MTproj = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},

    --# Hit Effects
    FxImpactUnit = EffectTemplate.ACommanderOverchargeHit01,
    FxImpactProp = EffectTemplate.ACommanderOverchargeHit01,
    FxImpactLand = EffectTemplate.ACommanderOverchargeHit01,
    FxUnitHitScale = 2,
    FxLandHitScale = 2,
    FxPropHitScale = 2,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Advanced Support Tank main gun
--#----------------
AeonBROT3EXM1proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
	PolyTrailOffset = {0,0},

    --# Hit Effects
    FxImpactUnit = TMEffectTemplate.AeonGraniteHit01,
    FxImpactProp = TMEffectTemplate.AeonGraniteHit01,
    FxImpactLand = TMEffectTemplate.AeonGraniteHit01,
    FxUnitHitScale = 1,
    FxLandHitScale = 1,
    FxPropHitScale = 1,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 1 Battle Tank main gun
--#----------------
AeonBROT1BTproj = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},

    --# Hit Effects
    FxImpactUnit = EffectTemplate.ADisruptorHit01,
    FxImpactProp = EffectTemplate.ADisruptorHit01,
    FxImpactLand = EffectTemplate.ADisruptorHit01,
    FxUnitHitScale = 4,
    FxLandHitScale = 4,
    FxPropHitScale = 4,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 1 Experimental Assault Tank main gun
--#----------------
AeonBROT1EXM2proj = Class(SinglePolyTrailProjectile) {

    PolyTrail = '/effects/emitters/aeon_laser_trail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.AeonT1ExperimentalLaserHit,
    FxImpactProp = TMEffectTemplate.AeonT1ExperimentalLaserHit,
    FxImpactLand = TMEffectTemplate.AeonT1ExperimentalLaserHit,
    FxUnitHitScale = 1,
    FxLandHitScale = 1,
    FxPropHitScale = 1,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Battle Tank main guns
--#----------------
AeonBROT3BTproj = Class(EmitterProjectile) {

    FxTrails = {'/effects/emitters/graviton_munition_trail_01_emit.bp',},
    FxImpactUnit = TMEffectTemplate.AeonMainBattleTankHit01,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonMainBattleTankHit01,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonMainBattleTankHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Armored battlebot main guns
--#----------------
AeonBROT3ABBproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.AeonT3BattleBotHit01,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.AeonT3BattleBotHit01,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.AeonT3BattleBotHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Plasma Battery projectile
--#----------------
AeonBROT3ML2proj = Class(SinglePolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 2 Akuma Rocket projectile
--#----------------
AeonBROT2EXBMproj = Class(SinglePolyTrailProjectile) {
    PolyTrail = '/effects/emitters/aeon_missile_trail_01_emit.bp',

    FxImpactUnit = TMEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Experimental Cougar main guns
--#----------------
AeonBROT3COUGproj = Class(SinglePolyTrailProjectile) {

	PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.ADisruptorMunition01,
    FxImpactUnit = TMEffectTemplate.AeonCougarMainGuns,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.AeonCougarMainGuns,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.AeonCougarMainGuns,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Experimental Enforcer main guns
--#----------------
AeonBROT3SHBMproj = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AIFBallisticMortarTrails01,
    FxTrailScale = 0.75,
    FxImpactUnit = TMEffectTemplate.AeonEnforcerMainGuns,
    FxUnitHitScale = 2,
    FxImpactProp = TMEffectTemplate.AeonEnforcerMainGuns,
    FxPropHitScale = 2,
    FxImpactLand = TMEffectTemplate.AeonEnforcerMainGuns,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Heavy Tank main guns
--#----------------
AeonBROT3HTproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 3,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 3,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 3,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 2 Heavy Hover Tank main gun
--#----------------
AeonBROT2HTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = EffectTemplate.ALightDisplacementAutocannonMissilePolyTrails,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxLandHitScale = 1,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 2 Missile Launcher
--#----------------
AeonBROT2MLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.ACommanderOverchargeHit01,
    FxUnitHitScale = 3,
    FxImpactProp = EffectTemplate.ACommanderOverchargeHit01,
    FxPropHitScale = 3,
    FxImpactLand = EffectTemplate.ACommanderOverchargeHit01,
    FxLandHitScale = 3,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Rocket Battery
--#----------------
AeonBROT3MLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = TMEffectTemplate.AeonT3RocketHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = TMEffectTemplate.AeonT3RocketHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = TMEffectTemplate.AeonT3RocketHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Heavy Assault Mech EMP burst
--#----------------

AeonBROT3SHBMEMPproj = Class(SinglePolyTrailProjectile) {
    FxImpactUnit = TMEffectTemplate.AeonT3EMPburst,
    FxUnitHitScale = 4,
    FxImpactProp = TMEffectTemplate.AeonT3EMPburst,
    FxPropHitScale = 4,
    FxImpactLand = TMEffectTemplate.AeonT3EMPburst,
    FxLandHitScale = 4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}


--#----------------------------------------------------------------
--# 			CYBRAN PROJECTILES
--#----------------------------------------------------------------

--#----------------
--# Cybran Tech 2 Battle Mech Rockets
--#----------------
CybranBMRocketProjectile = Class(SingleCompositeEmitterProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.CHvyDisintegratorHit02,
    FxUnitHitScale = 4,
    FxImpactProp = EffectTemplate.CHvyDisintegratorHit02,
    FxPropHitScale = 4,
    FxImpactLand = EffectTemplate.CHvyDisintegratorHit02,
    FxLandHitScale = 4,
    FxImpactUnderWater = {},
}

--#----------------
--# Cybran Tech 1 Battle Tank Rockets
--#----------------
CybBRMT1BTRLproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/electron_bolter_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_01_emit.bp',
	},
	PolyTrailOffset = {0,0},  
    FxTrails = {'/effects/emitters/electron_bolter_munition_01_emit.bp',},
    FxImpactUnit = EffectTemplate.CMissileHit02a,
    FxUnitHitScale = 2,
    FxImpactProp = EffectTemplate.CMissileHit02a,
    FxPropHitScale = 2,
    FxImpactLand = EffectTemplate.CMissileHit02a,
    FxLandHitScale = 2,
    FxImpactUnderWater = EffectTemplate.CMissileHit02a,
    FxImpactWater = EffectTemplate.CMissileHit02a,
    FxWaterHitScale = 2,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 1 Heavy Tank Cannon 1
--#----------------

CybBRMT1HVYproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 0.6,
    FxImpactProp = TMEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 0.6,
    FxImpactLand = TMEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 0.6,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 1 Advanced BattleTank projectile
--#----------------

CybBRMT1EXTANKproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = TMEffectTemplate.BRMT1EXTANKTRAILS,
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactUnit = TMEffectTemplate.BRMT1EXTANKHIT,
    FxUnitHitScale = 1.6,
    FxImpactProp = TMEffectTemplate.BRMT1EXTANKHIT,
    FxPropHitScale = 1.6,
    FxImpactLand = TMEffectTemplate.BRMT1EXTANKHIT,
    FxLandHitScale = 1.6,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 1 Medium Tank Cannon
--#----------------

CybBRMT1MTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01MT,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonHit,
    FxUnitHitScale = 1.6,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonHit,
    FxPropHitScale = 1.6,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxLandHitScale = 1.6,
    FxImpactUnderWater = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.TPlasmaGatlingCannonHit,
    FxTrailOffset = 0,
}

--#------------------------------------------------------------------------
--#  CYBRAN RED PLASMA GATLING GUN
--#------------------------------------------------------------------------
CybBRMT3RAPproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = TMEffectTemplate.RedGatlingCannonPolyTrails,

}

--#------------------------------------------------------------------------
--#  AEON T1 FIGHTER
--#------------------------------------------------------------------------
AeonBROAT1FIGproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = TMEffectTemplate.AeonT1FighterPolyTrails,

}

--#------------------------------------------------------------------------
--#  UEF GREEN PLASMA GATLING GUN
--#------------------------------------------------------------------------
uefBRNT3ARGUSMINIproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = TMEffectTemplate.GreenGatlingCannonPolyTrails,

}

--#------------------------------------------------------------------------
--#  UEF YELLOW LASER
--#------------------------------------------------------------------------
uefBRNT3ARGUSLASERproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = TMEffectTemplate.YellowLaserPolyTrails,

}

--#----------------
--# Cybran Tech 3 SnakeBite small Rockets
--#----------------

CybBRMT3HAMRLproj = Class(SingleCompositeEmitterProjectile) {
    FxTrails = {},
	PolyTrail = '/effects/emitters/cybran_iridium_missile_polytrail_01_emit.bp',    
    BeamName = '/effects/emitters/rocket_iridium_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 1.13,
    FxImpactProp = TMEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 1.13,
    FxImpactLand = TMEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 1.13,
    FxImpactUnderWater = TMEffectTemplate.CybranT1BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT1BattleTankHit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 1 Experimental LaserBot
--#----------------

CybBRMT1EXM1proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = TMEffectTemplate.HeavyLaserPolyTrail,
    FxImpactUnit = TMEffectTemplate.CLaserBotHit01,
    FxUnitHitScale = 1.13,
    FxImpactProp = TMEffectTemplate.CLaserBotHit01,
    FxPropHitScale = 1.13,
    FxImpactLand = TMEffectTemplate.CLaserBotHit01,
    FxLandHitScale = 1.13,
    FxImpactUnderWater = TMEffectTemplate.CLaserBotHit01,
    FxImpactWater = TMEffectTemplate.CLaserBotHit01,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 2 Heavy Tank Cannon 1
--#----------------

CybBRMT2HVYproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = TMEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 1.1,
    FxImpactLand = TMEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = TMEffectTemplate.CybranT1BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT1BattleTankHit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 2 Heavy Artillery Cannon 1
--#----------------

CybBRMT2BEETLEproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail02,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT2BeetleHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = TMEffectTemplate.CybranT2BeetleHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = TMEffectTemplate.CybranT2BeetleHit01,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = TMEffectTemplate.CybranT2BeetleHit01,
    FxImpactWater = TMEffectTemplate.CybranT2BeetleHit01,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 2 Experimental Point Defense Laser
--#----------------

CybBRMT2EPDproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = TMEffectTemplate.HeavyLaserPolyTrail,
    FxImpactUnit = EffectTemplate.CDisintegratorHitUnit01,
    FxImpactAirUnit = EffectTemplate.CDisintegratorHitAirUnit01,
    FxImpactProp = EffectTemplate.CDisintegratorHitUnit01,
    FxLandHitScale = 2.4,
    FxUnitHitScale = 2.4,
    FxPropHitScale = 2.4,
    FxImpactLand = EffectTemplate.CDisintegratorHitLand01,
    FxImpactUnderWater = {},
}

--#----------------
--# NULLWEAPON
--#----------------

CybNULLWEAPONproj = Class(NullShell) {
    --# Hit Effects
    FxImpactUnit = {},
    FxImpactAirUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
}

--#----------------
--# Cybran Tech 2 Heavy Tank Cannon 2
--#----------------

CybBRMT2HVY2proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    FxImpactUnit = TMEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 0.55,
    FxImpactProp = TMEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 0.55,
    FxImpactLand = TMEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 0.55,
    FxImpactUnderWater = TMEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT2BattleTankHit,
    FxWaterHitScale = 0.55,
    FxTrailOffset = 0,
}

--#----------------
--# Aeon Experimental Battle Bot SplitterMissiles
--#----------------

AeonBROT3BTBOTproj = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = EffectTemplate.AOblivionCannonHit01,
    FxImpactProp = EffectTemplate.AOblivionCannonHit01,
    FxImpactLand = EffectTemplate.AOblivionCannonHit01,
    FxImpactWater = EffectTemplate.AOblivionCannonHit01,
}

AeonBROT3BTBOT2proj = Class(SinglePolyTrailProjectile) {
    PolyTrail = '/effects/emitters/quantum_displacement_cannon_polytrail_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFDeath01,
    FxImpactProp = TMEffectTemplate.UEFDeath01,
    FxImpactLand = TMEffectTemplate.UEFDeath01,
    FxLandHitScale = 0.55,
    FxUnitHitScale = 0.55,
    FxPropHitScale = 0.55,
    FxImpactWater = TMEffectTemplate.UEFDeath01,
    FxWaterHitScale = 0.55,
}

--#----------------
--# Cybran Tech 3 Battle Tank main gun
--#----------------
CybBRMT3BTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT3BattleTankHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.CybranT3BattleTankHit,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.CybranT3BattleTankHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.CybranT3BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT3BattleTankHit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Experimental MadCat main gun
--#----------------
CybMadCatMolecular = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.CMolecularCannon01,
    FxImpactUnit = TMEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = TMEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 1.3,
    FxImpactLand = TMEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = TMEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT2BattleTankHit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Experimental MadCat Rockets
--#----------------
CybMadCatRockets = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.CMolecularCannon01,
    FxImpactUnit = TMEffectTemplate.CybranT3MadCatRocketsHit,
    FxUnitHitScale = 1.2,
    FxImpactProp = TMEffectTemplate.CybranT3MadCatRocketsHit,
    FxPropHitScale = 1.2,
    FxImpactLand = TMEffectTemplate.CybranT3MadCatRocketsHit,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = TMEffectTemplate.CybranT3MadCatRocketsHit,
    FxImpactWater = TMEffectTemplate.CybranT3MadCatRocketsHit,
    FxWaterHitScale = 1.2,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Experimental MadCat mk.2 main gun
--#----------------
CybBRMT3MCM2proj = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrails = {
        EffectTemplate.CHvyProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = EffectTemplate.CHvyProtonCannonFXTrail01,
    FxImpactUnit = TMEffectTemplate.Madcatmk2hit,
    FxUnitHitScale = 1.0,
    FxImpactProp = TMEffectTemplate.Madcatmk2hit,
    FxPropHitScale = 1.0,
    FxImpactLand = TMEffectTemplate.Madcatmk2hit,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = TMEffectTemplate.Madcatmk2hit,
    FxImpactWater = TMEffectTemplate.Madcatmk2hit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Experimental MadCat mk.4 main gun
--#----------------
CybBRMT3MCM4proj = Class(MultiPolyTrailProjectile) {


	FxTrails = EffectTemplate.CDisintegratorFxTrails01,  
	
    FxImpactUnit = TMEffectTemplate.Beetleprojectilehit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = TMEffectTemplate.Beetleprojectilehit01,
    FxPropHitScale = 1.0,
    FxImpactLand = TMEffectTemplate.Beetleprojectilehit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = TMEffectTemplate.Beetleprojectilehit01,
    FxImpactWater = TMEffectTemplate.Beetleprojectilehit01,
}

--#----------------
--# Cybran Experimental MadCat mk.4 Rockets
--#----------------
CybBRMT3MCM4RLproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = TMEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = TMEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 1.3,
    FxImpactLand = TMEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = TMEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = TMEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 1.3,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Battle Tank Rockets
--#----------------
CybBRMT3BTRLproj = Class(SingleCompositeEmitterProjectile) {
    FxTrails = {},
	PolyTrail = '/effects/emitters/cybran_iridium_missile_polytrail_01_emit.bp',    
    BeamName = '/effects/emitters/rocket_iridium_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.CybranT3BattleTankRocketHit,
    FxUnitHitScale = 0.85,
    FxImpactProp = TMEffectTemplate.CybranT3BattleTankRocketHit,
    FxPropHitScale = 0.85,
    FxImpactLand = TMEffectTemplate.CybranT3BattleTankRocketHit,
    FxLandHitScale = 0.85,
    FxImpactUnderWater = TMEffectTemplate.CybranT3BattleTankRocketHit,
    FxImpactWater = TMEffectTemplate.CybranT3BattleTankRocketHit,
    FxWaterHitScale = 0.85,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Battle Mech 2 Rockets
--#----------------
CybBRMT3BM2TLproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},
    FxImpactUnit = TMEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = TMEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 1.3,
    FxImpactLand = TMEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = TMEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = TMEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 1.3,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Battle Mech Rockets
--#----------------
CybBRMT3BMRLproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/electron_bolter_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_01_emit.bp',
	},
	PolyTrailOffset = {0,0},  
    FxTrails = {'/effects/emitters/electron_bolter_munition_01_emit.bp',},
    FxImpactUnit = EffectTemplate.CMissileHit02a,
    FxUnitHitScale = 6.2,
    FxImpactProp = EffectTemplate.CMissileHit02a,
    FxPropHitScale = 6.2,
    FxImpactLand = EffectTemplate.CMissileHit02a,
    FxLandHitScale = 6.2,
    FxImpactUnderWater = EffectTemplate.CMissileHit02a,
    FxImpactWater = EffectTemplate.CMissileHit02a,
    FxWaterHitScale = 6.2,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Heavy Rockets (Rocket Battery)
--#----------------
CybBRMT3MLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.8,
}

--#----------------
--# Cybran Tech 1 Advanced BattleBot Rockets
--#----------------
CybBRMT1ADVBOTRLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 1.1,
    FxImpactLand = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 1.1,
}

--#----------------
--# Cybran Experimental Battle Spiderbot Rockets
--#----------------
CybBRMT3EXBMRLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = TMEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 0.8,
}

--#----------------
--# Cybran Tech 3 Point Defense Proton Gun
--#----------------
CybBRMT3PDproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranHeavyProtonGunHit,
    FxUnitHitScale = 0.5,
    FxImpactProp = TMEffectTemplate.CybranHeavyProtonGunHit,
    FxPropHitScale = 0.5,
    FxImpactLand = TMEffectTemplate.CybranHeavyProtonGunHit,
    FxLandHitScale = 0.5,
    FxImpactUnderWater = TMEffectTemplate.CybranHeavyProtonGunHit,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Rocket Defense
--#----------------
CybBRMT3PDROproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = TMEffectTemplate.CybranT3PdroHit,
    FxUnitHitScale = 1.95,
    FxImpactProp = TMEffectTemplate.CybranT3PdroHit,
    FxPropHitScale = 1.95,
    FxImpactLand = TMEffectTemplate.CybranT3PdroHit,
    FxLandHitScale = 1.95,
    FxImpactUnderWater = TMEffectTemplate.CybranT3PdroHit,
    FxImpactWater = TMEffectTemplate.CybranT3PdroHit,
    FxWaterHitScale = 1.95,
    FxTrailOffset = -0.5,
}

--#----------------
--# Cybran Avalanche Rockets
--#----------------
CybBRMT3AVARLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = TMEffectTemplate.AvalancheRocketHit,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AvalancheRocketHit,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AvalancheRocketHit,
    FxLandHitScale = 1,
    FxImpactUnderWater = TMEffectTemplate.AvalancheRocketHit,
    FxImpactWater = TMEffectTemplate.AvalancheRocketHit,
    FxWaterHitScale = 1,
    FxTrailOffset = -0.5,
}

--#----------------
--# Cybran Tech 3 Bombardment Ship
--#----------------
CybBRMST3BOMproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        EffectTemplate.CHvyProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = EffectTemplate.CHvyProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxUnitHitScale = 3,
    FxImpactProp = TMEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxPropHitScale = 3,
    FxImpactLand = TMEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxLandHitScale = 3,
    FxImpactUnderWater = TMEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxImpactWater = TMEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxWaterHitScale = 3,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Heavy Tank 2 barreled main gun
--#----------------
CybBRMT3HT3proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        TMEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = TMEffectTemplate.CybProtonCannonFXTrail01,
    --#PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT3HVYTankHit,
    FxUnitHitScale = 0.65,
    FxImpactProp = TMEffectTemplate.CybranT3HVYTankHit,
    FxPropHitScale = 0.65,
    FxImpactLand = TMEffectTemplate.CybranT3HVYTankHit,
    FxLandHitScale = 0.65,
    FxImpactUnderWater = TMEffectTemplate.CybranT3HVYTankHit,
    FxImpactWater = TMEffectTemplate.CybranT3HVYTankHit,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 3 Beetle Guns
--#----------------
CybBRMT3AVAproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/disintegrator_polytrail_04_emit.bp',
		'/effects/emitters/disintegrator_polytrail_05_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0,0},  
	FxTrails = EffectTemplate.CDisintegratorFxTrails01,  
	
    FxImpactUnit = TMEffectTemplate.Beetleprojectilehit01,
    FxUnitHitScale = 1.4,
    FxImpactProp = TMEffectTemplate.Beetleprojectilehit01,
    FxPropHitScale = 1.4,
    FxImpactLand = TMEffectTemplate.Beetleprojectilehit01,
    FxLandHitScale = 1.4,
    FxImpactUnderWater = TMEffectTemplate.Beetleprojectilehit01,
    FxImpactWater = TMEffectTemplate.Beetleprojectilehit01,
}


--#----------------------------------------------------------------
--# 			UEF PROJECTILES
--#----------------------------------------------------------------


--#----------------
--# UEF Tech 1 Battle Tank rockets
--#----------------
UefBRNT1BTRLproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.TGaussCannonHitLand01,
    FxUnitHitScale = 5,
    FxImpactProp = EffectTemplate.TGaussCannonHitLand01,
    FxPropHitScale = 5,
    FxImpactLand = EffectTemplate.TGaussCannonHitLand01,
    FxLandHitScale = 5,
    FxImpactUnderWater = EffectTemplate.TGaussCannonHitLand01,
    FxImpactWater = EffectTemplate.TGaussCannonHitLand01,
    FxWaterHitScale = 5,
}

--#----------------
--# UEF Tech 2 Advanced Sniper Tank Main gun
--#----------------
UefBRNT2SNIPERproj = Class(MultiPolyTrailProjectile) {
    FxTrails = TMEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = TMEffectTemplate.UEFArmoredBattleBotPolyTrails,
    FxImpactUnit = TMEffectTemplate.UEFT2snipertankhit01,
    FxUnitHitScale = 0.5,
    FxImpactProp = TMEffectTemplate.UEFT2snipertankhit01,
    FxPropHitScale = 0.5,
    FxImpactLand = TMEffectTemplate.UEFT2snipertankhit01,
    FxLandHitScale = 0.5,
    FxImpactUnderWater = TMEffectTemplate.UEFT2snipertankhit01,
    FxImpactWater = TMEffectTemplate.UEFT2snipertankhit01,
    FxWaterHitScale = 0.5,
}

--#----------------
--# UEF Tech 3 Battle Tank main gun
--#----------------
UefBRNT3BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT3BattletankHit,
    FxUnitHitScale = 1.0,
    FxImpactProp = TMEffectTemplate.UefT3BattletankHit,
    FxPropHitScale = 1.0,
    FxImpactLand = TMEffectTemplate.UefT3BattletankHit,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = TMEffectTemplate.UefT3BattletankHit,
    FxImpactWater = TMEffectTemplate.UefT3BattletankHit,
}

--#----------------
--# UEF Tech 1 Battle Tank main gun
--#----------------
UefBRNT1BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT1BattleTankHit,
    FxUnitHitScale = 0.9,
    FxImpactProp = TMEffectTemplate.UefT1BattleTankHit,
    FxPropHitScale = 0.9,
    FxImpactLand = TMEffectTemplate.UefT1BattleTankHit,
    FxLandHitScale = 0.9,
    FxImpactUnderWater = TMEffectTemplate.UefT1BattleTankHit,
    FxImpactWater = TMEffectTemplate.UefT1BattleTankHit,
}

--#----------------
--# UEF Tech 2 Heavy Tank main gun
--#----------------
UefBRNT2HTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT2BattleTankHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = TMEffectTemplate.UefT2BattleTankHit,
    FxPropHitScale = 1.1,
    FxImpactLand = TMEffectTemplate.UefT2BattleTankHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = TMEffectTemplate.UefT2BattleTankHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 2 Battle Tank main gun
--#----------------
UefBRNT2BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT2BattleTankHit2,
    FxUnitHitScale = 1.1,
    FxImpactProp = TMEffectTemplate.UefT2BattleTankHit2,
    FxPropHitScale = 1.1,
    FxImpactLand = TMEffectTemplate.UefT2BattleTankHit2,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = TMEffectTemplate.UefT2BattleTankHit2,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 2 Experimental Light Assault Mech Big Gun
--#----------------
UefBRNT2EXLMproj = Class(MultiPolyTrailProjectile) {
    FxTrails = TMEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = TMEffectTemplate.UEFArmoredBattleBotPolyTrails,
    FxImpactUnit = TMEffectTemplate.BRNT2EXLMHit1,
    FxUnitHitScale = 2.1,
    FxImpactProp = TMEffectTemplate.BRNT2EXLMHit1,
    FxPropHitScale = 2.1,
    FxImpactLand = TMEffectTemplate.BRNT2EXLMHit1,
    FxLandHitScale = 2.1,
    FxImpactUnderWater = TMEffectTemplate.BRNT2EXLMHit1,
}

--#----------------
--# UEF Tech 1 Medium Tank main gun
--#----------------
UefBRNT1MTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT1MedTankHit,
    FxUnitHitScale = 0.7,
    FxImpactProp = TMEffectTemplate.UefT1MedTankHit,
    FxPropHitScale = 0.7,
    FxImpactLand = TMEffectTemplate.UefT1MedTankHit,
    FxLandHitScale = 0.7,
    FxImpactUnderWater = TMEffectTemplate.UefT1MedTankHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 3 Armored Battle Bot Main guns
--#----------------
UefBRNT3ABBproj = Class(MultiPolyTrailProjectile) {
	FxImpactLand = TMEffectTemplate.UEFArmoredBattleBotHit,
    FxImpactNone = TMEffectTemplate.UEFArmoredBattleBotHit,
    FxImpactProp = TMEffectTemplate.UEFArmoredBattleBotHit,    
    FxImpactUnit = TMEffectTemplate.UEFArmoredBattleBotHit,
    FxLandHitScale = 1.3,
    FxPropHitScale = 1.3,
    FxUnitHitScale = 1.3,
    FxTrails = TMEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = TMEffectTemplate.UEFArmoredBattleBotPolyTrails,
}

--#----------------
--# UEF experimental Blood Asp gun
--#----------------
UefBRNT3BLASPproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/laserturret_munition_beam_03_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxUnitHitScale = 1.9,
    FxImpactProp = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxPropHitScale = 1.9,
    FxImpactLand = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxLandHitScale = 1.9,
    FxImpactUnderWater = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxImpactWater = TMEffectTemplate.UEFHighExplosiveShellHit01,
}

--#----------------
--# UEF Tech 3 Battle Tank rockets
--#----------------
UefBRNT3BTRLproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UefT3BattletankRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.UefT3BattletankRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.UefT3BattletankRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.UefT3BattletankRocketHit,
    FxImpactWater = TMEffectTemplate.UefT3BattletankRocketHit,
}

--#----------------
--# UEF Tech Experimental MAYHEM new rockets
--#----------------
UefBRNT3SHBMNEWRLproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = TMEffectTemplate.UEFmayhemRocketHit,
    FxUnitHitScale = 1.2,
    FxImpactProp = TMEffectTemplate.UEFmayhemRocketHit,
    FxPropHitScale = 1.2,
    FxImpactLand = TMEffectTemplate.UEFmayhemRocketHit,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = TMEffectTemplate.UEFmayhemRocketHit,
    FxImpactWater = TMEffectTemplate.UEFmayhemRocketHit,
}

--#----------------
--# UEF Doomsday Main TriGuns
--#----------------
UefBRNT3DOOMSGUNproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UEFDeath02,
    FxUnitHitScale = 0.9,
    FxImpactProp = TMEffectTemplate.UEFDeath02,
    FxPropHitScale = 0.9,
    FxImpactLand = TMEffectTemplate.UEFDeath02,
    FxLandHitScale = 0.9,
    FxImpactUnderWater = TMEffectTemplate.UEFDeath02,
    FxImpactWater = TMEffectTemplate.UEFDeath02,
}

--#----------------
--# UEF Doomsday Missiles
--#----------------
UefBRNT3DOOMSDAYproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = TMEffectTemplate.UEFmayhemRocketHit,
    FxUnitHitScale = 1.7,
    FxImpactProp = TMEffectTemplate.UEFmayhemRocketHit,
    FxPropHitScale = 1.7,
    FxImpactLand = TMEffectTemplate.UEFmayhemRocketHit,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = TMEffectTemplate.UEFmayhemRocketHit,
    FxImpactWater = TMEffectTemplate.UEFmayhemRocketHit,
}

--#----------------
--# UEF Tech Experimental MAYHEM new rockets small
--#----------------
UefBRNT3SHBMNEWRL2proj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFmayhemRocketHit2,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.UEFmayhemRocketHit2,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.UEFmayhemRocketHit2,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.UEFmayhemRocketHit2,
    FxImpactWater = TMEffectTemplate.UEFmayhemRocketHit2,
}

--#----------------
--# UEF Tech 2 Jackhammer mk2 new rockets
--#----------------
UefUEFT2Exocet = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFmayhemRocketHit2,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.UEFmayhemRocketHit2,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.UEFmayhemRocketHit2,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.UEFmayhemRocketHit2,
    FxImpactWater = TMEffectTemplate.UEFmayhemRocketHit2,
}

--#----------------
--# UEF Tech 1 Experimental Assault Tank
--#----------------
UefBRNT1EXM1proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UEFHighExplosiveShellHit01,	
    FxUnitHitScale = 1.5,
    FxImpactProp = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxPropHitScale = 1.5,
    FxImpactLand = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxLandHitScale = 1.5,
    FxImpactUnderWater = TMEffectTemplate.UEFHighExplosiveShellHit01,
    FxImpactWater = TMEffectTemplate.UEFHighExplosiveShellHit01,
}

--#----------------
--# UEF Tech 3 Ultra Heavy Battle Mech Rockets
--#----------------
UefBRNT3SHBMproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = TMEffectTemplate.UEFHighExplosiveShellHit02,
    FxUnitHitScale = 0.6,
    FxImpactProp = TMEffectTemplate.UEFHighExplosiveShellHit02,
    FxPropHitScale = 0.6,
    FxImpactLand = TMEffectTemplate.UEFHighExplosiveShellHit02,
    FxLandHitScale = 0.6,
    FxImpactUnderWater = TMEffectTemplate.UEFHighExplosiveShellHit02,
    FxImpactWater = TMEffectTemplate.UEFHighExplosiveShellHit02,
}

--#----------------
--# UEF Tech 2 Experimental Point Defense
--#----------------
UefBRNT2EPDproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.TPlasmaCannonHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = TMEffectTemplate.UefT2EPDPlasmaHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = TMEffectTemplate.UefT2EPDPlasmaHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = TMEffectTemplate.UefT2EPDPlasmaHit01,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = TMEffectTemplate.UefT2EPDPlasmaHit01,
    FxImpactWater = TMEffectTemplate.UefT2EPDPlasmaHit01,
}

--#----------------
--# UEF Tech 3 Super Heavy Point Defense
--#----------------
UefBRNT3SHPDproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = TMEffectTemplate.UefT3SHPDGaussHit01,
    FxUnitHitScale = 1.4,
    FxImpactProp = TMEffectTemplate.UefT3SHPDGaussHit01,
    FxPropHitScale = 1.4,
    FxImpactLand = TMEffectTemplate.UefT3SHPDGaussHit01,
    FxLandHitScale = 1.4,
    FxImpactUnderWater = TMEffectTemplate.UefT3SHPDGaussHit01,
    FxImpactWater = TMEffectTemplate.UefT3SHPDGaussHit01,
}

--#----------------
--# UEF Experimental Mobile Fortress Main Guns
--#----------------
UefBRNT3MOBproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
	FxTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
    FxImpactUnit = TMEffectTemplate.UefMobileFortressGunhit,
    FxUnitHitScale = 1.5,
    FxImpactProp = TMEffectTemplate.UefMobileFortressGunhit,
    FxPropHitScale = 1.5,
    FxImpactLand = TMEffectTemplate.UefMobileFortressGunhit,
    FxLandHitScale = 1.5,
    FxImpactUnderWater = TMEffectTemplate.UefMobileFortressGunhit,
    FxImpactWater = TMEffectTemplate.UefMobileFortressGunhit,
}

--#----------------
--# UEF Tech 2 Heavy Tank rockets
--#----------------
UefBRNT2HTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxUnitHitScale = 0.45,
    FxImpactProp = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxPropHitScale = 0.45,
    FxImpactLand = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxLandHitScale = 0.45,
    FxImpactUnderWater = EffectTemplate.TShipGaussCannonHit02,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 2 Medium Tank rockets
--#----------------
UefBRNT2MTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxUnitHitScale = 0.75,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxPropHitScale = 0.75,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxLandHitScale = 0.75,
    FxImpactUnderWater = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 3 Heavy Rockets (Rocket Battery)
--#----------------
UefBRNT3MLproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxUnitHitScale = 1.8,
    FxImpactProp = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxPropHitScale = 1.8,
    FxImpactLand = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxLandHitScale = 1.8,
    FxImpactUnderWater = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# UEF Tech 3 Rocket Defense
--#----------------
UefBRNT3PDROproj = Class(SingleBeamProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFHEAVYROCKET02,
    FxUnitHitScale = 2.2,
    FxImpactProp = TMEffectTemplate.UEFHEAVYROCKET02,
    FxPropHitScale = 2.2,
    FxImpactLand = TMEffectTemplate.UEFHEAVYROCKET02,
    FxLandHitScale = 2.2,
    FxImpactUnderWater = TMEffectTemplate.UEFHEAVYROCKET02,
    FxImpactWater = TMEffectTemplate.UEFHEAVYROCKET02,
    FxWaterHitScale = 2.2,
}

--#----------------
--# UEF Tech 2 Experimental Missile Launcher
--#----------------
UefBRNT2EXM2proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFHEAVYMISSILE01,
    FxUnitHitScale = 2.2,
    FxImpactProp = TMEffectTemplate.UEFHEAVYMISSILE01,
    FxPropHitScale = 2.2,
    FxImpactLand = TMEffectTemplate.UEFHEAVYMISSILE01,
    FxLandHitScale = 2.2,
    FxImpactUnderWater = TMEffectTemplate.UEFHEAVYMISSILE01,
    FxImpactWater = TMEffectTemplate.UEFHEAVYMISSILE01,
    FxWaterHitScale = 2.2,
}

--#----------------
--# UEF Tech 3 Battle Mech main gun
--#----------------
UefBRNT3WKproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.TPlasmaCannonHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = TMEffectTemplate.UEFHeavyMechHit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = TMEffectTemplate.UEFHeavyMechHit01,
    FxPropHitScale = 1.0,
    FxImpactLand = TMEffectTemplate.UEFHeavyMechHit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = TMEffectTemplate.UEFHeavyMechHit01,
    FxImpactWater = TMEffectTemplate.UEFHeavyMechHit01,
    FxWaterHitScale = 1.0,
}

--#----------------
--# UEF Tech 3 Battle Mech rockets
--#----------------
UefBRNT3WKRLproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 1.8,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 1.8,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 1.8,
    FxImpactUnderWater = EffectTemplate.TShipGaussCannonHit02,
    FxImpactWater = EffectTemplate.TShipGaussCannonHit02,
}



--#			----------------
--# 			DEATH EXPLOSIONS
--#			----------------

--#----------------
--# Cybran Tech 3 Rocket Defense
--#----------------
CybBRMT1Dproj = Class(NullShell) {
    FxImpactUnit = EffectTemplate.CMobileKamikazeBombExplosion,
    FxUnitHitScale = 1.35,
    FxImpactProp = EffectTemplate.CMobileKamikazeBombExplosion,
    FxPropHitScale = 1.35,
    FxImpactLand = EffectTemplate.CMobileKamikazeBombExplosion,
    FxLandHitScale = 1.35,
    FxImpactUnderWater = EffectTemplate.CMobileKamikazeBombExplosion,
    FxImpactWater = EffectTemplate.CMobileKamikazeBombExplosion,
    FxWaterHitScale = 1.35,
    FxTrailOffset = 0,
}



--#----------------
--# Cybran Tech 3 Heavy Rockets FFAR Class
--#----------------
CybBRMT3FFARproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.25,
    FxImpactProp = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.25,
    FxImpactLand = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.25,
    FxImpactUnderWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.25,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 2 Vulture Molecular Cannon
--#----------------
CybMadCatMolecular2 = Class(MultiPolyTrailProjectile) {
    PolyTrails = TMEffectTemplate.VultureMolecularPolyTrail,
    FxImpactUnit = TMEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 0.4,
    FxImpactProp = TMEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 0.4,
    FxImpactLand = TMEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 0.4,
    FxImpactUnderWater = TMEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = TMEffectTemplate.CybranT2BattleTankHit,
}

--#----------------
--# UEF Tech 3 Heavy Rockets FFAR Class
--#----------------
UefBRNT3FFARproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = TMEffectTemplate.UEFHighExplosiveRocketHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

--#----------------
--# Cybran Tech 3 Heavy Rockets FFAR Class
--#----------------
CybBRMT3FFAR2proj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.25,
    FxImpactProp = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.25,
    FxImpactLand = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.25,
    FxImpactUnderWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = TMEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.25,
    FxTrailOffset = 0,
}

--#----------------
--# Cybran Tech 1 Light Battle Mech Laser
--#----------------
CybBRMT1BMproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = TMEffectTemplate.LightLaserPolyTrail,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxUnitHitScale = 0.6,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxPropHitScale = 0.6,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxLandHitScale = 0.6,
    FxImpactUnderWater = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactWater = EffectTemplate.TPlasmaGatlingCannonUnitHit,
}

--#----------------
--# Aeon Tech 3 Advanced Battle Ship main guns
--#----------------
AeonBROST3BSHIPproj = Class(EmitterProjectile) {

    FxTrails = EffectTemplate.AOblivionCannonFXTrails02,
    FxImpactUnit = TMEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = TMEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = TMEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1.7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 2 Experimental Tank Hunter main gun
--#----------------
AeonBROT2EXTHproj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/AeonT2EXTH_polytrails_emit.bp',
	},
    FxImpactUnit = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxUnitHitScale = 1,
    FxImpactProp = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxPropHitScale = 1,
    FxImpactLand = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Aeon Tech 3 Super Defense main gun
--#----------------
AeonBROT3SHPD2proj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/AeonT3SHPD_polytrails_emit.bp',
	},
    FxImpactUnit = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxUnitHitScale = 1.25,
    FxImpactProp = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxPropHitScale = 1.25,
    FxImpactLand = TMEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxLandHitScale = 1.25,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# UEF Tech 2 Experimental Artillery main gun
--#----------------
UefBRNT2EXARTproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
	PolyTrails  = {
            '/mods/TotalMayhem/effects/emitters/UEFT2EXART_polytrails_emit.bp',
            '/mods/TotalMayhem/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
	},
    FxImpactUnit = TMEffectTemplate.UEFT2EXARTHit02,
    FxUnitHitScale = 1.0,
    FxImpactProp = TMEffectTemplate.UEFT2EXARTHit02,
    FxPropHitScale = 1.0,
    FxImpactLand = TMEffectTemplate.UEFT2EXARTHit02,
    FxLandHitScale = 1.0,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

--#----------------
--# Cybran Tech 3 Advanced Battle Bot cannon
--#----------------
CybBRMT3ADVBTBOTproj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
        '/mods/TotalMayhem/effects/emitters/BRMT3ADVBTBOT_polytrails_emit.bp',
		'/effects/emitters/disintegrator_polytrail_02_emit.bp',
		'/effects/emitters/disintegrator_polytrail_03_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
    FxImpactUnit = TMEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxUnitHitScale = 1.25,
    FxImpactProp = TMEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxPropHitScale = 1.25,
    FxImpactLand = TMEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxLandHitScale = 1.25,
    FxTrailOffset = 0,
    PolyTrailOffset = {0,0,0,0},
    FxImpactUnderWater = {},
}