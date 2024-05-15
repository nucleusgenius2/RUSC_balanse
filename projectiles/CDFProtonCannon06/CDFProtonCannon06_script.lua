------------------------------------------------------------------------------
-- File     :  /data/projectiles/CDFProtonCannon05/CDFProtonCannon05_script.lua
-- Author(s):  Gordon Duclos, Matt Vainio
-- Summary  :  Cybran Proton Artillery projectile script, XRL0403
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------------

local CDFProtonCannon05 = import("/projectiles/CDFProtonCannon05/CDFProtonCannon05_script.lua").CDFProtonCannon05
CDFProtonCannon06 = ClassProjectile(CDFProtonCannon05) {
	FxTrailScale = 2,
}
TypeClass = CDFProtonCannon06
