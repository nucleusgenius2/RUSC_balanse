--UEF Goliath Assault Bot script by the Blackops team, revamped by Mithy
--rev. 4

local EffectUtil = import('/lua/EffectUtilities.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TWeapons = import('/lua/terranweapons.lua')
local Weapons2 = import('/lua/BlackOpsweapons.lua')
local TIFCruiseMissileUnpackingLauncher = TWeapons.TIFCruiseMissileUnpackingLauncher
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TANTorpedoLandWeapon = TWeapons.TANTorpedoLandWeapon
local GoliathTMDGun = Weapons2.GoliathTMDGun
local TDFGoliathShoulderBeam = Weapons2.TDFGoliathShoulderBeam
local TerranWeaponFile = import("/lua/terranweapons.lua")
local SCUDeathWeapon = import('/lua/sim/defaultweapons.lua').SCUDeathWeapon
local BattlePackWeaponFile = import('/lua/BattlePackweapons.lua')
local ExWifeMaincannonWeapon01 = BattlePackWeaponFile.ExWifeMaincannonWeapon01 
local BattlePackEffectTemplates = import('/lua/BattlePackEffectTemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Effects = import('/lua/effecttemplates.lua')
local Entity = import('/lua/sim/Entity.lua').Entity

local utilities = import('/lua/utilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = utilities.GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')

--local GoliathNukeEffect04 = '/projectiles/MGQAIPlasmaArty01/MGQAIPlasmaArty01_proj.bp' 
--local GoliathNukeEffect05 = '/effects/Entities/GoliathNukeEffect05/GoliathNukeEffect05_proj.bp'

local BlacOpsEffectTemplate = import('/lua/BlackOpsEffectTemplates.lua')

BEL0402 = Class(TWalkingLandUnit) {
	
	Weapons = {
		PlasmaCannon01 = Class(ExWifeMaincannonWeapon01) {
		},
		TMDTurret = Class(GoliathTMDGun) {
		},
		Laser = Class(TDFGoliathShoulderBeam) {
		},
		HeadWeapon = Class(TDFMachineGunWeapon){
		},
		DeathWeapon = Class(SCUDeathWeapon) {
        },
	},
}

TypeClass = BEL0402