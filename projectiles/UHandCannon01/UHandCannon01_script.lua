-----------------------------------------------------------------------------
--  File     :  /projectiles/uef/uhandcannon01/uhandcannon01_script.lua
--  Author(s):	Gordon Duclos, Aaron Lundquist
--  Summary  :  SC2 UEF Hand Cannon: UHandCannon01
--  Copyright � 2009 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------------
UHandCannon01 = Class(import('/lua/BattlePackDefaultProjectiles.lua').SC2SinglePolyTrailProjectile) {
	FxImpactTrajectoryAligned =true,

        FxTrails = {
			'/effects/emitters/w_u_hcn01_p_01_firecloud_emit.bp',
			'/effects/emitters/w_u_hcn01_p_02_brightglow_emit.bp',
			'/effects/emitters/w_u_hcn01_p_06_glow_emit.bp',
			'/effects/emitters/w_u_hcn01_p_08_shockwave_emit.bp',
			'/effects/emitters/w_u_hcn01_p_09_smoketrail_emit.bp',
			'/effects/emitters/w_u_hcn01_p_10_distort_emit.bp',
        },

        FxImpactUnit = {
			'/effects/emitters/w_u_hcn01_i_u_01_flashflat_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_02_glow_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_03_glowhalf_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_04_sparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_05_halfring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_06_ring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_07_firecloud_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_08_fwdsparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_09_leftoverglows_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_10_leftoverwisps_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_11_darkring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_12_fwdsmoke_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_13_debris_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_14_lines_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_15_fastdirt_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_16_distortring_emit.bp',
        },
        FxImpactLand = {
			'/effects/emitters/w_u_hcn01_i_u_01_flashflat_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_02_glow_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_03_glowhalf_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_04_sparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_05_halfring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_06_ring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_07_firecloud_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_08_fwdsparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_09_leftoverglows_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_10_leftoverwisps_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_11_darkring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_12_fwdsmoke_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_13_debris_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_14_lines_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_15_fastdirt_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_16_distortring_emit.bp',
        },
        FxImpactWater = {
			'/effects/emitters/w_u_hcn01_i_u_01_flashflat_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_02_glow_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_03_glowhalf_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_04_sparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_05_halfring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_06_ring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_07_firecloud_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_08_fwdsparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_09_leftoverglows_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_10_leftoverwisps_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_11_darkring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_12_fwdsmoke_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_13_debris_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_14_lines_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_15_fastdirt_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_16_distortring_emit.bp',
        },
        FxImpactProp = {
			'/effects/emitters/w_u_hcn01_i_u_01_flashflat_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_02_glow_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_03_glowhalf_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_04_sparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_05_halfring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_06_ring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_07_firecloud_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_08_fwdsparks_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_09_leftoverglows_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_10_leftoverwisps_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_11_darkring_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_12_fwdsmoke_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_13_debris_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_14_lines_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_15_fastdirt_emit.bp',
			'/effects/emitters/w_u_hcn01_i_u_16_distortring_emit.bp',
        },
	FxTrailScale = 0.5,
    FxLandHitScale = 0.3,
    FxPropHitScale = 0.3,
    FxUnitHitScale = 0.3,
    FxImpactUnderWater = {},
    FxSplatScale = 1,

}
TypeClass = UHandCannon01