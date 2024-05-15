#****************************************************************************
#**
#**  File     :  /data/projectiles/XCannon0105/XCannon0105_script.lua
#**  Author(s):  Gordon Duclos, Matt Vainio
#**
#**  Summary  :  Cybran Proton Artillery projectile script, XRL0403
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local XCannonProjectile = import('/lua/BlackOpsprojectiles.lua').XCannonProjectile
XCannon01 = Class(XCannonProjectile) {
	
	OnCreate = function(self)
        XCannonProjectile.OnCreate(self)
        self:ForkThread(self.ImpactWaterThread)
    end,
    
    ImpactWaterThread = function(self)
        WaitSeconds(0.3)
        self:SetDestroyOnWater(true)
    end,
}
TypeClass = XCannon01