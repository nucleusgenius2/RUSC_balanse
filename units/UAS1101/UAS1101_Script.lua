--****************************************************************************
--** 
--**  File     :  /cdimage/units/UAC1101/UAC1101_script.lua 
--**  Author(s):  John Comes, David Tomandl 
--** 
--**  Summary  :  Aeon Residential Structure, Ver1
--** 
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

---@class UAC1101 : AStructureUnit
UAS1101 = ClassUnit(AStructureUnit) {

	BoneB01 = 'Energy_Beam_01',
	BoneSetE01 = {
		'Energy_Beam_02',
		'Energy_Beam_03',
		'Energy_Beam_04',		
		'Energy_Beam_05',
		'Energy_Beam_06',				
		'Energy_Beam_07',			
	},
	BoneB02 = 'Energy_Beam_08',
	BoneSetE02 = {
		'Energy_Beam_09',
		'Energy_Beam_10',
		'Energy_Beam_11',		
		'Energy_Beam_12',
		'Energy_Beam_13',				
		'Energy_Beam_14',			
	},	
	FxBeamAmbient = '/effects/emitters/structure_beam_ambient_01_emit.bp',

    OnCreate = function(self)
		AStructureUnit.OnCreate(self)
		local army = self:GetArmy()
		for k, v in self.BoneSetE01 do
			AttachBeamEntityToEntity(self, self.BoneB01, self, v, army, self.FxBeamAmbient ) 
		end
		for k, v in self.BoneSetE02 do
			AttachBeamEntityToEntity(self, self.BoneB02, self, v, army, self.FxBeamAmbient ) 
		end
		
	--	while not self.Dead do

	--		local unitCat = ParseEntityCategory("BUILTBYTIER3FACTORY, BUILTBYQUANTUMGATE, NEEDMOBILEBUILD")
	--		unitCat = unitCat - ParseEntityCategory('OPTICS')
	--		local brain = self:GetAIBrain()
		--	local all = brain:GetUnitsAroundPoint(unitCat, self:GetPosition(), Radius, 'Ally')
	--		local units = {}

		--	for _, u in all do
		--		if not u.Dead and not u:IsBeingBuilt() then
		--			table.insert(units, u)
		--		end					
		--	end			
	--		for _, unit in allunits do
		--		Buff.ApplyBuff(unit, buff)
		--		unit:RequestRefreshUI()
	--			if unit:GetBlueprint().BlueprintId == 'uas1101' then
					
	--		end
				
	--		WaitTicks(31)
				
	--	end	
	--RemoveBuildRestriction('UAB0301', categories.SNIPER )
	
		
    end,
}


TypeClass = UAS1101


